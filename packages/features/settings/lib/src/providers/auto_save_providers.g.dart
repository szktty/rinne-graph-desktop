// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_save_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing auto-save settings.

@ProviderFor(AutoSaveSettingsNotifier)
final autoSaveSettingsProvider = AutoSaveSettingsNotifierProvider._();

/// Provider for managing auto-save settings.
final class AutoSaveSettingsNotifierProvider
    extends $NotifierProvider<AutoSaveSettingsNotifier, AutoSaveSettings> {
  /// Provider for managing auto-save settings.
  AutoSaveSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSaveSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSaveSettingsNotifierHash();

  @$internal
  @override
  AutoSaveSettingsNotifier create() => AutoSaveSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoSaveSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoSaveSettings>(value),
    );
  }
}

String _$autoSaveSettingsNotifierHash() =>
    r'bb0e1cb0f8387634a203c5de0fa98767b948b3ca';

/// Provider for managing auto-save settings.

abstract class _$AutoSaveSettingsNotifier extends $Notifier<AutoSaveSettings> {
  AutoSaveSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AutoSaveSettings, AutoSaveSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AutoSaveSettings, AutoSaveSettings>,
              AutoSaveSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
