import 'package:collection/collection.dart';
import 'package:dbus/dbus.dart';
import 'package:dsettings/src/utils.dart';

abstract class DTableDict {
  final String name;
  final Map<String, DSettingsEntry> entries = {};

  DTableDict({
    required this.name,
    required Map<String, DSettingsEntry> entries,
  }) {
    this.entries.addAll(entries);
  }

  DBusValue toDBus();

  int get length => entries.length;
  bool contains(String name) => entries.containsKey(name);
  void remove(String name) => entries.remove(name);
  void clear() => entries.clear();
  DSettingsEntry? read(String name) => entries[name];
}

class DTableEntries extends DTableDict {
  DTableEntries({required super.entries}) : super(name: "entries");

  @override
  DBusValue toDBus({
    List<String>? specificEntries,
    DSettingsScheme? scheme,
    bool returnRawValues = false,
  }) {
    final List<String> allEntries = this.entries.keys.toList();
    if (scheme != null) allEntries.addAll(scheme.entries.keys);

    final Iterable<String> entries =
        specificEntries != null && specificEntries.isNotEmpty
            ? specificEntries
            : allEntries.toSet();

    return DBusDict(
      DBusSignature.string,
      DBusSignature.array(DBusSignature.variant),
      Map.fromEntries(
        entries.map((e) {
          final DBusValue? value = readValue(e, this, scheme, returnRawValues);

          return MapEntry(
            DBusString(e),
            DBusArray.variant([if (value != null) value]),
          );
        }),
      ),
    );
  }

  void writeBatch(Map<String, DBusValue> values) {
    values.forEach(write);
  }

  void write(String name, DBusValue value) {
    final Object? nativeValue = extractValue(value);
    if (nativeValue == null) return;

    final DSettingsTableType type = DSettingsTableType.fromValue(nativeValue)!;

    entries[name] = DSettingsEntry(type, nativeValue);
  }
}

class DSettingsScheme extends DTableDict {
  DSettingsScheme({required super.entries}) : super(name: "scheme");

  factory DSettingsScheme.fromDBus(Map<String, DBusValue> dbusValue) {
    final Map<String, DSettingsEntry> entries = {};

    dbusValue.forEach((key, value) {
      final Object? nativeValue = extractValue(value);
      if (nativeValue == null) {
        _throwForInvalidType(key, value);
      }

      final DSettingsTableType? type =
          DSettingsTableType.fromValue(nativeValue);
      if (type == null || type == DSettingsTableType.any) {
        _throwForInvalidType(key, value);
      }

      entries[key] = DSettingsEntry(type, nativeValue);
    });

    return DSettingsScheme(entries: entries);
  }

  static Never _throwForInvalidType(String key, DBusValue value) {
    throw DBusMethodErrorResponse.invalidArgs(
      "The signature '${value.signature.value}' is not valid for entry '$key'. It must match one of these: 's', 'i', 'd', 'b', 'as'.",
    );
  }

  @override
  DBusValue toDBus() {
    return DBusDict.stringVariant(
      entries.map(
        (key, value) => MapEntry(
          key,
          DBusVariant(value.toDBus()),
        ),
      ),
    );
  }
}

class DSettingsEntry<T> {
  final DSettingsTableType<T> type;
  final T value;

  const DSettingsEntry(this.type, this.value);

  DBusValue toDBus() => convertToDBus(type, value);
}

enum DSettingsTableType<T extends Object?> {
  any<Object?>('*'),
  string<String>('s'),
  integer<int>('i'),
  float<double>('d', 'double'),
  boolean<bool>('b'),
  stringArray<List<String>>('as');

  static DSettingsTableType? fromValue(Object? value) {
    bool canCastToString(List val) {
      try {
        val.cast<String>();
        return true;
      } catch (e) {
        return false;
      }
    }

    return switch (value) {
      null => null,
      String() => DSettingsTableType.string,
      int() => DSettingsTableType.integer,
      double() => DSettingsTableType.float,
      bool() => DSettingsTableType.boolean,
      List() => canCastToString(value) ? DSettingsTableType.stringArray : null,
      _ => DSettingsTableType.any,
    };
  }

  static DSettingsTableType? fromIndex(int index) {
    return DSettingsTableType.values.asMap()[index];
  }

  static DSettingsTableType? fromSignature(String signature) {
    return DSettingsTableType.values.firstWhereOrNull(
          (e) => e.signature == signature,
        ) ??
        DSettingsTableType.any;
  }

  static DSettingsTableType? fromDBusSignature(DBusSignature signature) =>
      DSettingsTableType.fromSignature(signature.value);

  final String signature;
  final String? nameOverride;

  const DSettingsTableType(this.signature, [this.nameOverride]);

  DBusSignature get dBusSignature => DBusSignature.unchecked(signature);

  T? tryParse(String input) {
    return switch (signature) {
      '*' => _matchType(input),
      's' => input,
      'i' => int.tryParse(input),
      'd' => double.tryParse(input),
      'b' => input.asBool,
      'as' => input.asStringList,
      _ => null,
    } as T?;
  }

  T? _matchType(String input) {
    Object? value;

    for (int i = 1; i < DSettingsTableType.values.length; i++) {
      final DSettingsTableType type = DSettingsTableType.values[i];

      value = type.tryParse(input);
      if (value case T() when value != null) return value;
    }

    return null;
  }
}
