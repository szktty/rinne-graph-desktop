import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'global_property_type_definition.dart';

/// Manager class for global property type definitions
///
/// Manages the binding between property names and types on a file basis.
/// Persists using property_types.json file and provides fast access
/// through memory cache.
class GlobalPropertyTypeManager {
  /// List of supported type names
  static const Set<String> _supportedTypes = {
    'text',
    'integer',
    'decimal',
    'boolean',
    'date',
    'email',
    'any',
  };

  /// Constructor
  ///
  /// [stackPath] Path to stack directory
  GlobalPropertyTypeManager(this.stackPath);

  /// Path to stack directory
  final String stackPath;

  /// Memory cache for property type definitions
  final Map<String, GlobalPropertyTypeDefinition> _cache = {};

  /// Whether file has been loaded
  bool _isLoaded = false;

  /// Path to property_types.json file
  String get _filePath => path.join(stackPath, 'meta', 'property_types.json');

  /// Get property type definition
  ///
  /// [propertyName] Property name
  ///
  /// Returns the type definition corresponding to the specified property name.
  /// Returns null if it does not exist.
  Future<GlobalPropertyTypeDefinition?> getPropertyType(
    String propertyName,
  ) async {
    await _ensureLoaded();
    return _cache[propertyName];
  }

  /// Set property type definition
  ///
  /// [propertyName] Property name
  /// [definition] Property type definition
  ///
  /// Sets the type definition for the specified property name and saves to file.
  Future<void> setPropertyType(
    String propertyName,
    GlobalPropertyTypeDefinition definition,
  ) async {
    await _ensureLoaded();

    // Set update time to current time
    final updatedDefinition = definition.copyWithUpdatedAt(DateTime.now());
    _cache[propertyName] = updatedDefinition;

    await saveToFile();
  }

  /// Remove property type definition
  ///
  /// [propertyName] Property name
  ///
  /// Removes the type definition for the specified property name and saves to file.
  Future<void> removePropertyType(String propertyName) async {
    await _ensureLoaded();

    if (_cache.remove(propertyName) != null) {
      await saveToFile();
    }
  }

  /// Get all property type definitions
  ///
  /// Returns a map of all property type definitions.
  Future<Map<String, GlobalPropertyTypeDefinition>>
  getAllPropertyTypes() async {
    await _ensureLoaded();
    return Map.unmodifiable(_cache);
  }

  /// Get list of property names
  ///
  /// Returns a list of all defined property names.
  Future<List<String>> getPropertyNames() async {
    await _ensureLoaded();
    return _cache.keys.toList()..sort();
  }

  /// Get property names of specified type
  ///
  /// [typeName] Property type name
  ///
  /// Returns a list of property names with the specified type.
  Future<List<String>> getPropertyNamesByType(String typeName) async {
    await _ensureLoaded();
    return _cache.entries
        .where((entry) => entry.value.typeName == typeName)
        .map((entry) => entry.key)
        .toList()
      ..sort();
  }

  /// Get property type statistics
  ///
  /// Returns statistics such as number of properties by type.
  Future<Map<String, dynamic>> getStatistics() async {
    await _ensureLoaded();

    final typeCount = <String, int>{};
    for (final definition in _cache.values) {
      typeCount[definition.typeName] =
          (typeCount[definition.typeName] ?? 0) + 1;
    }

    return {
      'total_properties': _cache.length,
      'by_type': typeCount,
      'supported_types': _supportedTypes.toList()..sort(),
    };
  }

  /// Load from file
  ///
  /// Loads property type definitions from property_types.json file.
  /// Creates default definitions if file does not exist.
  Future<void> loadFromFile() async {
    final file = File(_filePath);

    if (!await file.exists()) {
      // Create default definitions if file does not exist
      await _createDefaultDefinitions();
      return;
    }

    try {
      final content = await file.readAsString();
      final jsonData = json.decode(content) as Map<String, dynamic>;

      _cache.clear();

      final propertyTypes = jsonData['property_types'] as Map<String, dynamic>?;
      if (propertyTypes != null) {
        for (final entry in propertyTypes.entries) {
          final propertyName = entry.key;
          final definitionJson = entry.value as Map<String, dynamic>;

          try {
            final definition = GlobalPropertyTypeDefinition.fromJson(
              definitionJson,
            );
            if (definition.isValid()) {
              _cache[propertyName] = definition;
            }
          } catch (e) {
            // Ignore individual definition load errors and continue
            print(
              'Warning: Failed to load property type definition for "$propertyName": $e',
            );
          }
        }
      }

      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to load property types from file: $e');
    }
  }

  /// Save to file
  ///
  /// Saves current property type definitions to property_types.json file.
  Future<void> saveToFile() async {
    final file = File(_filePath);

    // Create directory if it does not exist
    await file.parent.create(recursive: true);

    final statistics = await getStatistics();
    final now = DateTime.now();

    final jsonData = {
      'version': '1.0.0',
      'created_at': _getFileCreatedAt().toIso8601String(),
      'updated_at': now.toIso8601String(),
      'property_types': _cache.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'statistics': statistics,
    };

    try {
      final content = const JsonEncoder.withIndent('  ').convert(jsonData);
      await file.writeAsString(content);
    } catch (e) {
      throw Exception('Failed to save property types to file: $e');
    }
  }

  /// Validate type definition
  ///
  /// [definition] Type definition to validate
  ///
  /// Checks whether the specified type definition is valid.
  bool validatePropertyType(GlobalPropertyTypeDefinition definition) {
    return definition.isValid();
  }

  /// Create default property type definitions
  ///
  /// Creates commonly used basic property type definitions.
  Future<void> _createDefaultDefinitions() async {
    final now = DateTime.now();

    // Create basic property type definitions
    final defaultDefinitions = <String, GlobalPropertyTypeDefinition>{
      'name': GlobalPropertyTypeDefinition(
        typeName: 'text',
        name: 'Name',
        description: 'Entity name',

        constraints: {'max_length': 100},
        uiHints: {'component': 'text_field', 'placeholder': 'Enter name'},
        createdAt: now,
        updatedAt: now,
      ),
      'description': GlobalPropertyTypeDefinition(
        typeName: 'text',
        name: 'Description',
        description: 'Entity description',

        constraints: {'max_length': 500},
        uiHints: {
          'component': 'text_field',
          'multiline': true,
          'placeholder': 'Enter description',
        },
        createdAt: now,
        updatedAt: now,
      ),
      'created_at': GlobalPropertyTypeDefinition(
        typeName: 'date',
        name: 'Created date',
        description: 'Entity creation date',

        constraints: {},
        uiHints: {'component': 'date_picker', 'readonly': true},
        createdAt: now,
        updatedAt: now,
      ),
      'is_active': GlobalPropertyTypeDefinition(
        typeName: 'boolean',
        name: 'Active',
        description: 'Active status',

        constraints: {},
        uiHints: {
          'component': 'checkbox',
          'true_label': 'Yes',
          'false_label': 'No',
        },
        createdAt: now,
        updatedAt: now,
      ),
    };

    _cache.clear();
    _cache.addAll(defaultDefinitions);
    _isLoaded = true;

    await saveToFile();
  }

  /// Get file creation time
  ///
  /// Returns the creation time if file exists, otherwise returns current time.
  DateTime _getFileCreatedAt() {
    final file = File(_filePath);
    if (file.existsSync()) {
      return file.statSync().modified;
    }
    return DateTime.now();
  }

  /// Ensure file is loaded
  ///
  /// Loads from file if not yet loaded.
  Future<void> _ensureLoaded() async {
    if (!_isLoaded) {
      await loadFromFile();
    }
  }

  /// Clear cache
  ///
  /// Clears memory cache and reloads on next access.
  void clearCache() {
    _cache.clear();
    _isLoaded = false;
  }

  /// Check if file exists
  ///
  /// Returns whether property_types.json file exists.
  Future<bool> fileExists() async {
    final file = File(_filePath);
    return await file.exists();
  }
}
