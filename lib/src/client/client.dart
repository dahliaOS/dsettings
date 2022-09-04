import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:dsettings/src/client/objects/dsettings.dart';
import 'package:dsettings/src/client/objects/dsettings_table.dart';
import 'package:dsettings/src/types.dart';
import 'package:dsettings/src/utils.dart';

typedef DSettingsTableScheme = Map<String, DSettingsEntry>;
typedef DSettingsTableChangeCallback = void Function(String event);

class DSettings {
  final DBusClient client;
  late final DSettingsObject _object;
  late final StreamSubscription _tableCreatedSub;
  late final StreamSubscription _tableDroppedSub;

  final List<DSettingsTableChangeCallback> _tableCreatedSubscribers = [];
  final List<DSettingsTableChangeCallback> _tableDroppedSubscribers = [];

  DSettings({DBusClient? client}) : client = client ?? DBusClient.session() {
    _object = DSettingsObject(
      this.client,
      "io.dahlia.DSettings",
      DBusObjectPath("/io/dahlia/DSettings"),
    );
    _tableCreatedSub = _object.tableCreated.listen(_onTableCreated);
    _tableDroppedSub = _object.tableDropped.listen(_onTableDropped);
  }

  Future<void> close() async {
    await _tableCreatedSub.cancel();
    await _tableDroppedSub.cancel();

    _tableCreatedSubscribers.clear();
    _tableDroppedSubscribers.clear();
  }

  void addTableCreatedListener(DSettingsTableChangeCallback callback) {
    _tableCreatedSubscribers.add(callback);
  }

  void removeTableCreatedListener(DSettingsTableChangeCallback callback) {
    _tableCreatedSubscribers.remove(callback);
  }

  void _onTableCreated(DSettingsObjectTableCreated event) {
    for (final DSettingsTableChangeCallback sub in _tableCreatedSubscribers) {
      sub.call(event.name_);
    }
  }

  void addTableDroppedListener(DSettingsTableChangeCallback callback) {
    _tableDroppedSubscribers.add(callback);
  }

  void removeTableDroppedListener(DSettingsTableChangeCallback callback) {
    _tableDroppedSubscribers.remove(callback);
  }

  void _onTableDropped(DSettingsObjectTableDropped event) {
    for (final DSettingsTableChangeCallback sub in _tableDroppedSubscribers) {
      sub.call(event.name_);
    }
  }

  Future<List<String>> listTables() async => _object.callList();
  Future<void> createTable(
    String name, {
    Map<String, DSettingsEntry>? scheme,
    String? owner,
  }) {
    return _object.callCreate(
      name,
      scheme?.map(
            (key, value) => MapEntry(
              key,
              DBusVariant(value.toDBus()),
            ),
          ) ??
          {},
      owner ?? "",
    );
  }

  Future<void> dropTable(String name) {
    return _object.callDrop(name);
  }

  Future<DSettingsTable?> getTable(String name) async {
    try {
      final String path = await _object.callGet(name);

      return DSettingsTable._(DBusObjectPath(path), client: client);
    } on DBusMethodResponseException {
      return null;
    }
  }

  Future<int> get tableCount async => _object.getTableCount();
  Future<int> get version async => _object.getVersion();
}

typedef DSettingsTableSchemeUpdatedCallback = void Function(
  DSettingsTableScheme oldScheme,
  DSettingsTableScheme newScheme,
);

typedef DSettingsTableSettingsDeletedCallback = void Function(
  List<String> settings,
);

typedef DSettingsTableSettingsWrittenCallback = void Function(
  Map<String, DSettingsEntry> settings,
);

typedef DSettingsTableSettingsClearedCallback = void Function();

class DSettingsTable {
  final DBusClient client;
  late final DSettingsTableObject _object;
  late final StreamSubscription _schemeUpdateSub;
  late final StreamSubscription _settingsWrittenSub;
  late final StreamSubscription _settingsDeletedSub;
  late final StreamSubscription _settingsClearedSub;

  final List<DSettingsTableSchemeUpdatedCallback> _schemeUpdateSubscribers = [];
  final List<DSettingsTableSettingsDeletedCallback>
      _settingsDeletedSubscribers = [];
  final List<DSettingsTableSettingsWrittenCallback>
      _settingsWrittenSubscribers = [];
  final List<DSettingsTableSettingsClearedCallback>
      _settingsClearedSubscribers = [];

  DSettingsTable._(
    DBusObjectPath path, {
    DBusClient? client,
  }) : client = client ?? DBusClient.session() {
    _object = DSettingsTableObject(this.client, "io.dahlia.DSettings", path);
    _schemeUpdateSub = _object.schemeUpdated.listen(_onSchemeUpdated);
    _settingsDeletedSub = _object.settingsDeleted.listen(_onSettingsDeleted);
    _settingsWrittenSub = _object.settingsWritten.listen(_onSettingsWritten);
    _settingsClearedSub = _object.settingsCleared.listen(_onSettingsCleared);
  }

  Future<void> close() async {
    await _schemeUpdateSub.cancel();
    await _settingsWrittenSub.cancel();
    await _settingsDeletedSub.cancel();
    await _settingsClearedSub.cancel();

    _schemeUpdateSubscribers.clear();
    _settingsWrittenSubscribers.clear();
    _settingsDeletedSubscribers.clear();
    _settingsClearedSubscribers.clear();
  }

  void addSchemeUpdatedListener(DSettingsTableSchemeUpdatedCallback callback) {
    _schemeUpdateSubscribers.add(callback);
  }

  void removeSchemeUpdatedListener(
    DSettingsTableSchemeUpdatedCallback callback,
  ) {
    _schemeUpdateSubscribers.remove(callback);
  }

  void _onSchemeUpdated(DSettingsTableObjectSchemeUpdated event) {
    for (final DSettingsTableSchemeUpdatedCallback sub
        in _schemeUpdateSubscribers) {
      sub.call(
        DSettingsScheme.fromDBus(event.oldScheme).entries,
        DSettingsScheme.fromDBus(event.newScheme).entries,
      );
    }
  }

  void addSettingsDeletedListener(
    DSettingsTableSettingsDeletedCallback callback,
  ) {
    _settingsDeletedSubscribers.add(callback);
  }

  void removeSettingsDeletedListener(
    DSettingsTableSettingsDeletedCallback callback,
  ) {
    _settingsDeletedSubscribers.remove(callback);
  }

  void _onSettingsDeleted(DSettingsTableObjectSettingsDeleted event) {
    for (final DSettingsTableSettingsDeletedCallback sub
        in _settingsDeletedSubscribers) {
      sub.call(event.settings);
    }
  }

  void addSettingsWrittenListener(
    DSettingsTableSettingsWrittenCallback callback,
  ) {
    _settingsWrittenSubscribers.add(callback);
  }

  void removeSettingsWrittenListener(
    DSettingsTableSettingsWrittenCallback callback,
  ) {
    _settingsWrittenSubscribers.remove(callback);
  }

  void _onSettingsWritten(DSettingsTableObjectSettingsWritten event) {
    for (final DSettingsTableSettingsWrittenCallback sub
        in _settingsWrittenSubscribers) {
      sub.call(
        event.settings.map(
          (key, value) => MapEntry(key, valueToEntry(value)!),
        ),
      );
    }
  }

  void addSettingsClearedListener(
    DSettingsTableSettingsClearedCallback callback,
  ) {
    _settingsClearedSubscribers.add(callback);
  }

  void removeSettingsClearedListener(
    DSettingsTableSettingsClearedCallback callback,
  ) {
    _settingsClearedSubscribers.remove(callback);
  }

  void _onSettingsCleared(DSettingsTableObjectSettingsCleared event) {
    for (final DSettingsTableSettingsClearedCallback sub
        in _settingsClearedSubscribers) {
      sub.call();
    }
  }

  Future<DSettingsEntry?> read(
    String setting, {
    bool returnRawValue = false,
  }) async {
    try {
      final DBusValue value = await _object.callRead(setting, returnRawValue);

      return valueToEntry(value);
    } on DBusMethodResponseException {
      return null;
    }
  }

  Future<Map<String, DSettingsEntry?>> readBatch(
    List<String> settings, {
    bool returnRawValues = false,
  }) async {
    try {
      final Map<String, List<DBusValue>> values =
          await _object.callReadBatch(settings, returnRawValues);

      return values.map(
        (key, value) => MapEntry(
          key,
          value.length == 1 ? valueToEntry(value.single) : null,
        ),
      );
    } on DBusMethodResponseException {
      return {};
    }
  }

  Future<Map<String, DSettingsEntry>> readAll({
    bool returnRawValues = false,
  }) async {
    final Map<String, DSettingsEntry?> entries =
        await readBatch([], returnRawValues: returnRawValues);

    return entries.map((key, value) => MapEntry(key, value!));
  }

  Future<void> write<T>(String setting, T value) =>
      _object.callWrite(setting, valueToDBus(value));

  Future<Map<String, bool>> writeBatch(Map<String, Object> values) =>
      _object.callWriteBatch(
        values.map(
          (key, value) => MapEntry(key, valueToDBus(value)),
        ),
      );

  Future<void> clear() => _object.callClear();
  Future<void> delete(String setting) => _object.callDelete(setting);
  Future<int> deleteBatch(List<String> settings) =>
      _object.callDeleteBatch(settings);

  Future<DSettingsTableScheme?> getScheme() async {
    final Map<String, DBusValue> scheme = await _object.callGetScheme();
    if (scheme.isEmpty) return null;

    return DSettingsScheme.fromDBus(scheme).entries;
  }

  Future<void> setScheme(DSettingsTableScheme? scheme) => _object.callSetScheme(
        scheme != null
            ? scheme.map(
                (key, value) => MapEntry(
                  key,
                  value.toDBus(),
                ),
              )
            : {},
      );

  Future<int> get entryCount async => _object.getEntryCount();
  Future<String> get owner async => _object.getOwner();
  Future<int> get version async => _object.getVersion();
}
