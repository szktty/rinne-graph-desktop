/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';

/// Utility class for safely handling JSON data
///
/// In Dart's type system, JSON decode results are typed as `Map<Object?, Object?>`,
/// but in most cases we want to treat them as `Map<String, dynamic>`.
/// This class provides utility methods for safe type conversion.
class JsonUtils {
  /// Safely casts Map<Object?, Object?> to Map<String, dynamic>
  ///
  /// [map] Source map to convert
  ///
  /// Returns: Map converted to Map<String, dynamic>
  ///
  /// Example:
  /// ```dart
  /// final dynamic decodedJson = jsonDecode(jsonString);
  /// if (decodedJson is Map) {
  ///   final Map<String, dynamic> typedMap = JsonUtils.castMapToStringDynamic(decodedJson);
  ///   // typedMap can be used safely
  /// }
  /// ```
  static Map<String, dynamic> castMapToStringDynamic(Map map) {
    return map.cast<String, dynamic>();
  }

  /// Safely converts JSON decode result to Map<String, dynamic>
  ///
  /// [json] JSON decode result (e.g., return value of jsonDecode())
  ///
  /// Returns: Map converted to Map<String, dynamic>, or empty Map if conversion fails
  ///
  /// Example:
  /// ```dart
  /// final dynamic decodedJson = jsonDecode(jsonString);
  /// final Map<String, dynamic> typedMap = JsonUtils.jsonToStringDynamic(decodedJson);
  /// ```
  static Map<String, dynamic> jsonToStringDynamic(dynamic json) {
    if (json is Map) {
      return json.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }

  /// Safely retrieves a list of Map<String, dynamic> from JSON decode result
  ///
  /// [json] JSON decode result (e.g., return value of jsonDecode())
  /// [key] Key containing the list in the JSON object
  ///
  /// Returns: List of Map<String, dynamic>, or empty list if retrieval fails
  ///
  /// Example:
  /// ```dart
  /// final dynamic decodedJson = jsonDecode('{"items": [{"id": 1}, {"id": 2}]}');
  /// final List<Map<String, dynamic>> items = JsonUtils.getMapList(decodedJson, 'items');
  /// ```
  static List<Map<String, dynamic>> getMapList(dynamic json, String key) {
    if (json is Map && json[key] is List) {
      final List<dynamic> list = json[key] as List<dynamic>;
      return list
          .whereType<Map>()
          .map((map) => map.cast<String, dynamic>())
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  /// Decodes a string as JSON and returns it as Map<String, dynamic>
  ///
  /// [jsonString] JSON format string
  ///
  /// Returns: Decoded Map<String, dynamic>
  /// Throws: FormatException may be thrown
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final Map<String, dynamic> data = JsonUtils.decodeAsMap('{"name": "John"}');
  ///   print(data['name']); // "John"
  /// } catch (e) {
  ///   print('Invalid JSON format');
  /// }
  /// ```
  static Map<String, dynamic> decodeAsMap(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    return jsonToStringDynamic(decoded);
  }

  /// Decodes a string as JSON and returns it as List<Map<String, dynamic>>
  ///
  /// [jsonString] JSON format string (array format)
  ///
  /// Returns: Decoded List<Map<String, dynamic>>
  /// Throws: FormatException may be thrown
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final List<Map<String, dynamic>> data = JsonUtils.decodeAsList('[{"id": 1}, {"id": 2}]');
  ///   for (final item in data) {
  ///     print(item['id']);
  ///   }
  /// } catch (e) {
  ///   print('Invalid JSON format');
  /// }
  /// ```
  static List<Map<String, dynamic>> decodeAsList(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((map) => map.cast<String, dynamic>())
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  /// Map casting utility method for WindowEvent
  ///
  /// [originalJson] Source Map to convert
  ///
  /// Returns: Converted Map<String, dynamic>
  ///
  /// Example:
  /// ```dart
  /// final Map<String, dynamic> eventJson = JsonUtils.castWindowEventMap(event.toJson());
  /// ```
  static Map<String, dynamic> castWindowEventMap(Map originalJson) {
    final Map<String, dynamic> result = <String, dynamic>{};

    for (final entry in originalJson.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      // Special handling when payload is a Map
      if (key == 'payload' && value is Map) {
        final Map<String, dynamic> payloadMap = <String, dynamic>{};
        for (final payloadEntry in value.entries) {
          payloadMap[payloadEntry.key.toString()] = payloadEntry.value;
        }
        result[key] = payloadMap;
      } else {
        result[key] = value;
      }
    }

    return result;
  }
}
