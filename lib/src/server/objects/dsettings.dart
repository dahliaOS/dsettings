// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object lib/io.dahlia.DSettings.xml

import 'package:dbus/dbus.dart';

class DSettingsBase extends DBusObject {
  /// Creates a new object to expose on [path].
  DSettingsBase({DBusObjectPath path = DBusObjectPath.root}) : super(path);

  /// Gets value of property io.dahlia.DSettings.TableCount
  Future<DBusMethodResponse> getTableCount() async {
    return DBusMethodErrorResponse.failed(
      'Get io.dahlia.DSettings.TableCount not implemented',
    );
  }

  /// Gets value of property io.dahlia.DSettings.Version
  Future<DBusMethodResponse> getVersion() async {
    return DBusMethodErrorResponse.failed(
      'Get io.dahlia.DSettings.Version not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.List()
  Future<DBusMethodResponse> doList() async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.List() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Get()
  Future<DBusMethodResponse> doGet(String name) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Get() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Create()
  Future<DBusMethodResponse> doCreate(
    String name,
    Map<String, DBusValue> scheme,
    String owner,
  ) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Create() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Drop()
  Future<DBusMethodResponse> doDrop(String name) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Drop() not implemented',
    );
  }

  /// Emits signal io.dahlia.DSettings.TableCreated
  Future<void> emitTableCreated(String name) async {
    await emitSignal('io.dahlia.DSettings', 'TableCreated', [DBusString(name)]);
  }

  /// Emits signal io.dahlia.DSettings.TableDropped
  Future<void> emitTableDropped(String name) async {
    await emitSignal('io.dahlia.DSettings', 'TableDropped', [DBusString(name)]);
  }

  /// Implementation of org.freedesktop.DBus.ObjectManager.GetManagedObjects()
  Future<DBusMethodResponse> doGetManagedObjects() async {
    return DBusMethodErrorResponse.failed(
      'org.freedesktop.DBus.ObjectManager.GetManagedObjects() not implemented',
    );
  }

  /// Emits signal org.freedesktop.DBus.ObjectManager.InterfacesAdded
  Future<void> emitInterfacesAdded_(
    String object,
    Map<String, Map<String, DBusValue>> interfaces,
  ) async {
    await emitSignal('org.freedesktop.DBus.ObjectManager', 'InterfacesAdded', [
      DBusObjectPath(object),
      DBusDict(
        DBusSignature('s'),
        DBusSignature('a{sv}'),
        interfaces.map(
          (key, value) =>
              MapEntry(DBusString(key), DBusDict.stringVariant(value)),
        ),
      )
    ]);
  }

  /// Emits signal org.freedesktop.DBus.ObjectManager.InterfacesRemoved
  Future<void> emitInterfacesRemoved_(
    String object,
    List<String> interfaces,
  ) async {
    await emitSignal(
      'org.freedesktop.DBus.ObjectManager',
      'InterfacesRemoved',
      [DBusObjectPath(object), DBusArray.string(interfaces)],
    );
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface(
        'io.dahlia.DSettings',
        methods: [
          DBusIntrospectMethod(
            'List',
            args: [
              DBusIntrospectArgument(
                DBusSignature('as'),
                DBusArgumentDirection.out,
                name: 'tables',
              )
            ],
          ),
          DBusIntrospectMethod(
            'Get',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'name',
              ),
              DBusIntrospectArgument(
                DBusSignature('o'),
                DBusArgumentDirection.out,
                name: 'path',
              )
            ],
          ),
          DBusIntrospectMethod(
            'Create',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'name',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.in_,
                name: 'scheme',
              ),
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'owner',
              )
            ],
          ),
          DBusIntrospectMethod(
            'Drop',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'name',
              )
            ],
          )
        ],
        signals: [
          DBusIntrospectSignal(
            'TableCreated',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.out,
                name: 'name',
              )
            ],
          ),
          DBusIntrospectSignal(
            'TableDropped',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.out,
                name: 'name',
              )
            ],
          )
        ],
        properties: [
          DBusIntrospectProperty(
            'TableCount',
            DBusSignature('t'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'Version',
            DBusSignature('u'),
            access: DBusPropertyAccess.read,
          )
        ],
      ),
      DBusIntrospectInterface(
        'org.freedesktop.DBus.ObjectManager',
        methods: [
          DBusIntrospectMethod(
            'GetManagedObjects',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{oa{sa{sv}}}'),
                DBusArgumentDirection.out,
                name: 'objects',
              )
            ],
          )
        ],
        signals: [
          DBusIntrospectSignal(
            'InterfacesAdded',
            args: [
              DBusIntrospectArgument(
                DBusSignature('o'),
                DBusArgumentDirection.out,
                name: 'object',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sa{sv}}'),
                DBusArgumentDirection.out,
                name: 'interfaces',
              )
            ],
          ),
          DBusIntrospectSignal(
            'InterfacesRemoved',
            args: [
              DBusIntrospectArgument(
                DBusSignature('o'),
                DBusArgumentDirection.out,
                name: 'object',
              ),
              DBusIntrospectArgument(
                DBusSignature('as'),
                DBusArgumentDirection.out,
                name: 'interfaces',
              )
            ],
          )
        ],
      )
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'io.dahlia.DSettings') {
      if (methodCall.name == 'List') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doList();
      } else if (methodCall.name == 'Get') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doGet(methodCall.values[0].asString());
      } else if (methodCall.name == 'Create') {
        if (methodCall.signature != DBusSignature('sa{sv}s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doCreate(
          methodCall.values[0].asString(),
          methodCall.values[1].asStringVariantDict(),
          methodCall.values[2].asString(),
        );
      } else if (methodCall.name == 'Drop') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doDrop(methodCall.values[0].asString());
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else if (methodCall.interface == 'org.freedesktop.DBus.ObjectManager') {
      if (methodCall.name == 'GetManagedObjects') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doGetManagedObjects();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'io.dahlia.DSettings') {
      if (name == 'TableCount') {
        return getTableCount();
      } else if (name == 'Version') {
        return getVersion();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.freedesktop.DBus.ObjectManager') {
      return DBusMethodErrorResponse.unknownProperty();
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(
    String interface,
    String name,
    DBusValue value,
  ) async {
    if (interface == 'io.dahlia.DSettings') {
      if (name == 'TableCount') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Version') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.freedesktop.DBus.ObjectManager') {
      return DBusMethodErrorResponse.unknownProperty();
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    final Map<String, DBusValue> properties = <String, DBusValue>{};
    if (interface == 'io.dahlia.DSettings') {
      properties['TableCount'] = (await getTableCount()).returnValues[0];
      properties['Version'] = (await getVersion()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
