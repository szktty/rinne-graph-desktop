// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages application settings.

@ProviderFor(SettingsManager)
final settingsManagerProvider = SettingsManagerProvider._();

/// Provider that manages application settings.
final class SettingsManagerProvider
    extends $NotifierProvider<SettingsManager, Settings> {
  /// Provider that manages application settings.
  SettingsManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsManagerHash();

  @$internal
  @override
  SettingsManager create() => SettingsManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Settings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Settings>(value),
    );
  }
}

String _$settingsManagerHash() => r'242c06a4349af13ff9db10e59c5999971965731f';

/// Provider that manages application settings.

abstract class _$SettingsManager extends $Notifier<Settings> {
  Settings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Settings, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Settings, Settings>,
              Settings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
