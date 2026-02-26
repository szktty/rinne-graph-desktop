// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_divider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides effective app color (supports active color scheme)

@ProviderFor(effectiveAppColorSchemeForDivider)
final effectiveAppColorSchemeForDividerProvider =
    EffectiveAppColorSchemeForDividerProvider._();

/// Provider that provides effective app color (supports active color scheme)

final class EffectiveAppColorSchemeForDividerProvider
    extends $FunctionalProvider<AppColorScheme, AppColorScheme, AppColorScheme>
    with $Provider<AppColorScheme> {
  /// Provider that provides effective app color (supports active color scheme)
  EffectiveAppColorSchemeForDividerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveAppColorSchemeForDividerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$effectiveAppColorSchemeForDividerHash();

  @$internal
  @override
  $ProviderElement<AppColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppColorScheme create(Ref ref) {
    return effectiveAppColorSchemeForDivider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppColorScheme>(value),
    );
  }
}

String _$effectiveAppColorSchemeForDividerHash() =>
    r'9a2c0b1085b9c14e1b9e381fbe0be253ddd7ec57';

/// Provider to get AppDivider color

@ProviderFor(appDividerColor)
final appDividerColorProvider = AppDividerColorProvider._();

/// Provider to get AppDivider color

final class AppDividerColorProvider
    extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// Provider to get AppDivider color
  AppDividerColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDividerColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDividerColorHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return appDividerColor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$appDividerColorHash() => r'6e5c3bceb61ee019c267555ac651b4e024636518';

/// Provider to get AppVerticalDivider color

@ProviderFor(appVerticalDividerColor)
final appVerticalDividerColorProvider = AppVerticalDividerColorProvider._();

/// Provider to get AppVerticalDivider color

final class AppVerticalDividerColorProvider
    extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// Provider to get AppVerticalDivider color
  AppVerticalDividerColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVerticalDividerColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVerticalDividerColorHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return appVerticalDividerColor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$appVerticalDividerColorHash() =>
    r'6f2153c536ad25701bd6fdbd87b950cab5bdcc60';
