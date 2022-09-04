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
    if (this == null) return null;

    switch (this) {
      case "true":
        return true;
      case "false":
        return false;
    }

    return null;
  }

  List<String>? get asStringList {
    if (this == null) return null;
    if (this!.isEmpty) return [];

    final String str = this!;

    return str.split(";").map((e) => e.replaceAll("%3B", ";")).toList();
  }
}

Object? extractValue(DBusValue value) {
  switch (value.signature.value) {
    case "v":
      return extractValue(value.asVariant());
    case "s":
      return value.asString();
    case "i":
      return value.asInt32();
    case "d":
      return value.asDouble();
    case "b":
      return value.asBoolean();
    case "as":
      return value.asStringArray().toList();
  }

  return null;
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
  switch (type.signature) {
    case '*':
      final DSettingsTableType? type = DSettingsTableType.fromValue(value);

      if (type == null || type == DSettingsTableType.any) break;

      return DBusVariant(convertToDBus(type, value));
    case 's':
      return DBusString(value as String);
    case 'i':
      return DBusInt32(value as int);
    case 'd':
      return DBusDouble(value as double);
    case 'b':
      return DBusBoolean(value as bool);
    case 'as':
      return DBusArray.string(value as List<String>);
  }

  throw Exception("Can't be converted to DBus: $type");
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

  if (!hasValue && (!hasSchemeEntry || returnRawValue)) {
    return null;
  }

  final DSettingsEntry actualEntry = value ?? schemeEntry!;

  return actualEntry.toDBus();
}

const Uuid uuid = Uuid();
