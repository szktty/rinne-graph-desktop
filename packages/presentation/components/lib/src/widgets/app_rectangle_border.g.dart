// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_rectangle_border.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appRectangleBorderHash() =>
    r'c2b7faf6ae7f5398cad341e3753e31caf10bf7da';

/// Provider that generates AppRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.
///
/// Copied from [appRectangleBorder].
@ProviderFor(appRectangleBorder)
final appRectangleBorderProvider =
    AutoDisposeProvider<SmoothRectangleBorder>.internal(
      appRectangleBorder,
      name: r'appRectangleBorderProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$appRectangleBorderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRectangleBorderRef = AutoDisposeProviderRef<SmoothRectangleBorder>;
String _$appShapeDecorationHash() =>
    r'8c50c97941651b28691fb5833124618ebe76b3e3';

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

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.
///
/// Copied from [appShapeDecoration].
@ProviderFor(appShapeDecoration)
const appShapeDecorationProvider = AppShapeDecorationFamily();

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.
///
/// Copied from [appShapeDecoration].
class AppShapeDecorationFamily extends Family<ShapeDecoration> {
  /// Provider that generates ShapeDecoration for AppRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.
  ///
  /// Copied from [appShapeDecoration].
  const AppShapeDecorationFamily();

  /// Provider that generates ShapeDecoration for AppRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.
  ///
  /// Copied from [appShapeDecoration].
  AppShapeDecorationProvider call({
    Color? color,
    double? cornerRadius,
    double? cornerSmoothing,
    BorderSide? side,
  }) {
    return AppShapeDecorationProvider(
      color: color,
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
      side: side,
    );
  }

  @override
  AppShapeDecorationProvider getProviderOverride(
    covariant AppShapeDecorationProvider provider,
  ) {
    return call(
      color: provider.color,
      cornerRadius: provider.cornerRadius,
      cornerSmoothing: provider.cornerSmoothing,
      side: provider.side,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'appShapeDecorationProvider';
}

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.
///
/// Copied from [appShapeDecoration].
class AppShapeDecorationProvider extends AutoDisposeProvider<ShapeDecoration> {
  /// Provider that generates ShapeDecoration for AppRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.
  ///
  /// Copied from [appShapeDecoration].
  AppShapeDecorationProvider({
    Color? color,
    double? cornerRadius,
    double? cornerSmoothing,
    BorderSide? side,
  }) : this._internal(
         (ref) => appShapeDecoration(
           ref as AppShapeDecorationRef,
           color: color,
           cornerRadius: cornerRadius,
           cornerSmoothing: cornerSmoothing,
           side: side,
         ),
         from: appShapeDecorationProvider,
         name: r'appShapeDecorationProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$appShapeDecorationHash,
         dependencies: AppShapeDecorationFamily._dependencies,
         allTransitiveDependencies:
             AppShapeDecorationFamily._allTransitiveDependencies,
         color: color,
         cornerRadius: cornerRadius,
         cornerSmoothing: cornerSmoothing,
         side: side,
       );

  AppShapeDecorationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.color,
    required this.cornerRadius,
    required this.cornerSmoothing,
    required this.side,
  }) : super.internal();

  final Color? color;
  final double? cornerRadius;
  final double? cornerSmoothing;
  final BorderSide? side;

  @override
  Override overrideWith(
    ShapeDecoration Function(AppShapeDecorationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppShapeDecorationProvider._internal(
        (ref) => create(ref as AppShapeDecorationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        color: color,
        cornerRadius: cornerRadius,
        cornerSmoothing: cornerSmoothing,
        side: side,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ShapeDecoration> createElement() {
    return _AppShapeDecorationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppShapeDecorationProvider &&
        other.color == color &&
        other.cornerRadius == cornerRadius &&
        other.cornerSmoothing == cornerSmoothing &&
        other.side == side;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, color.hashCode);
    hash = _SystemHash.combine(hash, cornerRadius.hashCode);
    hash = _SystemHash.combine(hash, cornerSmoothing.hashCode);
    hash = _SystemHash.combine(hash, side.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppShapeDecorationRef on AutoDisposeProviderRef<ShapeDecoration> {
  /// The parameter `color` of this provider.
  Color? get color;

  /// The parameter `cornerRadius` of this provider.
  double? get cornerRadius;

  /// The parameter `cornerSmoothing` of this provider.
  double? get cornerSmoothing;

  /// The parameter `side` of this provider.
  BorderSide? get side;
}

class _AppShapeDecorationProviderElement
    extends AutoDisposeProviderElement<ShapeDecoration>
    with AppShapeDecorationRef {
  _AppShapeDecorationProviderElement(super.provider);

  @override
  Color? get color => (origin as AppShapeDecorationProvider).color;
  @override
  double? get cornerRadius =>
      (origin as AppShapeDecorationProvider).cornerRadius;
  @override
  double? get cornerSmoothing =>
      (origin as AppShapeDecorationProvider).cornerSmoothing;
  @override
  BorderSide? get side => (origin as AppShapeDecorationProvider).side;
}

String _$appBorderRadiusHash() => r'c7c60b7c4fd2b7fb9501a7743dc6fc4a45f955a0';

/// Provider that generates AppBorderRadius
///
/// Provider for providing unified border radius across the app.
///
/// Copied from [appBorderRadius].
@ProviderFor(appBorderRadius)
final appBorderRadiusProvider = AutoDisposeProvider<AppBorderRadius>.internal(
  appBorderRadius,
  name: r'appBorderRadiusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appBorderRadiusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppBorderRadiusRef = AutoDisposeProviderRef<AppBorderRadius>;
String _$appBorderSideHash() => r'a60d5365cff37ec784f471f3ae7ff78a7e2c4729';

/// Provider that generates AppBorderSide
///
/// Provider for providing unified border style across the app.
///
/// Copied from [appBorderSide].
@ProviderFor(appBorderSide)
final appBorderSideProvider = AutoDisposeProvider<AppBorderSide>.internal(
  appBorderSide,
  name: r'appBorderSideProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appBorderSideHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppBorderSideRef = AutoDisposeProviderRef<AppBorderSide>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
