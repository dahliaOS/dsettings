import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dbus/dbus.dart';
import 'package:dsettings/src/server/dsettings_table.dart';
import 'package:dsettings/src/server/objects/dsettings.dart';
import 'package:dsettings/src/server/table_xml.dart';
import 'package:dsettings/src/types.dart';
import 'package:dsettings/src/utils.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

class DSettings extends DSettingsBase {
  final Directory directory;
  final List<DSettingsTable> tables;

  DSettings._(this.directory, this.tables)
      : super(path: DBusObjectPath("/io/dahlia/DSettings"));

  static Future<DSettings> newInstance(Directory directory) async {
    final List<FileSystemEntity> entities = directory.listSync();
    final List<File> files = entities
        .whereType<File>()
        .where((e) => p.extension(e.path) == ".dtable")
        .toList();

    final List<DSettingsTable> tables = [];
    for (final File file in files) {
      final DSettingsTable? table = await DSettingsTable.newInstance(file);

      if (table == null) continue;

      tables.add(table);
    }

    return DSettings._(directory, tables);
  }

  Future<void> registerTables() async {
    if (client == null) return;

    for (final DSettingsTable element in tables) {
      if (element.client != null) continue;

      await client!.registerObject(element);
    }
  }

  Future<void> close() async {
    for (final DSettingsTable element in tables) {
      await element.close();
    }
    client?.unregisterObject(this);
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.values.isNotEmpty) {
      final String tableName = methodCall.values.first.asString();
      final String? owner =
          tables.firstWhereOrNull((e) => e.name == tableName)?.properOwner;

      final bool callAllowed = await isCallAllowed(
        client,
        methodCall,
        owner,
        "io.dahlia.DSettings",
        ["Drop"],
      );

      if (!callAllowed) {
        return DBusMethodErrorResponse.accessDenied(
          "Only '$owner' can call this method",
        );
      }
    }

    return super.handleMethodCall(methodCall);
  }

  @override
  Future<DBusMethodResponse> doList() async {
    return DBusMethodSuccessResponse([
      DBusArray.string(tables.map((e) => e.name)),
    ]);
  }

  @override
  Future<DBusMethodResponse> doGet(String name) async {
    final DSettingsTable? table =
        tables.firstWhereOrNull((e) => e.name == name);

    if (table != null) return DBusMethodSuccessResponse([table.path]);

    return DBusMethodErrorResponse.failed("The table $name was not found");
  }

  @override
  Future<DBusMethodResponse> doDrop(String name) async {
    final int indexOf = tables.indexWhere((element) => element.name == name);

    if (indexOf < 0) {
      return DBusMethodErrorResponse.invalidArgs(
        "The specified table $name hasn't been found",
      );
    }

    final DSettingsTable table = tables.removeAt(indexOf);
    await table.delete();
    emitInterfacesRemoved(table.path, table.interfacesAndProperties.keys);
    emitTableDropped(name);

    return DBusMethodSuccessResponse();
  }

  @override
  Future<DBusMethodResponse> doCreate(
    String name,
    Map<String, DBusValue> scheme,
    String owner,
  ) async {
    final DSettingsScheme parsedScheme;

    try {
      parsedScheme = DSettingsScheme.fromDBus(scheme);
    } on DBusMethodErrorResponse catch (e) {
      return e;
    }

    final DSettingsTable table = DSettingsTable(
      name: name,
      owner: owner,
      scheme: parsedScheme,
      entries: DTableEntries(entries: {}),
    );
    final XmlDocument doc = DTableEncoder.encode(table);
    final File file = File(p.join(directory.path, "${uuid.v4()}.dtable"));
    await file.writeAsString(doc.toXmlString(pretty: true));
    final DSettingsTable? wrapped =
        await DSettingsTable.wrapWithCoordinator(file, (_) => table);

    tables.add(wrapped!);
    await registerTables();
    emitTableCreated(name);
    emitInterfacesAdded(table.path, table.interfacesAndProperties);

    return DBusMethodSuccessResponse();
  }

  @override
  Future<DBusMethodResponse> getTableCount() async {
    return DBusGetPropertyResponse(DBusUint64(tables.length));
  }

  @override
  Future<DBusMethodResponse> getVersion() async {
    return DBusGetPropertyResponse(const DBusInt32(1));
  }

  @override
  Future<DBusMethodResponse> doGetManagedObjects() async {
    return DBusMethodSuccessResponse([
      DBusDict(
        DBusSignature.objectPath,
        DBusSignature.dict(
          DBusSignature.string,
          DBusSignature.dict(
            DBusSignature.string,
            DBusSignature.variant,
          ),
        ),
        Map.fromEntries(
          tables.map(
            (e) => MapEntry(
              e.path,
              DBusDict(
                DBusSignature.string,
                DBusSignature.dict(
                  DBusSignature.string,
                  DBusSignature.variant,
                ),
                e.interfacesAndProperties.map(
                  (key, value) => MapEntry(
                    DBusString(key),
                    DBusDict.stringVariant(value),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
