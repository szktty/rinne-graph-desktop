// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that monitors platform brightness settings.

@ProviderFor(PlatformBrightness)
final platformBrightnessProvider = PlatformBrightnessProvider._();

/// Provider that monitors platform brightness settings.
final class PlatformBrightnessProvider
    extends $NotifierProvider<PlatformBrightness, Brightness> {
  /// Provider that monitors platform brightness settings.
  PlatformBrightnessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformBrightnessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformBrightnessHash();

  @$internal
  @override
  PlatformBrightness create() => PlatformBrightness();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Brightness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Brightness>(value),
    );
  }
}

String _$platformBrightnessHash() =>
    r'd37c37e08bd41784f86b652abc695a15d47ab4a7';

/// Provider that monitors platform brightness settings.

abstract class _$PlatformBrightness extends $Notifier<Brightness> {
  Brightness build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Brightness, Brightness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Brightness, Brightness>,
              Brightness,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Custom theme management Provider.

@ProviderFor(CustomTheme)
final customThemeProvider = CustomThemeProvider._();

/// Custom theme management Provider.
final class CustomThemeProvider
    extends $NotifierProvider<CustomTheme, AppThemeData> {
  /// Custom theme management Provider.
  CustomThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customThemeHash();

  @$internal
  @override
  CustomTheme create() => CustomTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeData>(value),
    );
  }
}

String _$customThemeHash() => r'38137ed226c04da99b1339221a68a5dcebcda865';

/// Custom theme management Provider.

abstract class _$CustomTheme extends $Notifier<AppThemeData> {
  AppThemeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppThemeData, AppThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeData, AppThemeData>,
              AppThemeData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Active theme management Provider.

@ProviderFor(ActiveTheme)
final activeThemeProvider = ActiveThemeProvider._();

/// Active theme management Provider.
final class ActiveThemeProvider
    extends $NotifierProvider<ActiveTheme, AppThemeData> {
  /// Active theme management Provider.
  ActiveThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeThemeHash();

  @$internal
  @override
  ActiveTheme create() => ActiveTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeData>(value),
    );
  }
}

String _$activeThemeHash() => r'b11c83ae139357007e089375745e258442372fb0';

/// Active theme management Provider.

abstract class _$ActiveTheme extends $Notifier<AppThemeData> {
  AppThemeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppThemeData, AppThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeData, AppThemeData>,
              AppThemeData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that obtains the AppColorScheme to be actually applied, based on the current theme, system brightness settings, and theme color.

@ProviderFor(effectiveColorScheme)
final effectiveColorSchemeProvider = EffectiveColorSchemeProvider._();

/// Provider that obtains the AppColorScheme to be actually applied, based on the current theme, system brightness settings, and theme color.

final class EffectiveColorSchemeProvider
    extends $FunctionalProvider<AppColorScheme, AppColorScheme, AppColorScheme>
    with $Provider<AppColorScheme> {
  /// Provider that obtains the AppColorScheme to be actually applied, based on the current theme, system brightness settings, and theme color.
  EffectiveColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveColorSchemeHash();

  @$internal
  @override
  $ProviderElement<AppColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppColorScheme create(Ref ref) {
    return effectiveColorScheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppColorScheme>(value),
    );
  }
}

String _$effectiveColorSchemeHash() =>
    r'589bf01db8fd693a48ca4bead63d5ffe0bba7dfc';

/// Provider that obtains the Flutter ColorScheme to be actually applied, based on the current theme and system brightness settings.

@ProviderFor(effectiveFlutterColorScheme)
final effectiveFlutterColorSchemeProvider =
    EffectiveFlutterColorSchemeProvider._();

/// Provider that obtains the Flutter ColorScheme to be actually applied, based on the current theme and system brightness settings.

final class EffectiveFlutterColorSchemeProvider
    extends $FunctionalProvider<ColorScheme, ColorScheme, ColorScheme>
    with $Provider<ColorScheme> {
  /// Provider that obtains the Flutter ColorScheme to be actually applied, based on the current theme and system brightness settings.
  EffectiveFlutterColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveFlutterColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveFlutterColorSchemeHash();

  @$internal
  @override
  $ProviderElement<ColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ColorScheme create(Ref ref) {
    return effectiveFlutterColorScheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorScheme>(value),
    );
  }
}

String _$effectiveFlutterColorSchemeHash() =>
    r'9158c77dc12f75e118311eab5869a01050b0d9e8';

/// Provider that obtains the ThemeData to be actually applied, based on the current theme and system brightness settings.

@ProviderFor(effectiveThemeData)
final effectiveThemeDataProvider = EffectiveThemeDataProvider._();

/// Provider that obtains the ThemeData to be actually applied, based on the current theme and system brightness settings.

final class EffectiveThemeDataProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provider that obtains the ThemeData to be actually applied, based on the current theme and system brightness settings.
  EffectiveThemeDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveThemeDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveThemeDataHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return effectiveThemeData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$effectiveThemeDataHash() =>
    r'b53b3e860fe13680522d98d3279766eee9633c22';

/// Provider that manages accessibility settings.

@ProviderFor(AccessibilityConfig)
final accessibilityConfigProvider = AccessibilityConfigProvider._();

/// Provider that manages accessibility settings.
final class AccessibilityConfigProvider
    extends $NotifierProvider<AccessibilityConfig, AppAccessibilityConfig> {
  /// Provider that manages accessibility settings.
  AccessibilityConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessibilityConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessibilityConfigHash();

  @$internal
  @override
  AccessibilityConfig create() => AccessibilityConfig();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppAccessibilityConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppAccessibilityConfig>(value),
    );
  }
}

String _$accessibilityConfigHash() =>
    r'755d923e15958fc21ab2f7b7be581b7c38304cf2';

/// Provider that manages accessibility settings.

abstract class _$AccessibilityConfig extends $Notifier<AppAccessibilityConfig> {
  AppAccessibilityConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AppAccessibilityConfig, AppAccessibilityConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppAccessibilityConfig, AppAccessibilityConfig>,
              AppAccessibilityConfig,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
