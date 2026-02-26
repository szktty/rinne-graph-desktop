// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_rectangle_border.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that generates AppRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.

@ProviderFor(appRectangleBorder)
final appRectangleBorderProvider = AppRectangleBorderProvider._();

/// Provider that generates AppRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.

final class AppRectangleBorderProvider
    extends
        $FunctionalProvider<
          SmoothRectangleBorder,
          SmoothRectangleBorder,
          SmoothRectangleBorder
        >
    with $Provider<SmoothRectangleBorder> {
  /// Provider that generates AppRectangleBorder
  ///
  /// Provider for providing unified border style across the app.
  /// Can be used outside widget tree as it includes access to appColors.
  AppRectangleBorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRectangleBorderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRectangleBorderHash();

  @$internal
  @override
  $ProviderElement<SmoothRectangleBorder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SmoothRectangleBorder create(Ref ref) {
    return appRectangleBorder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmoothRectangleBorder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SmoothRectangleBorder>(value),
    );
  }
}

String _$appRectangleBorderHash() =>
    r'c2b7faf6ae7f5398cad341e3753e31caf10bf7da';

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.

@ProviderFor(appShapeDecoration)
final appShapeDecorationProvider = AppShapeDecorationFamily._();

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.

final class AppShapeDecorationProvider
    extends
        $FunctionalProvider<ShapeDecoration, ShapeDecoration, ShapeDecoration>
    with $Provider<ShapeDecoration> {
  /// Provider that generates ShapeDecoration for AppRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.
  AppShapeDecorationProvider._({
    required AppShapeDecorationFamily super.from,
    required ({
      Color? color,
      double? cornerRadius,
      double? cornerSmoothing,
      BorderSide? side,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'appShapeDecorationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appShapeDecorationHash();

  @override
  String toString() {
    return r'appShapeDecorationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<ShapeDecoration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShapeDecoration create(Ref ref) {
    final argument =
        this.argument
            as ({
              Color? color,
              double? cornerRadius,
              double? cornerSmoothing,
              BorderSide? side,
            });
    return appShapeDecoration(
      ref,
      color: argument.color,
      cornerRadius: argument.cornerRadius,
      cornerSmoothing: argument.cornerSmoothing,
      side: argument.side,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShapeDecoration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShapeDecoration>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppShapeDecorationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appShapeDecorationHash() =>
    r'8c50c97941651b28691fb5833124618ebe76b3e3';

/// Provider that generates ShapeDecoration for AppRectangleBorder
///
/// Can be used directly in decoration property of Container etc.

final class AppShapeDecorationFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ShapeDecoration,
          ({
            Color? color,
            double? cornerRadius,
            double? cornerSmoothing,
            BorderSide? side,
          })
        > {
  AppShapeDecorationFamily._()
    : super(
        retry: null,
        name: r'appShapeDecorationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that generates ShapeDecoration for AppRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.

  AppShapeDecorationProvider call({
    Color? color,
    double? cornerRadius,
    double? cornerSmoothing,
    BorderSide? side,
  }) => AppShapeDecorationProvider._(
    argument: (
      color: color,
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
      side: side,
    ),
    from: this,
  );

  @override
  String toString() => r'appShapeDecorationProvider';
}

/// Provider that generates AppBorderRadius
///
/// Provider for providing unified border radius across the app.

@ProviderFor(appBorderRadius)
final appBorderRadiusProvider = AppBorderRadiusProvider._();

/// Provider that generates AppBorderRadius
///
/// Provider for providing unified border radius across the app.

final class AppBorderRadiusProvider
    extends
        $FunctionalProvider<AppBorderRadius, AppBorderRadius, AppBorderRadius>
    with $Provider<AppBorderRadius> {
  /// Provider that generates AppBorderRadius
  ///
  /// Provider for providing unified border radius across the app.
  AppBorderRadiusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBorderRadiusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBorderRadiusHash();

  @$internal
  @override
  $ProviderElement<AppBorderRadius> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppBorderRadius create(Ref ref) {
    return appBorderRadius(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppBorderRadius value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppBorderRadius>(value),
    );
  }
}

String _$appBorderRadiusHash() => r'c7c60b7c4fd2b7fb9501a7743dc6fc4a45f955a0';

/// Provider that generates AppBorderSide
///
/// Provider for providing unified border style across the app.

@ProviderFor(appBorderSide)
final appBorderSideProvider = AppBorderSideProvider._();

/// Provider that generates AppBorderSide
///
/// Provider for providing unified border style across the app.

final class AppBorderSideProvider
    extends $FunctionalProvider<AppBorderSide, AppBorderSide, AppBorderSide>
    with $Provider<AppBorderSide> {
  /// Provider that generates AppBorderSide
  ///
  /// Provider for providing unified border style across the app.
  AppBorderSideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBorderSideProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBorderSideHash();

  @$internal
  @override
  $ProviderElement<AppBorderSide> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppBorderSide create(Ref ref) {
    return appBorderSide(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppBorderSide value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppBorderSide>(value),
    );
  }
}

String _$appBorderSideHash() => r'a60d5365cff37ec784f471f3ae7ff78a7e2c4729';
