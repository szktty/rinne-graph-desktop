// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the active theme.

@ProviderFor(ActiveTheme)
final activeThemeProvider = ActiveThemeProvider._();

/// Provider that manages the active theme.
final class ActiveThemeProvider
    extends $NotifierProvider<ActiveTheme, core_themes.AppThemeData> {
  /// Provider that manages the active theme.
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
  Override overrideWithValue(core_themes.AppThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_themes.AppThemeData>(value),
    );
  }
}

String _$activeThemeHash() => r'58d30c28291187e57cf2cfbabe64df91ef5e3935';

/// Provider that manages the active theme.

abstract class _$ActiveTheme extends $Notifier<core_themes.AppThemeData> {
  core_themes.AppThemeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<core_themes.AppThemeData, core_themes.AppThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<core_themes.AppThemeData, core_themes.AppThemeData>,
              core_themes.AppThemeData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages custom themes.

@ProviderFor(CustomTheme)
final customThemeProvider = CustomThemeProvider._();

/// Provider that manages custom themes.
final class CustomThemeProvider
    extends $NotifierProvider<CustomTheme, core_themes.AppThemeData> {
  /// Provider that manages custom themes.
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
  Override overrideWithValue(core_themes.AppThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_themes.AppThemeData>(value),
    );
  }
}

String _$customThemeHash() => r'0a55f7e3c179e61e522af365cf0a7951a5b51c01';

/// Provider that manages custom themes.

abstract class _$CustomTheme extends $Notifier<core_themes.AppThemeData> {
  core_themes.AppThemeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<core_themes.AppThemeData, core_themes.AppThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<core_themes.AppThemeData, core_themes.AppThemeData>,
              core_themes.AppThemeData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that offers settings-related actions.

@ProviderFor(SettingsActions)
final settingsActionsProvider = SettingsActionsProvider._();

/// Provider that offers settings-related actions.
final class SettingsActionsProvider
    extends $NotifierProvider<SettingsActions, void> {
  /// Provider that offers settings-related actions.
  SettingsActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsActionsHash();

  @$internal
  @override
  SettingsActions create() => SettingsActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$settingsActionsHash() => r'a1a773e1f96573b5a46823f0b834f12b331cbb44';

/// Provider that offers settings-related actions.

abstract class _$SettingsActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
