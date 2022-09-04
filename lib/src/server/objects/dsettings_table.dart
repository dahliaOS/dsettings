// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object lib/specifications/io.dahlia.DSettings.Table.xml

import 'package:dbus/dbus.dart';

class DSettingsTableBase extends DBusObject {
  /// Creates a new object to expose on [path].
  DSettingsTableBase({DBusObjectPath path = DBusObjectPath.root}) : super(path);

  /// Gets value of property io.dahlia.DSettings.Table.EntryCount
  Future<DBusMethodResponse> getEntryCount() async {
    return DBusMethodErrorResponse.failed(
      'Get io.dahlia.DSettings.Table.EntryCount not implemented',
    );
  }

  /// Gets value of property io.dahlia.DSettings.Table.Owner
  Future<DBusMethodResponse> getOwner() async {
    return DBusMethodErrorResponse.failed(
      'Get io.dahlia.DSettings.Table.Owner not implemented',
    );
  }

  /// Gets value of property io.dahlia.DSettings.Table.Version
  Future<DBusMethodResponse> getVersion() async {
    return DBusMethodErrorResponse.failed(
      'Get io.dahlia.DSettings.Table.Version not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.Read()
  Future<DBusMethodResponse> doRead(String setting, bool returnRawValue) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.Read() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.ReadBatch()
  Future<DBusMethodResponse> doReadBatch(
    List<String> settings,
    bool returnRawValues,
  ) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.ReadBatch() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.Write()
  Future<DBusMethodResponse> doWrite(String setting, DBusValue value) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.Write() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.WriteBatch()
  Future<DBusMethodResponse> doWriteBatch(
    Map<String, DBusValue> settings,
  ) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.WriteBatch() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.Delete()
  Future<DBusMethodResponse> doDelete(String setting) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.Delete() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.DeleteBatch()
  Future<DBusMethodResponse> doDeleteBatch(List<String> settings) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.DeleteBatch() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.Clear()
  Future<DBusMethodResponse> doClear() async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.Clear() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.SetScheme()
  Future<DBusMethodResponse> doSetScheme(Map<String, DBusValue> scheme) async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.SetScheme() not implemented',
    );
  }

  /// Implementation of io.dahlia.DSettings.Table.GetScheme()
  Future<DBusMethodResponse> doGetScheme() async {
    return DBusMethodErrorResponse.failed(
      'io.dahlia.DSettings.Table.GetScheme() not implemented',
    );
  }

  /// Emits signal io.dahlia.DSettings.Table.SettingsWritten
  Future<void> emitSettingsWritten(Map<String, DBusValue> settings) async {
    await emitSignal(
      'io.dahlia.DSettings.Table',
      'SettingsWritten',
      [DBusDict.stringVariant(settings)],
    );
  }

  /// Emits signal io.dahlia.DSettings.Table.SettingsDeleted
  Future<void> emitSettingsDeleted(List<String> settings) async {
    await emitSignal(
      'io.dahlia.DSettings.Table',
      'SettingsDeleted',
      [DBusArray.string(settings)],
    );
  }

  /// Emits signal io.dahlia.DSettings.Table.SettingsCleared
  Future<void> emitSettingsCleared() async {
    await emitSignal('io.dahlia.DSettings.Table', 'SettingsCleared', []);
  }

  /// Emits signal io.dahlia.DSettings.Table.SchemeUpdated
  Future<void> emitSchemeUpdated(
    Map<String, DBusValue> oldScheme,
    Map<String, DBusValue> newScheme,
  ) async {
    await emitSignal(
      'io.dahlia.DSettings.Table',
      'SchemeUpdated',
      [DBusDict.stringVariant(oldScheme), DBusDict.stringVariant(newScheme)],
    );
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface(
        'io.dahlia.DSettings.Table',
        methods: [
          DBusIntrospectMethod(
            'Read',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'setting',
              ),
              DBusIntrospectArgument(
                DBusSignature('b'),
                DBusArgumentDirection.in_,
                name: 'return_raw_value',
              ),
              DBusIntrospectArgument(
                DBusSignature('v'),
                DBusArgumentDirection.out,
                name: 'result',
              )
            ],
          ),
          DBusIntrospectMethod(
            'ReadBatch',
            args: [
              DBusIntrospectArgument(
                DBusSignature('as'),
                DBusArgumentDirection.in_,
                name: 'settings',
              ),
              DBusIntrospectArgument(
                DBusSignature('b'),
                DBusArgumentDirection.in_,
                name: 'return_raw_values',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sav}'),
                DBusArgumentDirection.out,
                name: 'result',
              )
            ],
          ),
          DBusIntrospectMethod(
            'Write',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'setting',
              ),
              DBusIntrospectArgument(
                DBusSignature('v'),
                DBusArgumentDirection.in_,
                name: 'value',
              )
            ],
          ),
          DBusIntrospectMethod(
            'WriteBatch',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.in_,
                name: 'settings',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sb}'),
                DBusArgumentDirection.out,
                name: 'result',
              )
            ],
          ),
          DBusIntrospectMethod(
            'Delete',
            args: [
              DBusIntrospectArgument(
                DBusSignature('s'),
                DBusArgumentDirection.in_,
                name: 'setting',
              )
            ],
          ),
          DBusIntrospectMethod(
            'DeleteBatch',
            args: [
              DBusIntrospectArgument(
                DBusSignature('as'),
                DBusArgumentDirection.in_,
                name: 'settings',
              ),
              DBusIntrospectArgument(
                DBusSignature('u'),
                DBusArgumentDirection.out,
                name: 'count',
              )
            ],
          ),
          DBusIntrospectMethod('Clear'),
          DBusIntrospectMethod(
            'SetScheme',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.in_,
                name: 'scheme',
              )
            ],
          ),
          DBusIntrospectMethod(
            'GetScheme',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.out,
                name: 'scheme',
              )
            ],
          )
        ],
        signals: [
          DBusIntrospectSignal(
            'SettingsWritten',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.out,
                name: 'settings',
              )
            ],
          ),
          DBusIntrospectSignal(
            'SettingsDeleted',
            args: [
              DBusIntrospectArgument(
                DBusSignature('as'),
                DBusArgumentDirection.out,
                name: 'settings',
              )
            ],
          ),
          DBusIntrospectSignal('SettingsCleared'),
          DBusIntrospectSignal(
            'SchemeUpdated',
            args: [
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.out,
                name: 'old_scheme',
              ),
              DBusIntrospectArgument(
                DBusSignature('a{sv}'),
                DBusArgumentDirection.out,
                name: 'new_scheme',
              )
            ],
          )
        ],
        properties: [
          DBusIntrospectProperty(
            'EntryCount',
            DBusSignature('t'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'Owner',
            DBusSignature('s'),
            access: DBusPropertyAccess.read,
          ),
          DBusIntrospectProperty(
            'Version',
            DBusSignature('u'),
            access: DBusPropertyAccess.read,
          )
        ],
      )
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'io.dahlia.DSettings.Table') {
      if (methodCall.name == 'Read') {
        if (methodCall.signature != DBusSignature('sb')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRead(
          methodCall.values[0].asString(),
          methodCall.values[1].asBoolean(),
        );
      } else if (methodCall.name == 'ReadBatch') {
        if (methodCall.signature != DBusSignature('asb')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doReadBatch(
          methodCall.values[0].asStringArray().toList(),
          methodCall.values[1].asBoolean(),
        );
      } else if (methodCall.name == 'Write') {
        if (methodCall.signature != DBusSignature('sv')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doWrite(
          methodCall.values[0].asString(),
          methodCall.values[1].asVariant(),
        );
      } else if (methodCall.name == 'WriteBatch') {
        if (methodCall.signature != DBusSignature('a{sv}')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doWriteBatch(methodCall.values[0].asStringVariantDict());
      } else if (methodCall.name == 'Delete') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doDelete(methodCall.values[0].asString());
      } else if (methodCall.name == 'DeleteBatch') {
        if (methodCall.signature != DBusSignature('as')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doDeleteBatch(methodCall.values[0].asStringArray().toList());
      } else if (methodCall.name == 'Clear') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doClear();
      } else if (methodCall.name == 'SetScheme') {
        if (methodCall.signature != DBusSignature('a{sv}')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetScheme(methodCall.values[0].asStringVariantDict());
      } else if (methodCall.name == 'GetScheme') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doGetScheme();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'io.dahlia.DSettings.Table') {
      if (name == 'EntryCount') {
        return getEntryCount();
      } else if (name == 'Owner') {
        return getOwner();
      } else if (name == 'Version') {
        return getVersion();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
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
    if (interface == 'io.dahlia.DSettings.Table') {
      if (name == 'EntryCount') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Owner') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Version') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    final Map<String, DBusValue> properties = <String, DBusValue>{};
    if (interface == 'io.dahlia.DSettings.Table') {
      properties['EntryCount'] = (await getEntryCount()).returnValues[0];
      properties['Owner'] = (await getOwner()).returnValues[0];
      properties['Version'] = (await getVersion()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
