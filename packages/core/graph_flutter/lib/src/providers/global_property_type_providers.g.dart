// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_property_type_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentStackPathHash() => r'cbc3cd3c80d03b682ff3080f4a02584e21d7c77c';

/// Provider that provides the current stack path
///
/// This provider is expected to be overridden at the application layer.
/// By default it throws an exception, so it needs to be overridden in concrete implementation.
///
/// Copied from [currentStackPath].
@ProviderFor(currentStackPath)
final currentStackPathProvider = AutoDisposeProvider<String?>.internal(
  currentStackPath,
  name: r'currentStackPathProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentStackPathHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStackPathRef = AutoDisposeProviderRef<String?>;
String _$globalPropertyTypeManagerHash() =>
    r'b0fcb3a097512cb4c2e6839fba2078da45d81d8a';

/// Global property type management provider
///
/// Provides an instance of GlobalPropertyTypeManager based on the current stack path.
///
/// Copied from [globalPropertyTypeManager].
@ProviderFor(globalPropertyTypeManager)
final globalPropertyTypeManagerProvider =
    AutoDisposeProvider<GlobalPropertyTypeManager>.internal(
      globalPropertyTypeManager,
      name: r'globalPropertyTypeManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$globalPropertyTypeManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalPropertyTypeManagerRef =
    AutoDisposeProviderRef<GlobalPropertyTypeManager>;
String _$globalPropertyTypeHash() =>
    r'f82f5423090c6590cad86509a43267d38eeb79f9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider to get global type definition for specified property name
///
/// [propertyName] Property name to retrieve
///
/// Asynchronously retrieves the global type definition corresponding to the specified property name.
/// Returns null if the definition does not exist.
///
/// Copied from [globalPropertyType].
@ProviderFor(globalPropertyType)
const globalPropertyTypeProvider = GlobalPropertyTypeFamily();

/// Provider to get global type definition for specified property name
///
/// [propertyName] Property name to retrieve
///
/// Asynchronously retrieves the global type definition corresponding to the specified property name.
/// Returns null if the definition does not exist.
///
/// Copied from [globalPropertyType].
class GlobalPropertyTypeFamily
    extends Family<AsyncValue<GlobalPropertyTypeDefinition?>> {
  /// Provider to get global type definition for specified property name
  ///
  /// [propertyName] Property name to retrieve
  ///
  /// Asynchronously retrieves the global type definition corresponding to the specified property name.
  /// Returns null if the definition does not exist.
  ///
  /// Copied from [globalPropertyType].
  const GlobalPropertyTypeFamily();

  /// Provider to get global type definition for specified property name
  ///
  /// [propertyName] Property name to retrieve
  ///
  /// Asynchronously retrieves the global type definition corresponding to the specified property name.
  /// Returns null if the definition does not exist.
  ///
  /// Copied from [globalPropertyType].
  GlobalPropertyTypeProvider call(String propertyName) {
    return GlobalPropertyTypeProvider(propertyName);
  }

  @override
  GlobalPropertyTypeProvider getProviderOverride(
    covariant GlobalPropertyTypeProvider provider,
  ) {
    return call(provider.propertyName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'globalPropertyTypeProvider';
}

/// Provider to get global type definition for specified property name
///
/// [propertyName] Property name to retrieve
///
/// Asynchronously retrieves the global type definition corresponding to the specified property name.
/// Returns null if the definition does not exist.
///
/// Copied from [globalPropertyType].
class GlobalPropertyTypeProvider
    extends AutoDisposeFutureProvider<GlobalPropertyTypeDefinition?> {
  /// Provider to get global type definition for specified property name
  ///
  /// [propertyName] Property name to retrieve
  ///
  /// Asynchronously retrieves the global type definition corresponding to the specified property name.
  /// Returns null if the definition does not exist.
  ///
  /// Copied from [globalPropertyType].
  GlobalPropertyTypeProvider(String propertyName)
    : this._internal(
        (ref) => globalPropertyType(ref as GlobalPropertyTypeRef, propertyName),
        from: globalPropertyTypeProvider,
        name: r'globalPropertyTypeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$globalPropertyTypeHash,
        dependencies: GlobalPropertyTypeFamily._dependencies,
        allTransitiveDependencies:
            GlobalPropertyTypeFamily._allTransitiveDependencies,
        propertyName: propertyName,
      );

  GlobalPropertyTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.propertyName,
  }) : super.internal();

  final String propertyName;

  @override
  Override overrideWith(
    FutureOr<GlobalPropertyTypeDefinition?> Function(
      GlobalPropertyTypeRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GlobalPropertyTypeProvider._internal(
        (ref) => create(ref as GlobalPropertyTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        propertyName: propertyName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GlobalPropertyTypeDefinition?>
  createElement() {
    return _GlobalPropertyTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalPropertyTypeProvider &&
        other.propertyName == propertyName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, propertyName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlobalPropertyTypeRef
    on AutoDisposeFutureProviderRef<GlobalPropertyTypeDefinition?> {
  /// The parameter `propertyName` of this provider.
  String get propertyName;
}

class _GlobalPropertyTypeProviderElement
    extends AutoDisposeFutureProviderElement<GlobalPropertyTypeDefinition?>
    with GlobalPropertyTypeRef {
  _GlobalPropertyTypeProviderElement(super.provider);

  @override
  String get propertyName =>
      (origin as GlobalPropertyTypeProvider).propertyName;
}

String _$allGlobalPropertyTypesHash() =>
    r'fe831c2b6aae82cca5e2144af2d5f5c5931faae8';

/// Provider to get all global property type definitions
///
/// Returns a map of all property type definitions defined in the current stack.
///
/// Copied from [allGlobalPropertyTypes].
@ProviderFor(allGlobalPropertyTypes)
final allGlobalPropertyTypesProvider = AutoDisposeFutureProvider<
  Map<String, GlobalPropertyTypeDefinition>
>.internal(
  allGlobalPropertyTypes,
  name: r'allGlobalPropertyTypesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allGlobalPropertyTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllGlobalPropertyTypesRef =
    AutoDisposeFutureProviderRef<Map<String, GlobalPropertyTypeDefinition>>;
String _$globalPropertyNamesHash() =>
    r'10e52a20f9e83a3cc7f33fe88f4b09c53a8b69b3';

/// Provider to get list of property names
///
/// Returns a sorted list of all defined property names.
///
/// Copied from [globalPropertyNames].
@ProviderFor(globalPropertyNames)
final globalPropertyNamesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      globalPropertyNames,
      name: r'globalPropertyNamesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$globalPropertyNamesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalPropertyNamesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$globalPropertyNamesByTypeHash() =>
    r'acdf00dbaa28d64fff8beecd1ee73009b8cf2618';

/// Provider to get property names of specified type
///
/// [typeName] Type name to filter
///
/// Returns a list of property names that have the specified type.
///
/// Copied from [globalPropertyNamesByType].
@ProviderFor(globalPropertyNamesByType)
const globalPropertyNamesByTypeProvider = GlobalPropertyNamesByTypeFamily();

/// Provider to get property names of specified type
///
/// [typeName] Type name to filter
///
/// Returns a list of property names that have the specified type.
///
/// Copied from [globalPropertyNamesByType].
class GlobalPropertyNamesByTypeFamily extends Family<AsyncValue<List<String>>> {
  /// Provider to get property names of specified type
  ///
  /// [typeName] Type name to filter
  ///
  /// Returns a list of property names that have the specified type.
  ///
  /// Copied from [globalPropertyNamesByType].
  const GlobalPropertyNamesByTypeFamily();

  /// Provider to get property names of specified type
  ///
  /// [typeName] Type name to filter
  ///
  /// Returns a list of property names that have the specified type.
  ///
  /// Copied from [globalPropertyNamesByType].
  GlobalPropertyNamesByTypeProvider call(String typeName) {
    return GlobalPropertyNamesByTypeProvider(typeName);
  }

  @override
  GlobalPropertyNamesByTypeProvider getProviderOverride(
    covariant GlobalPropertyNamesByTypeProvider provider,
  ) {
    return call(provider.typeName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'globalPropertyNamesByTypeProvider';
}

/// Provider to get property names of specified type
///
/// [typeName] Type name to filter
///
/// Returns a list of property names that have the specified type.
///
/// Copied from [globalPropertyNamesByType].
class GlobalPropertyNamesByTypeProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// Provider to get property names of specified type
  ///
  /// [typeName] Type name to filter
  ///
  /// Returns a list of property names that have the specified type.
  ///
  /// Copied from [globalPropertyNamesByType].
  GlobalPropertyNamesByTypeProvider(String typeName)
    : this._internal(
        (ref) => globalPropertyNamesByType(
          ref as GlobalPropertyNamesByTypeRef,
          typeName,
        ),
        from: globalPropertyNamesByTypeProvider,
        name: r'globalPropertyNamesByTypeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$globalPropertyNamesByTypeHash,
        dependencies: GlobalPropertyNamesByTypeFamily._dependencies,
        allTransitiveDependencies:
            GlobalPropertyNamesByTypeFamily._allTransitiveDependencies,
        typeName: typeName,
      );

  GlobalPropertyNamesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.typeName,
  }) : super.internal();

  final String typeName;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(GlobalPropertyNamesByTypeRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GlobalPropertyNamesByTypeProvider._internal(
        (ref) => create(ref as GlobalPropertyNamesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        typeName: typeName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GlobalPropertyNamesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalPropertyNamesByTypeProvider &&
        other.typeName == typeName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, typeName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlobalPropertyNamesByTypeRef
    on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `typeName` of this provider.
  String get typeName;
}

class _GlobalPropertyNamesByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GlobalPropertyNamesByTypeRef {
  _GlobalPropertyNamesByTypeProviderElement(super.provider);

  @override
  String get typeName => (origin as GlobalPropertyNamesByTypeProvider).typeName;
}

String _$globalPropertyTypeStatisticsHash() =>
    r'fe53287c3466933d985707bbab7b0322db551962';

/// Provider to get statistics information of global property types
///
/// Returns statistics information such as property count by type.
///
/// Copied from [globalPropertyTypeStatistics].
@ProviderFor(globalPropertyTypeStatistics)
final globalPropertyTypeStatisticsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      globalPropertyTypeStatistics,
      name: r'globalPropertyTypeStatisticsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$globalPropertyTypeStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalPropertyTypeStatisticsRef =
    AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$validatePropertyTypeDefinitionHash() =>
    r'b4b40c787495ae64612025915b7f63fd203a2ab1';

/// Property type definition validation provider
///
/// [definition] Type definition to validate
///
/// Validates whether the specified type definition is valid.
///
/// Copied from [validatePropertyTypeDefinition].
@ProviderFor(validatePropertyTypeDefinition)
const validatePropertyTypeDefinitionProvider =
    ValidatePropertyTypeDefinitionFamily();

/// Property type definition validation provider
///
/// [definition] Type definition to validate
///
/// Validates whether the specified type definition is valid.
///
/// Copied from [validatePropertyTypeDefinition].
class ValidatePropertyTypeDefinitionFamily extends Family<bool> {
  /// Property type definition validation provider
  ///
  /// [definition] Type definition to validate
  ///
  /// Validates whether the specified type definition is valid.
  ///
  /// Copied from [validatePropertyTypeDefinition].
  const ValidatePropertyTypeDefinitionFamily();

  /// Property type definition validation provider
  ///
  /// [definition] Type definition to validate
  ///
  /// Validates whether the specified type definition is valid.
  ///
  /// Copied from [validatePropertyTypeDefinition].
  ValidatePropertyTypeDefinitionProvider call(InvalidType definition) {
    return ValidatePropertyTypeDefinitionProvider(definition);
  }

  @override
  ValidatePropertyTypeDefinitionProvider getProviderOverride(
    covariant ValidatePropertyTypeDefinitionProvider provider,
  ) {
    return call(provider.definition);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'validatePropertyTypeDefinitionProvider';
}

/// Property type definition validation provider
///
/// [definition] Type definition to validate
///
/// Validates whether the specified type definition is valid.
///
/// Copied from [validatePropertyTypeDefinition].
class ValidatePropertyTypeDefinitionProvider extends AutoDisposeProvider<bool> {
  /// Property type definition validation provider
  ///
  /// [definition] Type definition to validate
  ///
  /// Validates whether the specified type definition is valid.
  ///
  /// Copied from [validatePropertyTypeDefinition].
  ValidatePropertyTypeDefinitionProvider(InvalidType definition)
    : this._internal(
        (ref) => validatePropertyTypeDefinition(
          ref as ValidatePropertyTypeDefinitionRef,
          definition,
        ),
        from: validatePropertyTypeDefinitionProvider,
        name: r'validatePropertyTypeDefinitionProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$validatePropertyTypeDefinitionHash,
        dependencies: ValidatePropertyTypeDefinitionFamily._dependencies,
        allTransitiveDependencies:
            ValidatePropertyTypeDefinitionFamily._allTransitiveDependencies,
        definition: definition,
      );

  ValidatePropertyTypeDefinitionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.definition,
  }) : super.internal();

  final InvalidType definition;

  @override
  Override overrideWith(
    bool Function(ValidatePropertyTypeDefinitionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ValidatePropertyTypeDefinitionProvider._internal(
        (ref) => create(ref as ValidatePropertyTypeDefinitionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        definition: definition,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _ValidatePropertyTypeDefinitionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidatePropertyTypeDefinitionProvider &&
        other.definition == definition;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, definition.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ValidatePropertyTypeDefinitionRef on AutoDisposeProviderRef<bool> {
  /// The parameter `definition` of this provider.
  InvalidType get definition;
}

class _ValidatePropertyTypeDefinitionProviderElement
    extends AutoDisposeProviderElement<bool>
    with ValidatePropertyTypeDefinitionRef {
  _ValidatePropertyTypeDefinitionProviderElement(super.provider);

  @override
  InvalidType get definition =>
      (origin as ValidatePropertyTypeDefinitionProvider).definition;
}

String _$propertyTypeFileExistsHash() =>
    r'546609805fef7af55ce011d29f9b7c23853b0083';

/// Property type definition file existence check provider
///
/// Checks whether property_types.json file exists.
///
/// Copied from [propertyTypeFileExists].
@ProviderFor(propertyTypeFileExists)
final propertyTypeFileExistsProvider = AutoDisposeFutureProvider<bool>.internal(
  propertyTypeFileExists,
  name: r'propertyTypeFileExistsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$propertyTypeFileExistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PropertyTypeFileExistsRef = AutoDisposeFutureProviderRef<bool>;
String _$globalPropertyTypeActionsHash() =>
    r'7e4f6daaceaf7f59b66e684d40c3d5f952189659';

/// Action provider for global property types
///
/// Provides actions for creating, updating, deleting property type definitions, etc.
///
/// Copied from [GlobalPropertyTypeActions].
@ProviderFor(GlobalPropertyTypeActions)
final globalPropertyTypeActionsProvider =
    AutoDisposeNotifierProvider<GlobalPropertyTypeActions, void>.internal(
      GlobalPropertyTypeActions.new,
      name: r'globalPropertyTypeActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$globalPropertyTypeActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GlobalPropertyTypeActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
