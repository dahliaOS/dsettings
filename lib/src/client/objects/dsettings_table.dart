// This file was generated using the following command and may be overwritten.
// dart-dbus generate-remote-object lib/specifications/io.dahlia.DSettings.Table.xml

import 'package:dbus/dbus.dart';

/// Signal data for io.dahlia.DSettings.Table.SettingsWritten.
class DSettingsTableObjectSettingsWritten extends DBusSignal {
  Map<String, DBusValue> get settings => values[0].asStringVariantDict();

  DSettingsTableObjectSettingsWritten(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

/// Signal data for io.dahlia.DSettings.Table.SettingsDeleted.
class DSettingsTableObjectSettingsDeleted extends DBusSignal {
  List<String> get settings => values[0].asStringArray().toList();

  DSettingsTableObjectSettingsDeleted(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

/// Signal data for io.dahlia.DSettings.Table.SettingsCleared.
class DSettingsTableObjectSettingsCleared extends DBusSignal {
  DSettingsTableObjectSettingsCleared(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

/// Signal data for io.dahlia.DSettings.Table.SchemeUpdated.
class DSettingsTableObjectSchemeUpdated extends DBusSignal {
  Map<String, DBusValue> get oldScheme => values[0].asStringVariantDict();
  Map<String, DBusValue> get newScheme => values[1].asStringVariantDict();

  DSettingsTableObjectSchemeUpdated(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

class DSettingsTableObject extends DBusRemoteObject {
  /// Stream of io.dahlia.DSettings.Table.SettingsWritten signals.
  late final Stream<DSettingsTableObjectSettingsWritten> settingsWritten;

  /// Stream of io.dahlia.DSettings.Table.SettingsDeleted signals.
  late final Stream<DSettingsTableObjectSettingsDeleted> settingsDeleted;

  /// Stream of io.dahlia.DSettings.Table.SettingsCleared signals.
  late final Stream<DSettingsTableObjectSettingsCleared> settingsCleared;

  /// Stream of io.dahlia.DSettings.Table.SchemeUpdated signals.
  late final Stream<DSettingsTableObjectSchemeUpdated> schemeUpdated;

  DSettingsTableObject(
    super.client,
    String destination,
    DBusObjectPath path,
  ) : super(name: destination, path: path) {
    settingsWritten = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'io.dahlia.DSettings.Table',
      name: 'SettingsWritten',
      signature: DBusSignature('a{sv}'),
    )
        .asBroadcastStream()
        .map((signal) => DSettingsTableObjectSettingsWritten(signal));

    settingsDeleted = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'io.dahlia.DSettings.Table',
      name: 'SettingsDeleted',
      signature: DBusSignature('as'),
    )
        .asBroadcastStream()
        .map((signal) => DSettingsTableObjectSettingsDeleted(signal));

    settingsCleared = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'io.dahlia.DSettings.Table',
      name: 'SettingsCleared',
      signature: DBusSignature(''),
    )
        .asBroadcastStream()
        .map((signal) => DSettingsTableObjectSettingsCleared(signal));

    schemeUpdated = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'io.dahlia.DSettings.Table',
      name: 'SchemeUpdated',
      signature: DBusSignature('a{sv}a{sv}'),
    )
        .asBroadcastStream()
        .map((signal) => DSettingsTableObjectSchemeUpdated(signal));
  }

  /// Gets io.dahlia.DSettings.Table.EntryCount
  Future<int> getEntryCount() async {
    final DBusValue value = await getProperty(
      'io.dahlia.DSettings.Table',
      'EntryCount',
      signature: DBusSignature('t'),
    );
    return value.asUint64();
  }

  /// Gets io.dahlia.DSettings.Table.Owner
  Future<String> getOwner() async {
    final DBusValue value = await getProperty(
      'io.dahlia.DSettings.Table',
      'Owner',
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  /// Gets io.dahlia.DSettings.Table.Version
  Future<int> getVersion() async {
    final DBusValue value = await getProperty(
      'io.dahlia.DSettings.Table',
      'Version',
      signature: DBusSignature('u'),
    );
    return value.asUint32();
  }

  /// Invokes io.dahlia.DSettings.Table.Read()
  Future<DBusValue> callRead(
    String setting,
    bool returnRawValue, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings.Table',
      'Read',
      [DBusString(setting), DBusBoolean(returnRawValue)],
      replySignature: DBusSignature('v'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asVariant();
  }

  /// Invokes io.dahlia.DSettings.Table.ReadBatch()
  Future<Map<String, List<DBusValue>>> callReadBatch(
    List<String> settings,
    bool returnRawValues, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings.Table',
      'ReadBatch',
      [DBusArray.string(settings), DBusBoolean(returnRawValues)],
      replySignature: DBusSignature('a{sav}'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asDict().map(
          (key, value) =>
              MapEntry(key.asString(), value.asVariantArray().toList()),
        );
  }

  /// Invokes io.dahlia.DSettings.Table.Write()
  Future<void> callWrite(
    String setting,
    DBusValue value, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'io.dahlia.DSettings.Table',
      'Write',
      [DBusString(setting), DBusVariant(value)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes io.dahlia.DSettings.Table.WriteBatch()
  Future<Map<String, bool>> callWriteBatch(
    Map<String, DBusValue> settings, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings.Table',
      'WriteBatch',
      [DBusDict.stringVariant(settings)],
      replySignature: DBusSignature('a{sb}'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0]
        .asDict()
        .map((key, value) => MapEntry(key.asString(), value.asBoolean()));
  }

  /// Invokes io.dahlia.DSettings.Table.Delete()
  Future<void> callDelete(
    String setting, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'io.dahlia.DSettings.Table',
      'Delete',
      [DBusString(setting)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes io.dahlia.DSettings.Table.DeleteBatch()
  Future<int> callDeleteBatch(
    List<String> settings, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings.Table',
      'DeleteBatch',
      [DBusArray.string(settings)],
      replySignature: DBusSignature('u'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asUint32();
  }

  /// Invokes io.dahlia.DSettings.Table.Clear()
  Future<void> callClear({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'io.dahlia.DSettings.Table',
      'Clear',
      [],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes io.dahlia.DSettings.Table.SetScheme()
  Future<void> callSetScheme(
    Map<String, DBusValue> scheme, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'io.dahlia.DSettings.Table',
      'SetScheme',
      [DBusDict.stringVariant(scheme)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes io.dahlia.DSettings.Table.GetScheme()
  Future<Map<String, DBusValue>> callGetScheme({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings.Table',
      'GetScheme',
      [],
      replySignature: DBusSignature('a{sv}'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asStringVariantDict();
  }
}
