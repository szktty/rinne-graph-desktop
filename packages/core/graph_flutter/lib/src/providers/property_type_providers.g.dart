// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_type_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Path of the stack whose property type definitions are in scope.
///
/// Overridden by the application layer, which is the only layer that knows
/// about the active stack — `core_graph_flutter` deliberately does not depend
/// on `core_stack_flutter`, so the path is injected rather than looked up.
///
/// Null when no stack is open, which leaves the type map empty and every
/// property untyped.

@ProviderFor(PropertyTypeStackPath)
final propertyTypeStackPathProvider = PropertyTypeStackPathProvider._();

/// Path of the stack whose property type definitions are in scope.
///
/// Overridden by the application layer, which is the only layer that knows
/// about the active stack — `core_graph_flutter` deliberately does not depend
/// on `core_stack_flutter`, so the path is injected rather than looked up.
///
/// Null when no stack is open, which leaves the type map empty and every
/// property untyped.
final class PropertyTypeStackPathProvider
    extends $NotifierProvider<PropertyTypeStackPath, String?> {
  /// Path of the stack whose property type definitions are in scope.
  ///
  /// Overridden by the application layer, which is the only layer that knows
  /// about the active stack — `core_graph_flutter` deliberately does not depend
  /// on `core_stack_flutter`, so the path is injected rather than looked up.
  ///
  /// Null when no stack is open, which leaves the type map empty and every
  /// property untyped.
  PropertyTypeStackPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyTypeStackPathProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyTypeStackPathHash();

  @$internal
  @override
  PropertyTypeStackPath create() => PropertyTypeStackPath();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$propertyTypeStackPathHash() =>
    r'7d7636c88b2c06b2690b37901519f31aac470bfe';

/// Path of the stack whose property type definitions are in scope.
///
/// Overridden by the application layer, which is the only layer that knows
/// about the active stack — `core_graph_flutter` deliberately does not depend
/// on `core_stack_flutter`, so the path is injected rather than looked up.
///
/// Null when no stack is open, which leaves the type map empty and every
/// property untyped.

abstract class _$PropertyTypeStackPath extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Manager for the active stack's property type definitions.
///
/// Rebuilt whenever the stack path changes, so its in-memory cache never
/// outlives the stack it was populated from.

@ProviderFor(propertyTypeManager)
final propertyTypeManagerProvider = PropertyTypeManagerProvider._();

/// Manager for the active stack's property type definitions.
///
/// Rebuilt whenever the stack path changes, so its in-memory cache never
/// outlives the stack it was populated from.

final class PropertyTypeManagerProvider
    extends
        $FunctionalProvider<
          GlobalPropertyTypeManager?,
          GlobalPropertyTypeManager?,
          GlobalPropertyTypeManager?
        >
    with $Provider<GlobalPropertyTypeManager?> {
  /// Manager for the active stack's property type definitions.
  ///
  /// Rebuilt whenever the stack path changes, so its in-memory cache never
  /// outlives the stack it was populated from.
  PropertyTypeManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyTypeManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyTypeManagerHash();

  @$internal
  @override
  $ProviderElement<GlobalPropertyTypeManager?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlobalPropertyTypeManager? create(Ref ref) {
    return propertyTypeManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalPropertyTypeManager? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalPropertyTypeManager?>(value),
    );
  }
}

String _$propertyTypeManagerHash() =>
    r'7c78439759ab6cce969921cbfb1d2176ee038a3d';

/// Resolves the type definition of [propertyName] for an entity with [labels].
///
/// Follows the manager's resolution order — label-scoped first, then
/// stack-wide — and yields null when nothing defines the property, which
/// callers read as "untyped" and render as plain text.

@ProviderFor(propertyTypeDefinition)
final propertyTypeDefinitionProvider = PropertyTypeDefinitionFamily._();

/// Resolves the type definition of [propertyName] for an entity with [labels].
///
/// Follows the manager's resolution order — label-scoped first, then
/// stack-wide — and yields null when nothing defines the property, which
/// callers read as "untyped" and render as plain text.

final class PropertyTypeDefinitionProvider
    extends
        $FunctionalProvider<
          AsyncValue<GlobalPropertyTypeDefinition?>,
          GlobalPropertyTypeDefinition?,
          FutureOr<GlobalPropertyTypeDefinition?>
        >
    with
        $FutureModifier<GlobalPropertyTypeDefinition?>,
        $FutureProvider<GlobalPropertyTypeDefinition?> {
  /// Resolves the type definition of [propertyName] for an entity with [labels].
  ///
  /// Follows the manager's resolution order — label-scoped first, then
  /// stack-wide — and yields null when nothing defines the property, which
  /// callers read as "untyped" and render as plain text.
  PropertyTypeDefinitionProvider._({
    required PropertyTypeDefinitionFamily super.from,
    required (String, List<String>) super.argument,
  }) : super(
         retry: null,
         name: r'propertyTypeDefinitionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$propertyTypeDefinitionHash();

  @override
  String toString() {
    return r'propertyTypeDefinitionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GlobalPropertyTypeDefinition?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GlobalPropertyTypeDefinition?> create(Ref ref) {
    final argument = this.argument as (String, List<String>);
    return propertyTypeDefinition(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PropertyTypeDefinitionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$propertyTypeDefinitionHash() =>
    r'f3a5f5f5dc044663a2a288e5f9363fb3a3324d2c';

/// Resolves the type definition of [propertyName] for an entity with [labels].
///
/// Follows the manager's resolution order — label-scoped first, then
/// stack-wide — and yields null when nothing defines the property, which
/// callers read as "untyped" and render as plain text.

final class PropertyTypeDefinitionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GlobalPropertyTypeDefinition?>,
          (String, List<String>)
        > {
  PropertyTypeDefinitionFamily._()
    : super(
        retry: null,
        name: r'propertyTypeDefinitionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves the type definition of [propertyName] for an entity with [labels].
  ///
  /// Follows the manager's resolution order — label-scoped first, then
  /// stack-wide — and yields null when nothing defines the property, which
  /// callers read as "untyped" and render as plain text.

  PropertyTypeDefinitionProvider call(
    String propertyName,
    List<String> labels,
  ) => PropertyTypeDefinitionProvider._(
    argument: (propertyName, labels),
    from: this,
  );

  @override
  String toString() => r'propertyTypeDefinitionProvider';
}

/// Resolves [propertyName] to a concrete [PropertyType] for [labels].
///
/// Null means untyped — the editor falls back to a plain text field. A type
/// name this build does not recognise also resolves to null, so a stack
/// written by a newer version degrades rather than throwing.

@ProviderFor(resolvedPropertyType)
final resolvedPropertyTypeProvider = ResolvedPropertyTypeFamily._();

/// Resolves [propertyName] to a concrete [PropertyType] for [labels].
///
/// Null means untyped — the editor falls back to a plain text field. A type
/// name this build does not recognise also resolves to null, so a stack
/// written by a newer version degrades rather than throwing.

final class ResolvedPropertyTypeProvider
    extends
        $FunctionalProvider<
          AsyncValue<PropertyType?>,
          PropertyType?,
          FutureOr<PropertyType?>
        >
    with $FutureModifier<PropertyType?>, $FutureProvider<PropertyType?> {
  /// Resolves [propertyName] to a concrete [PropertyType] for [labels].
  ///
  /// Null means untyped — the editor falls back to a plain text field. A type
  /// name this build does not recognise also resolves to null, so a stack
  /// written by a newer version degrades rather than throwing.
  ResolvedPropertyTypeProvider._({
    required ResolvedPropertyTypeFamily super.from,
    required (String, List<String>) super.argument,
  }) : super(
         retry: null,
         name: r'resolvedPropertyTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$resolvedPropertyTypeHash();

  @override
  String toString() {
    return r'resolvedPropertyTypeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PropertyType?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PropertyType?> create(Ref ref) {
    final argument = this.argument as (String, List<String>);
    return resolvedPropertyType(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ResolvedPropertyTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$resolvedPropertyTypeHash() =>
    r'5a9e9cfab7f7729751a4bfe3b4dee68bd5da2506';

/// Resolves [propertyName] to a concrete [PropertyType] for [labels].
///
/// Null means untyped — the editor falls back to a plain text field. A type
/// name this build does not recognise also resolves to null, so a stack
/// written by a newer version degrades rather than throwing.

final class ResolvedPropertyTypeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PropertyType?>,
          (String, List<String>)
        > {
  ResolvedPropertyTypeFamily._()
    : super(
        retry: null,
        name: r'resolvedPropertyTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves [propertyName] to a concrete [PropertyType] for [labels].
  ///
  /// Null means untyped — the editor falls back to a plain text field. A type
  /// name this build does not recognise also resolves to null, so a stack
  /// written by a newer version degrades rather than throwing.

  ResolvedPropertyTypeProvider call(String propertyName, List<String> labels) =>
      ResolvedPropertyTypeProvider._(
        argument: (propertyName, labels),
        from: this,
      );

  @override
  String toString() => r'resolvedPropertyTypeProvider';
}

/// Every property type defined for [labels], keyed by property name.
///
/// Lets the editor resolve a whole property list in one pass instead of
/// watching a provider per row. Label-scoped definitions win over stack-wide
/// ones, and within the labels the first match wins, matching
/// [GlobalPropertyTypeManager.getPropertyTypeForLabels].

@ProviderFor(propertyTypesForLabels)
final propertyTypesForLabelsProvider = PropertyTypesForLabelsFamily._();

/// Every property type defined for [labels], keyed by property name.
///
/// Lets the editor resolve a whole property list in one pass instead of
/// watching a provider per row. Label-scoped definitions win over stack-wide
/// ones, and within the labels the first match wins, matching
/// [GlobalPropertyTypeManager.getPropertyTypeForLabels].

final class PropertyTypesForLabelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, PropertyType>>,
          Map<String, PropertyType>,
          FutureOr<Map<String, PropertyType>>
        >
    with
        $FutureModifier<Map<String, PropertyType>>,
        $FutureProvider<Map<String, PropertyType>> {
  /// Every property type defined for [labels], keyed by property name.
  ///
  /// Lets the editor resolve a whole property list in one pass instead of
  /// watching a provider per row. Label-scoped definitions win over stack-wide
  /// ones, and within the labels the first match wins, matching
  /// [GlobalPropertyTypeManager.getPropertyTypeForLabels].
  PropertyTypesForLabelsProvider._({
    required PropertyTypesForLabelsFamily super.from,
    required List<String> super.argument,
  }) : super(
         retry: null,
         name: r'propertyTypesForLabelsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$propertyTypesForLabelsHash();

  @override
  String toString() {
    return r'propertyTypesForLabelsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, PropertyType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, PropertyType>> create(Ref ref) {
    final argument = this.argument as List<String>;
    return propertyTypesForLabels(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PropertyTypesForLabelsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$propertyTypesForLabelsHash() =>
    r'dac1a757c12b6b04c9b81977cc80fb15654c6709';

/// Every property type defined for [labels], keyed by property name.
///
/// Lets the editor resolve a whole property list in one pass instead of
/// watching a provider per row. Label-scoped definitions win over stack-wide
/// ones, and within the labels the first match wins, matching
/// [GlobalPropertyTypeManager.getPropertyTypeForLabels].

final class PropertyTypesForLabelsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, PropertyType>>,
          List<String>
        > {
  PropertyTypesForLabelsFamily._()
    : super(
        retry: null,
        name: r'propertyTypesForLabelsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every property type defined for [labels], keyed by property name.
  ///
  /// Lets the editor resolve a whole property list in one pass instead of
  /// watching a provider per row. Label-scoped definitions win over stack-wide
  /// ones, and within the labels the first match wins, matching
  /// [GlobalPropertyTypeManager.getPropertyTypeForLabels].

  PropertyTypesForLabelsProvider call(List<String> labels) =>
      PropertyTypesForLabelsProvider._(argument: labels, from: this);

  @override
  String toString() => r'propertyTypesForLabelsProvider';
}
