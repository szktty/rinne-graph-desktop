/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'global_property_type_definition.dart';
import 'property_type_registry.dart';

/// Manager class for global property type definitions
///
/// Manages the binding between property names and types on a file basis.
/// Persists using property_types.json file and provides fast access
/// through memory cache.
class GlobalPropertyTypeManager {
  /// Constructor
  ///
  /// [stackPath] Path to stack directory
  GlobalPropertyTypeManager(this.stackPath);

  /// Path to stack directory
  final String stackPath;

  /// Memory cache for property type definitions
  final Map<String, GlobalPropertyTypeDefinition> _cache = {};

  /// Memory cache for label-scoped definitions: label → property name → type.
  ///
  /// The same property name means different things on different kinds of node
  /// — `note` might be a memo on a Person and a plain string elsewhere — so a
  /// type is bound to a label, with [_cache] as the stack-wide fallback.
  final Map<String, Map<String, GlobalPropertyTypeDefinition>> _labelCache = {};

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

  /// Resolves the type of [propertyName] for an entity carrying [labels].
  ///
  /// Checks each label in turn, then falls back to the stack-wide definition.
  /// Returns null when nothing defines the property, which callers should read
  /// as "untyped" — the editor treats that as plain text.
  ///
  /// With several labels the first match wins, in iteration order. Same
  /// simplification as caption resolution ([DisplayName], which takes
  /// `labels.first`): a node whose labels disagree about a property is
  /// ambiguous by construction, and picking deterministically beats merging.
  Future<GlobalPropertyTypeDefinition?> getPropertyTypeForLabels(
    String propertyName,
    Iterable<String> labels,
  ) async {
    await _ensureLoaded();

    for (final label in labels) {
      final definition = _labelCache[label]?[propertyName];
      if (definition != null) {
        return definition;
      }
    }

    return _cache[propertyName];
  }

  /// Binds [propertyName] to a type for entities labelled [label].
  Future<void> setLabelPropertyType(
    String label,
    String propertyName,
    GlobalPropertyTypeDefinition definition,
  ) async {
    await _ensureLoaded();

    final forLabel = _labelCache.putIfAbsent(label, () => {});
    forLabel[propertyName] = definition.copyWithUpdatedAt(DateTime.now());

    await saveToFile();
  }

  /// Removes the label-scoped type of [propertyName] for [label].
  ///
  /// Leaves any stack-wide definition alone.
  Future<void> removeLabelPropertyType(
    String label,
    String propertyName,
  ) async {
    await _ensureLoaded();

    final forLabel = _labelCache[label];
    if (forLabel == null) return;

    if (forLabel.remove(propertyName) != null) {
      if (forLabel.isEmpty) {
        _labelCache.remove(label);
      }
      await saveToFile();
    }
  }

  /// Moves the label-scoped type of [from] to [to] for [label].
  ///
  /// Renaming a property would otherwise leave its type behind under the old
  /// name, so a renamed memo would come back as plain text. Does nothing when
  /// [from] has no label-scoped type — an untyped property stays untyped —
  /// and saves once rather than once per side of the move.
  Future<void> renameLabelPropertyType(
    String label,
    String from,
    String to,
  ) async {
    await _ensureLoaded();

    if (from == to) return;

    final forLabel = _labelCache[label];
    final definition = forLabel?.remove(from);
    if (definition == null) return;

    forLabel![to] = definition.copyWithUpdatedAt(DateTime.now());

    await saveToFile();
  }

  /// All label-scoped definitions, keyed by label then property name.
  Future<Map<String, Map<String, GlobalPropertyTypeDefinition>>>
  getAllLabelPropertyTypes() async {
    await _ensureLoaded();
    return {
      for (final entry in _labelCache.entries)
        entry.key: Map.unmodifiable(entry.value),
    };
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
      'supported_types':
          PropertyTypeRegistry.supportedTypeNames.toList()..sort(),
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
      _labelCache.clear();

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

      // Absent in files written before label scoping existed, which is why it
      // is a sibling key rather than a change to `property_types`: an older
      // reader ignores it, and a newer reader still understands an older file.
      final labelTypes =
          jsonData['label_property_types'] as Map<String, dynamic>?;
      if (labelTypes != null) {
        for (final labelEntry in labelTypes.entries) {
          final label = labelEntry.key;
          final forLabel = labelEntry.value as Map<String, dynamic>?;
          if (forLabel == null) continue;

          for (final entry in forLabel.entries) {
            final propertyName = entry.key;
            try {
              final definition = GlobalPropertyTypeDefinition.fromJson(
                entry.value as Map<String, dynamic>,
              );
              if (definition.isValid()) {
                _labelCache.putIfAbsent(label, () => {})[propertyName] =
                    definition;
              }
            } catch (e) {
              // Ignore individual definition load errors and continue
              print(
                'Warning: Failed to load property type definition for '
                '"$label.$propertyName": $e',
              );
            }
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
  ///
  /// Writes are serialised against each other. Two saves can otherwise overlap
  /// — creating the default definitions saves, and the call that triggered the
  /// load saves again as soon as it resumes — and because the second write is
  /// shorter than the first, it left the tail of the longer one in place and
  /// produced a file ending in `}}\n}` that no longer parsed.
  Future<void> saveToFile() {
    final pending = _pendingSave.then((_) => _writeToFile());
    // Swallowed on the queue only: a failed write must not poison the writes
    // that follow it. The error still reaches this call's own caller.
    _pendingSave = pending.catchError((Object _) {});
    return pending;
  }

  /// Serialises [saveToFile]; see the note there.
  Future<void> _pendingSave = Future<void>.value();

  Future<void> _writeToFile() async {
    final file = File(_filePath);

    // Create directory if it does not exist
    await file.parent.create(recursive: true);

    final statistics = await getStatistics();
    final now = DateTime.now();

    final jsonData = {
      'version': '1.1.0',
      'created_at': _getFileCreatedAt().toIso8601String(),
      'updated_at': now.toIso8601String(),
      'property_types': _cache.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      // Omitted entirely while empty, so a stack that never used label scoping
      // keeps writing the same file it did before.
      if (_labelCache.isNotEmpty)
        'label_property_types': _labelCache.map(
          (label, forLabel) => MapEntry(
            label,
            forLabel.map((key, value) => MapEntry(key, value.toJson())),
          ),
        ),
      'statistics': statistics,
    };

    try {
      final content = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Written to a sibling and renamed into place rather than written
      // directly. Serialising [saveToFile] only orders the writes made through
      // one manager, and a stack can have more than one — the app briefly held
      // two while switching stacks. Two overlapping direct writes left the
      // shorter one's output with the tail of the longer one still attached,
      // producing a file that no longer parsed. A rename is atomic, so a
      // concurrent writer either wins or loses cleanly and a reader only ever
      // sees a complete file.
      //
      // The suffix keeps two writers off the same temp file; the rename that
      // follows is what actually resolves the race.
      final temp = File('$_filePath.${pid}_${identityHashCode(this)}.tmp');
      await temp.writeAsString(content, flush: true);
      await temp.rename(_filePath);
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
    _labelCache.clear();
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
