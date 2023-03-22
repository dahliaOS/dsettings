import 'package:dbus/dbus.dart';
import 'package:dsettings/src/types.dart';
import 'package:uuid/uuid.dart';

Future<bool> isCallAllowed(
  DBusClient? client,
  DBusMethodCall call,
  String? owner,
  String interface,
  List<String> methods,
) async {
  if (owner != null &&
      call.interface == interface &&
      methods.contains(call.name)) {
    final String? uniqueName = await client?.getNameOwner(owner);

    return uniqueName == call.sender;
  }

  return true;
}

extension XmlUtils on String? {
  bool? get asBool {
    return switch (this) {
      "true" => true,
      "false" => false,
      _ => null,
    };
  }

  List<String>? get asStringList {
    if (this == null) return null;
    if (this!.isEmpty) return [];

    final String str = this!;

    return str.split(";").map((e) => e.replaceAll("%3B", ";")).toList();
  }
}

Object? extractValue(DBusValue value) {
  return switch (value.signature.value) {
    "v" => extractValue(value.asVariant()),
    "s" => value.asString(),
    "i" => value.asInt32(),
    "d" => value.asDouble(),
    "b" => value.asBoolean(),
    "as" => value.asStringArray().toList(),
    _ => null,
  };
}

DSettingsEntry? valueToEntry(DBusValue value) {
  final Object? nativeValue = extractValue(value);
  if (nativeValue == null) return null;

  final DSettingsTableType type = DSettingsTableType.fromValue(nativeValue)!;

  return DSettingsEntry(type, nativeValue);
}

DBusValue valueToDBus<T>(T value) {
  final DSettingsTableType? type = DSettingsTableType.fromValue(value);
  if (type == null || type == DSettingsTableType.any) {
    throw Exception(
      "Invalid type $type to write on table, must be either String, int, double, bool or List<String>",
    );
  }

  return convertToDBus(type, value);
}

DBusValue convertToDBus<T>(DSettingsTableType<T> type, T value) {
  final DSettingsTableType? estimatedType = DSettingsTableType.fromValue(value);

  return switch (type.signature) {
    '*' when estimatedType != null && estimatedType != DSettingsTableType.any =>
      DBusVariant(convertToDBus(estimatedType, value)),
    's' when value is String => DBusString(value),
    'i' when value is int => DBusInt32(value),
    'd' when value is double => DBusDouble(value),
    'b' when value is bool => DBusBoolean(value),
    'as' when value is List<String> => DBusArray.string(value),
    _ => throw Exception("Can't be converted to DBus: $type"),
  };
}

Object encodeList(Object value) {
  if (value is List<String>) {
    return value.map((e) => e.replaceAll(";", "%3B")).join(";");
  } else {
    return value;
  }
}

DBusValue? readValue(
  String setting,
  DTableEntries entries,
  DSettingsScheme? scheme,
  bool returnRawValue,
) {
  final DSettingsEntry? value = entries.read(setting);
  final DSettingsEntry? schemeEntry = scheme?.read(setting);

  final bool hasValue = value != null;
  final bool hasSchemeEntry = schemeEntry != null;

  if (!hasValue && (!hasSchemeEntry || returnRawValue)) return null;

  final DSettingsEntry actualEntry = value ?? schemeEntry!;

  return actualEntry.toDBus();
}

const Uuid uuid = Uuid();
