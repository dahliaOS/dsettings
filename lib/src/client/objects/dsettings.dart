// This file was generated using the following command and may be overwritten.
// dart-dbus generate-remote-object lib/io.dahlia.DSettings.xml

import 'package:dbus/dbus.dart';

/// Signal data for io.dahlia.DSettings.TableCreated.
class DSettingsObjectTableCreated extends DBusSignal {
  String get name_ => values[0].asString();

  DSettingsObjectTableCreated(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

/// Signal data for io.dahlia.DSettings.TableDropped.
class DSettingsObjectTableDropped extends DBusSignal {
  String get name_ => values[0].asString();

  DSettingsObjectTableDropped(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

/// Signal data for org.freedesktop.DBus.ObjectManager.InterfacesAdded.
class DSettingsObjectInterfacesAdded extends DBusSignal {
  String get object => values[0].asObjectPath().value;
  Map<String, Map<String, DBusValue>> get interfaces => values[1].asDict().map(
        (key, value) => MapEntry(key.asString(), value.asStringVariantDict()),
      );

  DSettingsObjectInterfacesAdded(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

/// Signal data for org.freedesktop.DBus.ObjectManager.InterfacesRemoved.
class DSettingsObjectInterfacesRemoved extends DBusSignal {
  String get object => values[0].asObjectPath().value;
  List<String> get interfaces => values[1].asStringArray().toList();

  DSettingsObjectInterfacesRemoved(DBusSignal signal)
      : super(
          sender: signal.sender,
          path: signal.path,
          interface: signal.interface,
          name: signal.name,
          values: signal.values,
        );
}

class DSettingsObject extends DBusRemoteObject {
  /// Stream of io.dahlia.DSettings.TableCreated signals.
  late final Stream<DSettingsObjectTableCreated> tableCreated;

  /// Stream of io.dahlia.DSettings.TableDropped signals.
  late final Stream<DSettingsObjectTableDropped> tableDropped;

  /// Stream of org.freedesktop.DBus.ObjectManager.InterfacesAdded signals.
  late final Stream<DSettingsObjectInterfacesAdded> interfacesAdded;

  /// Stream of org.freedesktop.DBus.ObjectManager.InterfacesRemoved signals.
  late final Stream<DSettingsObjectInterfacesRemoved> interfacesRemoved;

  DSettingsObject(super.client, String destination, DBusObjectPath path)
      : super(name: destination, path: path) {
    tableCreated = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'io.dahlia.DSettings',
      name: 'TableCreated',
      signature: DBusSignature('s'),
    ).asBroadcastStream().map((signal) => DSettingsObjectTableCreated(signal));

    tableDropped = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'io.dahlia.DSettings',
      name: 'TableDropped',
      signature: DBusSignature('s'),
    ).asBroadcastStream().map((signal) => DSettingsObjectTableDropped(signal));

    interfacesAdded = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'org.freedesktop.DBus.ObjectManager',
      name: 'InterfacesAdded',
      signature: DBusSignature('oa{sa{sv}}'),
    )
        .asBroadcastStream()
        .map((signal) => DSettingsObjectInterfacesAdded(signal));

    interfacesRemoved = DBusRemoteObjectSignalStream(
      object: this,
      interface: 'org.freedesktop.DBus.ObjectManager',
      name: 'InterfacesRemoved',
      signature: DBusSignature('oas'),
    )
        .asBroadcastStream()
        .map((signal) => DSettingsObjectInterfacesRemoved(signal));
  }

  /// Gets io.dahlia.DSettings.TableCount
  Future<int> getTableCount() async {
    final DBusValue value = await getProperty(
      'io.dahlia.DSettings',
      'TableCount',
      signature: DBusSignature('t'),
    );
    return value.asUint64();
  }

  /// Gets io.dahlia.DSettings.Version
  Future<int> getVersion() async {
    final DBusValue value = await getProperty(
      'io.dahlia.DSettings',
      'Version',
      signature: DBusSignature('u'),
    );
    return value.asUint32();
  }

  /// Invokes io.dahlia.DSettings.List()
  Future<List<String>> callList({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings',
      'List',
      [],
      replySignature: DBusSignature('as'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asStringArray().toList();
  }

  /// Invokes io.dahlia.DSettings.Get()
  Future<String> callGet(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'io.dahlia.DSettings',
      'Get',
      [DBusString(name)],
      replySignature: DBusSignature('o'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asObjectPath().value;
  }

  /// Invokes io.dahlia.DSettings.Create()
  Future<void> callCreate(
    String name,
    Map<String, DBusValue> scheme,
    String owner, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'io.dahlia.DSettings',
      'Create',
      [DBusString(name), DBusDict.stringVariant(scheme), DBusString(owner)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes io.dahlia.DSettings.Drop()
  Future<void> callDrop(
    String name, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      'io.dahlia.DSettings',
      'Drop',
      [DBusString(name)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.freedesktop.DBus.ObjectManager.GetManagedObjects()
  Future<Map<String, Map<String, Map<String, DBusValue>>>>
      callGetManagedObjects({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    final DBusMethodSuccessResponse result = await callMethod(
      'org.freedesktop.DBus.ObjectManager',
      'GetManagedObjects',
      [],
      replySignature: DBusSignature('a{oa{sa{sv}}}'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asDict().map(
          (key, value) => MapEntry(
            key.asObjectPath().value,
            value.asDict().map(
                  (key, value) =>
                      MapEntry(key.asString(), value.asStringVariantDict()),
                ),
          ),
        );
  }
}
