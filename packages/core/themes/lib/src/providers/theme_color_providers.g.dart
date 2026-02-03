// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_color_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeColorSchemeHash() => r'983cab9cc953179a36a3b97f1f8c51179b30152d';

/// Theme color scheme.
///
/// Copied from [themeColorScheme].
@ProviderFor(themeColorScheme)
final themeColorSchemeProvider =
    AutoDisposeProvider<models.ThemeColorScheme>.internal(
      themeColorScheme,
      name: r'themeColorSchemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$themeColorSchemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThemeColorSchemeRef = AutoDisposeProviderRef<models.ThemeColorScheme>;
String _$effectiveColorSchemeWithThemeHash() =>
    r'269075b2959b44043cc7fbf786ef616c207ad811';

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the AppColorScheme to be actually applied.
///
/// Copied from [effectiveColorSchemeWithTheme].
@ProviderFor(effectiveColorSchemeWithTheme)
final effectiveColorSchemeWithThemeProvider =
    AutoDisposeProvider<AppColorScheme>.internal(
      effectiveColorSchemeWithTheme,
      name: r'effectiveColorSchemeWithThemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$effectiveColorSchemeWithThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EffectiveColorSchemeWithThemeRef =
    AutoDisposeProviderRef<AppColorScheme>;
String _$themeColorTypeHash() => r'766cb305b32f0040608d91f246bc88906035ed2d';

/// Currently selected theme color type.
///
/// Copied from [ThemeColorType].
@ProviderFor(ThemeColorType)
final themeColorTypeProvider =
    AutoDisposeNotifierProvider<ThemeColorType, models.ThemeColorType>.internal(
      ThemeColorType.new,
      name: r'themeColorTypeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$themeColorTypeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeColorType = AutoDisposeNotifier<models.ThemeColorType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
