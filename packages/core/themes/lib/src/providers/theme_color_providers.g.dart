// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_color_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Currently selected theme color type.

@ProviderFor(ThemeColorType)
final themeColorTypeProvider = ThemeColorTypeProvider._();

/// Currently selected theme color type.
final class ThemeColorTypeProvider
    extends $NotifierProvider<ThemeColorType, models.ThemeColorType> {
  /// Currently selected theme color type.
  ThemeColorTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeColorTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeColorTypeHash();

  @$internal
  @override
  ThemeColorType create() => ThemeColorType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(models.ThemeColorType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<models.ThemeColorType>(value),
    );
  }
}

String _$themeColorTypeHash() => r'766cb305b32f0040608d91f246bc88906035ed2d';

/// Currently selected theme color type.

abstract class _$ThemeColorType extends $Notifier<models.ThemeColorType> {
  models.ThemeColorType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<models.ThemeColorType, models.ThemeColorType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<models.ThemeColorType, models.ThemeColorType>,
              models.ThemeColorType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Theme color scheme.

@ProviderFor(themeColorScheme)
final themeColorSchemeProvider = ThemeColorSchemeProvider._();

/// Theme color scheme.

final class ThemeColorSchemeProvider
    extends
        $FunctionalProvider<
          models.ThemeColorScheme,
          models.ThemeColorScheme,
          models.ThemeColorScheme
        >
    with $Provider<models.ThemeColorScheme> {
  /// Theme color scheme.
  ThemeColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeColorSchemeHash();

  @$internal
  @override
  $ProviderElement<models.ThemeColorScheme> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  models.ThemeColorScheme create(Ref ref) {
    return themeColorScheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(models.ThemeColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<models.ThemeColorScheme>(value),
    );
  }
}

String _$themeColorSchemeHash() => r'983cab9cc953179a36a3b97f1f8c51179b30152d';

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the AppColorScheme to be actually applied.

@ProviderFor(effectiveColorSchemeWithTheme)
final effectiveColorSchemeWithThemeProvider =
    EffectiveColorSchemeWithThemeProvider._();

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the AppColorScheme to be actually applied.

final class EffectiveColorSchemeWithThemeProvider
    extends $FunctionalProvider<AppColorScheme, AppColorScheme, AppColorScheme>
    with $Provider<AppColorScheme> {
  /// Based on the current theme, system brightness settings, and theme color,
  /// a Provider that obtains the AppColorScheme to be actually applied.
  EffectiveColorSchemeWithThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveColorSchemeWithThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveColorSchemeWithThemeHash();

  @$internal
  @override
  $ProviderElement<AppColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppColorScheme create(Ref ref) {
    return effectiveColorSchemeWithTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppColorScheme>(value),
    );
  }
}

String _$effectiveColorSchemeWithThemeHash() =>
    r'269075b2959b44043cc7fbf786ef616c207ad811';
