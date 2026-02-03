// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsStorageServiceHash() =>
    r'83e8e32ffa993a9c7e0c463033b682540604a08b';

/// Provider for SettingsStorageService instance
///
/// Copied from [settingsStorageService].
@ProviderFor(settingsStorageService)
final settingsStorageServiceProvider =
    AutoDisposeProvider<SettingsStorageService>.internal(
      settingsStorageService,
      name: r'settingsStorageServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsStorageServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsStorageServiceRef =
    AutoDisposeProviderRef<SettingsStorageService>;
String _$settingsOperationsHash() =>
    r'e4cd9b825c76996cc2153fffb82343ea25dd3a9c';

/// Helper provider for settings operations
///
/// Copied from [settingsOperations].
@ProviderFor(settingsOperations)
final settingsOperationsProvider =
    AutoDisposeProvider<SettingsOperations>.internal(
      settingsOperations,
      name: r'settingsOperationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsOperationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsOperationsRef = AutoDisposeProviderRef<SettingsOperations>;
String _$appSettingsManagerHash() =>
    r'8a1e63044acf017ec72145a01fa78e147979c861';

/// Provider for managing application settings
///
/// Copied from [AppSettingsManager].
@ProviderFor(AppSettingsManager)
final appSettingsManagerProvider =
    AutoDisposeAsyncNotifierProvider<AppSettingsManager, AppSettings>.internal(
      AppSettingsManager.new,
      name: r'appSettingsManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$appSettingsManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppSettingsManager = AutoDisposeAsyncNotifier<AppSettings>;
String _$autoSaveManagerHash() => r'1cc30876025c94b57f5e3abc3b141d04bede3373';

/// Provider for managing auto-save settings
///
/// Copied from [AutoSaveManager].
@ProviderFor(AutoSaveManager)
final autoSaveManagerProvider =
    AutoDisposeNotifierProvider<AutoSaveManager, bool>.internal(
      AutoSaveManager.new,
      name: r'autoSaveManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$autoSaveManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AutoSaveManager = AutoDisposeNotifier<bool>;
String _$settingsWatcherHash() => r'3066b3ac67e5716295b8e8a29fe0d65d2a42ab94';

/// Provider for monitoring settings changes and auto-saving
///
/// Copied from [SettingsWatcher].
@ProviderFor(SettingsWatcher)
final settingsWatcherProvider =
    AutoDisposeNotifierProvider<SettingsWatcher, void>.internal(
      SettingsWatcher.new,
      name: r'settingsWatcherProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsWatcherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsWatcher = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
