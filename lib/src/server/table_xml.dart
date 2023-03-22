import 'package:dsettings/src/server/dsettings_table.dart';
import 'package:dsettings/src/types.dart';
import 'package:dsettings/src/utils.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml.dart';

class DTableParser {
  const DTableParser._();

  static final Logger _logger = Logger("DTableParser");

  static DSettingsTable? parse(String contents) {
    final XmlDocument document;

    try {
      document = XmlDocument.parse(contents);
    } on XmlParserException catch (e) {
      _logger.severe(e);
      return null;
    } on XmlTagException catch (e) {
      _logger.severe(e);
      return null;
    }

    final XmlElement rootElement = document.rootElement;

    if (rootElement.qualifiedName != "dtable") {
      _logger.warning(
        "Table does not contain dtable root element, can't use table",
      );
      return null;
    }

    final String? name = rootElement.getAttribute("name");

    if (name == null) {
      _logger.warning(
        "DTable root element does not contain name attribute, can't use table",
      );
      return null;
    }

    final String? owner = rootElement.getAttribute("owner");

    final XmlElement? xmlScheme = rootElement.getElement("scheme");
    final DSettingsScheme? scheme = xmlScheme != null
        ? DSettingsScheme(entries: _parseEntries(xmlScheme))
        : null;

    final XmlElement? xmlEntries = rootElement.getElement("entries");
    final DTableEntries? entries = xmlEntries != null
        ? DTableEntries(entries: _parseEntries(xmlEntries))
        : null;

    return DSettingsTable(
      name: name,
      owner: owner != null && owner.isNotEmpty ? owner : null,
      scheme: scheme,
      entries: entries ?? DTableEntries(entries: {}),
    );
  }

  static Map<String, DSettingsEntry> _parseEntries(XmlElement element) {
    final List<MapEntry<String, DSettingsEntry>> entries = [];

    for (final XmlElement element in element.childElements) {
      final MapEntry<String, DSettingsEntry>? entry = _parseEntry(element);

      if (entry == null) continue;

      entries.add(entry);
    }

    return Map.fromEntries(entries);
  }

  static MapEntry<String, DSettingsEntry>? _parseEntry(
    XmlElement element,
  ) {
    final DSettingsTableType type;

    switch (element.qualifiedName) {
      case "string":
        type = DSettingsTableType.string;
      case "integer":
        type = DSettingsTableType.integer;
      case "double":
        type = DSettingsTableType.float;
      case "boolean":
        type = DSettingsTableType.boolean;
      case "stringArray":
        type = DSettingsTableType.stringArray;
      default:
        _logger.warning("Invalid type ${element.qualifiedName}");
        return null;
    }

    final String? name = element.getAttribute("name");

    if (name == null) {
      _logger.warning(
        "Entry with type ${element.qualifiedName} has no name attribute, skipping",
      );
      return null;
    }

    if (element.children.length > 1) {
      _logger.warning(
        'Entry "$name" should have only a single text child representing the value.',
      );
      return null;
    }

    final XmlText? child = element.firstChild as XmlText?;
    final Object? value = type.tryParse(child?.text ?? "");

    if (value == null) {
      _logger.warning(
        'Entry "$name" should have only a single text child representing the value.',
      );
      return null;
    }

    return MapEntry(name, DSettingsEntry(type, value));
  }
}

abstract final class DTableEncoder {
  const DTableEncoder._();

  //static final Logger _logger = Logger("DTableParser");

  static XmlDocument encode(DSettingsTable table) {
    final XmlElement? scheme =
        table.scheme != null ? _encodeDict(table.scheme!) : null;
    final XmlElement entries = _encodeDict(table.entries);

    return XmlDocument([
      XmlElement(
        XmlName("dtable"),
        [
          XmlAttribute(
            XmlName("name"),
            table.name,
          ),
          if (table.owner != null && table.owner!.isNotEmpty)
            XmlAttribute(
              XmlName("owner"),
              table.owner!,
            ),
        ],
        [if (scheme != null) scheme, entries],
      ),
    ]);
  }

  static XmlElement _encodeDict(DTableDict dict) {
    return XmlElement(
      XmlName(dict.name),
      [],
      dict.entries.entries.map(_encodeEntry),
    );
  }

  static XmlElement _encodeEntry(MapEntry<String, DSettingsEntry> entry) {
    return XmlElement(
      XmlName(entry.value.type.nameOverride ?? entry.value.type.name),
      [XmlAttribute(XmlName("name"), entry.key)],
      [XmlText(encodeList(entry.value.value as Object).toString())],
    );
  }
}
