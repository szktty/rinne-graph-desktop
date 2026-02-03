// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsManagerHash() => r'd722da5234231ddfe0f91b10f31fa901c4668e50';

/// Provider that manages application settings.
///
/// Copied from [SettingsManager].
@ProviderFor(SettingsManager)
final settingsManagerProvider =
    AutoDisposeNotifierProvider<SettingsManager, Settings>.internal(
      SettingsManager.new,
      name: r'settingsManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsManager = AutoDisposeNotifier<Settings>;
String _$activeThemeHash() => r'0658ad5f57ce1e20de9c1f09a82f48209459ebcf';

/// Provider that manages the active theme.
///
/// Copied from [ActiveTheme].
@ProviderFor(ActiveTheme)
final activeThemeProvider =
    AutoDisposeNotifierProvider<ActiveTheme, core_themes.AppThemeData>.internal(
      ActiveTheme.new,
      name: r'activeThemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveTheme = AutoDisposeNotifier<core_themes.AppThemeData>;
String _$customThemeHash() => r'0a55f7e3c179e61e522af365cf0a7951a5b51c01';

/// Provider that manages custom themes.
///
/// Copied from [CustomTheme].
@ProviderFor(CustomTheme)
final customThemeProvider =
    AutoDisposeNotifierProvider<CustomTheme, core_themes.AppThemeData>.internal(
      CustomTheme.new,
      name: r'customThemeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$customThemeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomTheme = AutoDisposeNotifier<core_themes.AppThemeData>;
String _$settingsActionsHash() => r'a1a773e1f96573b5a46823f0b834f12b331cbb44';

/// Provider that offers settings-related actions.
///
/// Copied from [SettingsActions].
@ProviderFor(SettingsActions)
final settingsActionsProvider =
    AutoDisposeNotifierProvider<SettingsActions, void>.internal(
      SettingsActions.new,
      name: r'settingsActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
