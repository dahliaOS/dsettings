import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:dsettings/src/server/io_coordinator.dart';
import 'package:dsettings/src/server/objects/dsettings_table.dart';
import 'package:dsettings/src/server/table_xml.dart';
import 'package:dsettings/src/types.dart';
import 'package:dsettings/src/utils.dart';

class DSettingsTable extends DSettingsTableBase {
  final String name;
  final String? owner;
  final DTableEntries entries;
  late final IOCoordinator? coordinator;
  DSettingsScheme? scheme;

  String? get properOwner => owner != null && owner!.isNotEmpty ? owner : null;

  DSettingsTable({
    required this.name,
    required this.owner,
    this.scheme,
    this.coordinator,
    required this.entries,
  }) : super(path: DBusObjectPath("/io/dahlia/DSettings/Table/$name"));

  DSettingsTable copyWith({
    String? name,
    String? owner,
    DSettingsScheme? scheme,
    IOCoordinator? coordinator,
    DTableEntries? entries,
  }) {
    return DSettingsTable(
      name: name ?? this.name,
      owner: owner ?? this.owner,
      scheme: scheme ?? this.scheme,
      coordinator: coordinator ?? this.coordinator,
      entries: entries ?? this.entries,
    );
  }

  static Future<DSettingsTable?> newInstance(File file) async {
    return wrapWithCoordinator(file, DTableParser.parse);
  }

  static Future<DSettingsTable?> wrapWithCoordinator(
    File file,
    DSettingsTable? Function(String contents) builder,
  ) async {
    final IOCoordinator coordinator = await IOCoordinator.create();
    await coordinator.open(file);
    final String contents = await file.readAsString();

    final DSettingsTable? table = builder(contents);

    return table?.copyWith(coordinator: coordinator);
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    final bool callAllowed = await isCallAllowed(
      client,
      methodCall,
      properOwner,
      "io.dahlia.DSettings.Table",
      ["SetScheme"],
    );

    if (!callAllowed) {
      return DBusMethodErrorResponse.accessDenied(
        "Only '$properOwner' can call this method",
      );
    }

    return super.handleMethodCall(methodCall);
  }

  void writeToFile() {
    if (coordinator == null) return;

    coordinator!.write(DTableEncoder.encode(this).toXmlString(pretty: true));
  }

  Future<void> delete() async {
    await client?.unregisterObject(this);
    await coordinator?.delete();
  }

  Future<void> close() async {
    await client?.unregisterObject(this);
    coordinator?.close();
  }

  @override
  Future<DBusMethodResponse> doRead(String setting, bool returnRawValue) async {
    final DBusValue? value =
        readValue(setting, entries, scheme, returnRawValue);

    if (value == null) {
      return DBusMethodErrorResponse.invalidArgs("Setting $setting not found");
    }

    return DBusMethodSuccessResponse([DBusVariant(value)]);
  }

  @override
  Future<DBusMethodResponse> doReadBatch(
    List<String> settings,
    bool returnRawValues,
  ) async {
    return DBusMethodSuccessResponse([
      entries.toDBus(
        specificEntries: settings,
        scheme: scheme,
        returnRawValues: returnRawValues,
      ),
    ]);
  }

  @override
  Future<DBusMethodResponse> doWrite(String setting, DBusValue value) async {
    final DSettingsEntry? schemeEntry = scheme?.read(setting);

    if (schemeEntry != null) {
      final DSettingsTableType? type =
          DSettingsTableType.fromDBusSignature(value.signature);

      if (type != schemeEntry.type) {
        return DBusMethodErrorResponse.invalidArgs(
          "The passed value '$value' with signature '${value.signature.value}' does not "
          "conform to the scheme entry which specifies a signature '${schemeEntry.type.signature}'",
        );
      }
    }

    entries.write(setting, value);
    emitSettingsWritten({setting: value});

    writeToFile();

    return DBusMethodSuccessResponse();
  }

  @override
  Future<DBusMethodResponse> doWriteBatch(
    Map<String, DBusValue> settings,
  ) async {
    final Map<String, bool> result = {};
    final Map<String, DBusValue> actualSettings = {};

    if (scheme != null) {
      settings.forEach((key, value) {
        final DSettingsEntry? schemeEntry = scheme?.read(key);

        if (schemeEntry != null) {
          final DSettingsTableType? type =
              DSettingsTableType.fromDBusSignature(value.signature);

          result[key] = type == schemeEntry.type;
          if (type == schemeEntry.type) {
            actualSettings[key] = value;
          }
        }
      });
    } else {
      actualSettings.addAll(settings);
    }

    entries.writeBatch(actualSettings);
    emitSettingsWritten(actualSettings);

    writeToFile();

    return DBusMethodSuccessResponse([
      DBusDict(
        DBusSignature.string,
        DBusSignature.boolean,
        result.map(
          (key, value) => MapEntry(DBusString(key), DBusBoolean(value)),
        ),
      ),
    ]);
  }

  @override
  Future<DBusMethodResponse> doDelete(String setting) async {
    if (!entries.contains(name)) {
      return DBusMethodErrorResponse.invalidArgs(
        "The setting '$setting' can't be deleted as it doesn't exist.",
      );
    }

    entries.remove(setting);
    emitSettingsDeleted([setting]);

    writeToFile();

    return DBusMethodSuccessResponse();
  }

  @override
  Future<DBusMethodResponse> doDeleteBatch(List<String> settings) async {
    final List<String> deletedSettings = [];

    for (final String setting in settings) {
      if (!entries.contains(setting)) continue;

      entries.remove(setting);
      deletedSettings.add(setting);
    }
    emitSettingsDeleted(deletedSettings);

    writeToFile();

    return DBusMethodSuccessResponse([DBusUint32(deletedSettings.length)]);
  }

  @override
  Future<DBusMethodResponse> doClear() async {
    entries.clear();
    emitSettingsCleared();

    writeToFile();

    return DBusMethodSuccessResponse();
  }

  @override
  Future<DBusMethodResponse> doGetScheme() async {
    if (scheme == null) return DBusMethodSuccessResponse();

    return DBusMethodSuccessResponse([scheme!.toDBus()]);
  }

  @override
  Future<DBusMethodResponse> doSetScheme(Map<String, DBusValue> scheme) async {
    final DSettingsScheme newScheme;

    try {
      newScheme = DSettingsScheme.fromDBus(scheme);
    } on DBusMethodErrorResponse catch (e) {
      return e;
    }

    final DSettingsScheme? currentScheme = this.scheme;
    final Map<String, DBusStruct> currentMappedScheme = currentScheme != null
        ? currentScheme.entries.map(
            (key, value) => MapEntry(
              key,
              DBusStruct([
                DBusUint32(value.type.index),
                DBusVariant(value.toDBus()),
              ]),
            ),
          )
        : {};

    if (scheme.isNotEmpty) {
      this.scheme = newScheme;
    } else {
      this.scheme = null;
    }

    emitSchemeUpdated(currentMappedScheme, scheme);
    writeToFile();

    return DBusMethodSuccessResponse();
  }

  @override
  Future<DBusMethodResponse> getOwner() async =>
      DBusGetPropertyResponse(DBusString(owner ?? ""));

  @override
  Future<DBusMethodResponse> getEntryCount() async =>
      DBusGetPropertyResponse(DBusInt64(entries.length));

  @override
  Future<DBusMethodResponse> getVersion() async =>
      DBusGetPropertyResponse(const DBusInt32(1));

  @override
  Map<String, Map<String, DBusValue>> get interfacesAndProperties => {
        'io.dahlia.DSettings.Table': {
          'EntryCount': DBusInt64(entries.length),
          'Owner': DBusString(owner ?? ""),
          'Version': const DBusInt32(1),
        },
        'org.freedesktop.DBus.Introspectable': {},
        'org.freedesktop.DBus.Peer': {},
        'org.freedesktop.DBus.Properties': {},
      };
}
