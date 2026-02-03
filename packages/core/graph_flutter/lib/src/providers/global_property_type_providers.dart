import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../property_type/global_property_type_definition.dart';
import '../property_type/global_property_type_manager.dart';

part 'global_property_type_providers.g.dart';

/// Provider that provides the current stack path
///
/// This provider is expected to be overridden at the application layer.
/// By default it throws an exception, so it needs to be overridden in concrete implementation.
@riverpod
String? currentStackPath(CurrentStackPathRef ref) {
  throw UnimplementedError(
    'currentStackPathProvider must be overridden in concrete implementation',
  );
}

/// Global property type management provider
///
/// Provides an instance of GlobalPropertyTypeManager based on the current stack path.
@riverpod
GlobalPropertyTypeManager globalPropertyTypeManager(
  GlobalPropertyTypeManagerRef ref,
) {
  final stackPath = ref.watch(currentStackPathProvider);

  if (stackPath == null) {
    throw StateError('Stack path is not set');
  }

  return GlobalPropertyTypeManager(stackPath);
}

/// Provider to get global type definition for specified property name
///
/// [propertyName] Property name to retrieve
///
/// Asynchronously retrieves the global type definition corresponding to the specified property name.
/// Returns null if the definition does not exist.
@riverpod
Future<GlobalPropertyTypeDefinition?> globalPropertyType(
  GlobalPropertyTypeRef ref,
  String propertyName,
) async {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return await manager.getPropertyType(propertyName);
}

/// Provider to get all global property type definitions
///
/// Returns a map of all property type definitions defined in the current stack.
@riverpod
Future<Map<String, GlobalPropertyTypeDefinition>> allGlobalPropertyTypes(
  AllGlobalPropertyTypesRef ref,
) async {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return await manager.getAllPropertyTypes();
}

/// Provider to get list of property names
///
/// Returns a sorted list of all defined property names.
@riverpod
Future<List<String>> globalPropertyNames(GlobalPropertyNamesRef ref) async {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return await manager.getPropertyNames();
}

/// Provider to get property names of specified type
///
/// [typeName] Type name to filter
///
/// Returns a list of property names that have the specified type.
@riverpod
Future<List<String>> globalPropertyNamesByType(
  GlobalPropertyNamesByTypeRef ref,
  String typeName,
) async {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return await manager.getPropertyNamesByType(typeName);
}

/// Provider to get statistics information of global property types
///
/// Returns statistics information such as property count by type.
@riverpod
Future<Map<String, dynamic>> globalPropertyTypeStatistics(
  GlobalPropertyTypeStatisticsRef ref,
) async {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return await manager.getStatistics();
}

/// Action provider for global property types
///
/// Provides actions for creating, updating, deleting property type definitions, etc.
@riverpod
class GlobalPropertyTypeActions extends _$GlobalPropertyTypeActions {
  @override
  void build() {
    // Initial state not needed
  }

  /// Set property type definition
  ///
  /// [propertyName] Property name
  /// [definition] Property type definition
  ///
  /// Sets the type definition for the specified property name and invalidates related providers.
  Future<void> setPropertyType(
    String propertyName,
    GlobalPropertyTypeDefinition definition,
  ) async {
    final manager = ref.read(globalPropertyTypeManagerProvider);
    await manager.setPropertyType(propertyName, definition);

    // Invalidate related providers to trigger reload
    _invalidateRelatedProviders(propertyName);
  }

  /// Remove property type definition
  ///
  /// [propertyName] Property name to remove
  ///
  /// Removes the type definition for the specified property name and invalidates related providers.
  Future<void> removePropertyType(String propertyName) async {
    final manager = ref.read(globalPropertyTypeManagerProvider);
    await manager.removePropertyType(propertyName);

    // Invalidate related providers to trigger reload
    _invalidateRelatedProviders(propertyName);
  }

  /// Batch set property type definitions
  ///
  /// [definitions] Map of property names and type definitions
  ///
  /// Sets multiple property type definitions at once.
  Future<void> setPropertyTypes(
    Map<String, GlobalPropertyTypeDefinition> definitions,
  ) async {
    final manager = ref.read(globalPropertyTypeManagerProvider);

    for (final entry in definitions.entries) {
      await manager.setPropertyType(entry.key, entry.value);
    }

    // Overall invalidation
    _invalidateAllProviders();
  }

  /// Reload from file
  ///
  /// Reloads type definitions from property_types.json file and
  /// invalidates related providers.
  Future<void> reloadFromFile() async {
    final manager = ref.read(globalPropertyTypeManagerProvider);
    manager.clearCache();

    // Overall invalidation
    _invalidateAllProviders();
  }

  /// Clear cache
  ///
  /// Clears memory cache and triggers reload on next access.
  void clearCache() {
    final manager = ref.read(globalPropertyTypeManagerProvider);
    manager.clearCache();

    // Overall invalidation
    _invalidateAllProviders();
  }

  /// Invalidate providers related to specific property
  void _invalidateRelatedProviders(String propertyName) {
    // Invalidate specific property type definition provider
    ref.invalidate(globalPropertyTypeProvider(propertyName));

    // Also invalidate overall providers
    _invalidateAllProviders();
  }

  /// Invalidate overall providers
  void _invalidateAllProviders() {
    ref.invalidate(allGlobalPropertyTypesProvider);
    ref.invalidate(globalPropertyNamesProvider);
    ref.invalidate(globalPropertyTypeStatisticsProvider);

    // Type-specific providers are difficult to invalidate individually,
    // so handle at application layer if needed
  }
}

/// Property type definition validation provider
///
/// [definition] Type definition to validate
///
/// Validates whether the specified type definition is valid.
@riverpod
bool validatePropertyTypeDefinition(
  ValidatePropertyTypeDefinitionRef ref,
  GlobalPropertyTypeDefinition definition,
) {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return manager.validatePropertyType(definition);
}

/// Property type definition file existence check provider
///
/// Checks whether property_types.json file exists.
@riverpod
Future<bool> propertyTypeFileExists(PropertyTypeFileExistsRef ref) async {
  final manager = ref.watch(globalPropertyTypeManagerProvider);
  return await manager.fileExists();
}
