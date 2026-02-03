// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appConfigHash() => r'f2322b22a1e512d6fb438c0992b739dae1a9cec8';

/// Provider for getting current application configuration
///
/// Copied from [appConfig].
@ProviderFor(appConfig)
final appConfigProvider = AutoDisposeProvider<AppConfig>.internal(
  appConfig,
  name: r'appConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppConfigRef = AutoDisposeProviderRef<AppConfig>;
String _$debugConfigHash() => r'1a3cd00fdbde34da28878a9bed7a2724a4b77366';

/// Debug configuration provider
///
/// Copied from [debugConfig].
@ProviderFor(debugConfig)
final debugConfigProvider = AutoDisposeProvider<DebugConfig>.internal(
  debugConfig,
  name: r'debugConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$debugConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DebugConfigRef = AutoDisposeProviderRef<DebugConfig>;
String _$startupConfigHash() => r'8f6cb3023befd2d7a0d7921d1406387f3ce67a57';

/// Startup configuration provider
///
/// Copied from [startupConfig].
@ProviderFor(startupConfig)
final startupConfigProvider = AutoDisposeProvider<StartupConfig>.internal(
  startupConfig,
  name: r'startupConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$startupConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StartupConfigRef = AutoDisposeProviderRef<StartupConfig>;
String _$developmentConfigHash() => r'43621dbf5a91953d7c00e8b01c1964d57b759192';

/// Development configuration provider
///
/// Copied from [developmentConfig].
@ProviderFor(developmentConfig)
final developmentConfigProvider =
    AutoDisposeProvider<DevelopmentConfig>.internal(
      developmentConfig,
      name: r'developmentConfigProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$developmentConfigHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DevelopmentConfigRef = AutoDisposeProviderRef<DevelopmentConfig>;
String _$availableConfigsHash() => r'031e9449677f512b9994882bf553c928c920b7c1';

/// Provider for list of available configuration files (development)
///
/// Copied from [availableConfigs].
@ProviderFor(availableConfigs)
final availableConfigsProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      availableConfigs,
      name: r'availableConfigsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$availableConfigsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableConfigsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$commandLineArgsHash() => r'40e2cadf2d88403ac8d6ad787b14b7bdaafc4aaf';

/// Command-line arguments provider
/// Set when application starts
///
/// Copied from [CommandLineArgs].
@ProviderFor(CommandLineArgs)
final commandLineArgsProvider =
    NotifierProvider<CommandLineArgs, List<String>>.internal(
      CommandLineArgs.new,
      name: r'commandLineArgsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$commandLineArgsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CommandLineArgs = Notifier<List<String>>;
String _$appConfigNotifierHash() => r'abc7f8d2075b6df559effc5b532bcb8ce10b7400';

/// Application configuration provider
///
/// Copied from [AppConfigNotifier].
@ProviderFor(AppConfigNotifier)
final appConfigNotifierProvider =
    AsyncNotifierProvider<AppConfigNotifier, AppConfig>.internal(
      AppConfigNotifier.new,
      name: r'appConfigNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$appConfigNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppConfigNotifier = AsyncNotifier<AppConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
