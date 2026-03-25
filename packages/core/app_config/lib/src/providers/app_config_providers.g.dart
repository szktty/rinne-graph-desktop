// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Command-line arguments provider
/// Set when application starts

@ProviderFor(CommandLineArgs)
final commandLineArgsProvider = CommandLineArgsProvider._();

/// Command-line arguments provider
/// Set when application starts
final class CommandLineArgsProvider
    extends $NotifierProvider<CommandLineArgs, List<String>> {
  /// Command-line arguments provider
  /// Set when application starts
  CommandLineArgsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandLineArgsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandLineArgsHash();

  @$internal
  @override
  CommandLineArgs create() => CommandLineArgs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$commandLineArgsHash() => r'40e2cadf2d88403ac8d6ad787b14b7bdaafc4aaf';

/// Command-line arguments provider
/// Set when application starts

abstract class _$CommandLineArgs extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Application configuration provider

@ProviderFor(AppConfigNotifier)
final appConfigProvider = AppConfigNotifierProvider._();

/// Application configuration provider
final class AppConfigNotifierProvider
    extends $AsyncNotifierProvider<AppConfigNotifier, AppConfig> {
  /// Application configuration provider
  AppConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigNotifierHash();

  @$internal
  @override
  AppConfigNotifier create() => AppConfigNotifier();
}

String _$appConfigNotifierHash() => r'abc7f8d2075b6df559effc5b532bcb8ce10b7400';

/// Application configuration provider

abstract class _$AppConfigNotifier extends $AsyncNotifier<AppConfig> {
  FutureOr<AppConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppConfig>, AppConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppConfig>, AppConfig>,
              AsyncValue<AppConfig>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Debug configuration provider

@ProviderFor(debugConfig)
final debugConfigProvider = DebugConfigProvider._();

/// Debug configuration provider

final class DebugConfigProvider
    extends $FunctionalProvider<DebugConfig, DebugConfig, DebugConfig>
    with $Provider<DebugConfig> {
  /// Debug configuration provider
  DebugConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debugConfigHash();

  @$internal
  @override
  $ProviderElement<DebugConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DebugConfig create(Ref ref) {
    return debugConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebugConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebugConfig>(value),
    );
  }
}

String _$debugConfigHash() => r'9e4590a002155eba3855c3693060faf14d3bfe63';

/// Startup configuration provider

@ProviderFor(startupConfig)
final startupConfigProvider = StartupConfigProvider._();

/// Startup configuration provider

final class StartupConfigProvider
    extends $FunctionalProvider<StartupConfig, StartupConfig, StartupConfig>
    with $Provider<StartupConfig> {
  /// Startup configuration provider
  StartupConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupConfigHash();

  @$internal
  @override
  $ProviderElement<StartupConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StartupConfig create(Ref ref) {
    return startupConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartupConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartupConfig>(value),
    );
  }
}

String _$startupConfigHash() => r'ab0f3f28b9bc19c3b61d80db934ce5cc69f6a772';

/// Development configuration provider

@ProviderFor(developmentConfig)
final developmentConfigProvider = DevelopmentConfigProvider._();

/// Development configuration provider

final class DevelopmentConfigProvider
    extends
        $FunctionalProvider<
          DevelopmentConfig,
          DevelopmentConfig,
          DevelopmentConfig
        >
    with $Provider<DevelopmentConfig> {
  /// Development configuration provider
  DevelopmentConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'developmentConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$developmentConfigHash();

  @$internal
  @override
  $ProviderElement<DevelopmentConfig> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DevelopmentConfig create(Ref ref) {
    return developmentConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevelopmentConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevelopmentConfig>(value),
    );
  }
}

String _$developmentConfigHash() => r'70737929a2a986abe77685ddc56b8222bc5fcb6a';

/// Provider for list of available configuration files (development)

@ProviderFor(availableConfigs)
final availableConfigsProvider = AvailableConfigsProvider._();

/// Provider for list of available configuration files (development)

final class AvailableConfigsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Provider for list of available configuration files (development)
  AvailableConfigsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableConfigsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableConfigsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return availableConfigs(ref);
  }
}

String _$availableConfigsHash() => r'a3cbddb0e93065ec40658d2120214e588baa0308';
