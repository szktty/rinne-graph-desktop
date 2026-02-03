import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/app_config.dart';
import '../services/app_config_loader.dart';

part 'app_config_providers.g.dart';

/// Command-line arguments provider
/// Set when application starts
@Riverpod(keepAlive: true)
class CommandLineArgs extends _$CommandLineArgs {
  @override
  List<String> build() {
    // Default is empty list
    // Actual arguments are set in main function
    return [];
  }

  /// Set command-line arguments
  void setArgs(List<String> args) {
    state = args;
  }
}

/// Application configuration provider
@Riverpod(keepAlive: true)
class AppConfigNotifier extends _$AppConfigNotifier {
  @override
  Future<AppConfig> build() async {
    final args = ref.watch(commandLineArgsProvider);
    return await AppConfigLoader.loadConfig(args);
  }

  /// Reload configuration
  Future<void> reload() async {
    final args = ref.read(commandLineArgsProvider);
    state = const AsyncValue.loading();
    try {
      final config = await AppConfigLoader.loadConfig(args);
      state = AsyncValue.data(config);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for getting current application configuration
@riverpod
AppConfig appConfig(AppConfigRef ref) {
  final asyncConfig = ref.watch(appConfigNotifierProvider);
  return asyncConfig.valueOrNull ?? const AppConfig();
}

/// Debug configuration provider
@riverpod
DebugConfig debugConfig(DebugConfigRef ref) {
  final config = ref.watch(appConfigProvider);
  return config.debug;
}

/// Startup configuration provider
@riverpod
StartupConfig startupConfig(StartupConfigRef ref) {
  final config = ref.watch(appConfigProvider);
  return config.startup;
}

/// Development configuration provider
@riverpod
DevelopmentConfig developmentConfig(DevelopmentConfigRef ref) {
  final config = ref.watch(appConfigProvider);
  return config.development;
}

/// Provider for list of available configuration files (development)
@riverpod
Future<List<String>> availableConfigs(AvailableConfigsRef ref) async {
  return await AppConfigLoader.getAvailableConfigs();
}
