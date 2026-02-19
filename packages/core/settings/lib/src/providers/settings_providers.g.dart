// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsManagerHash() => r'242c06a4349af13ff9db10e59c5999971965731f';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
