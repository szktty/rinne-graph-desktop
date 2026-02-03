// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$effectiveColorSchemeHash() =>
    r'589bf01db8fd693a48ca4bead63d5ffe0bba7dfc';

/// Provider that obtains the AppColorScheme to be actually applied, based on the current theme, system brightness settings, and theme color.
///
/// Copied from [effectiveColorScheme].
@ProviderFor(effectiveColorScheme)
final effectiveColorSchemeProvider =
    AutoDisposeProvider<AppColorScheme>.internal(
      effectiveColorScheme,
      name: r'effectiveColorSchemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$effectiveColorSchemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EffectiveColorSchemeRef = AutoDisposeProviderRef<AppColorScheme>;
String _$effectiveFlutterColorSchemeHash() =>
    r'9158c77dc12f75e118311eab5869a01050b0d9e8';

/// Provider that obtains the Flutter ColorScheme to be actually applied, based on the current theme and system brightness settings.
///
/// Copied from [effectiveFlutterColorScheme].
@ProviderFor(effectiveFlutterColorScheme)
final effectiveFlutterColorSchemeProvider =
    AutoDisposeProvider<ColorScheme>.internal(
      effectiveFlutterColorScheme,
      name: r'effectiveFlutterColorSchemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$effectiveFlutterColorSchemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EffectiveFlutterColorSchemeRef = AutoDisposeProviderRef<ColorScheme>;
String _$effectiveThemeDataHash() =>
    r'b53b3e860fe13680522d98d3279766eee9633c22';

/// Provider that obtains the ThemeData to be actually applied, based on the current theme and system brightness settings.
///
/// Copied from [effectiveThemeData].
@ProviderFor(effectiveThemeData)
final effectiveThemeDataProvider = AutoDisposeProvider<ThemeData>.internal(
  effectiveThemeData,
  name: r'effectiveThemeDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$effectiveThemeDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EffectiveThemeDataRef = AutoDisposeProviderRef<ThemeData>;
String _$platformBrightnessHash() =>
    r'd37c37e08bd41784f86b652abc695a15d47ab4a7';

/// Provider that monitors platform brightness settings.
///
/// Copied from [PlatformBrightness].
@ProviderFor(PlatformBrightness)
final platformBrightnessProvider =
    AutoDisposeNotifierProvider<PlatformBrightness, Brightness>.internal(
      PlatformBrightness.new,
      name: r'platformBrightnessProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$platformBrightnessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PlatformBrightness = AutoDisposeNotifier<Brightness>;
String _$customThemeHash() => r'38137ed226c04da99b1339221a68a5dcebcda865';

/// Custom theme management Provider.
///
/// Copied from [CustomTheme].
@ProviderFor(CustomTheme)
final customThemeProvider =
    AutoDisposeNotifierProvider<CustomTheme, AppThemeData>.internal(
      CustomTheme.new,
      name: r'customThemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomTheme = AutoDisposeNotifier<AppThemeData>;
String _$activeThemeHash() => r'b11c83ae139357007e089375745e258442372fb0';

/// Active theme management Provider.
///
/// Copied from [ActiveTheme].
@ProviderFor(ActiveTheme)
final activeThemeProvider =
    AutoDisposeNotifierProvider<ActiveTheme, AppThemeData>.internal(
      ActiveTheme.new,
      name: r'activeThemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveTheme = AutoDisposeNotifier<AppThemeData>;
String _$accessibilityConfigHash() =>
    r'755d923e15958fc21ab2f7b7be581b7c38304cf2';

/// Provider that manages accessibility settings.
///
/// Copied from [AccessibilityConfig].
@ProviderFor(AccessibilityConfig)
final accessibilityConfigProvider = AutoDisposeNotifierProvider<
  AccessibilityConfig,
  AppAccessibilityConfig
>.internal(
  AccessibilityConfig.new,
  name: r'accessibilityConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accessibilityConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccessibilityConfig = AutoDisposeNotifier<AppAccessibilityConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
