import 'dart:convert';

/// This utility class provide the functionality to print json as formatted json data
String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}
