/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

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

/// Debug configuration provider
@riverpod
DebugConfig debugConfig(Ref ref) {
  final config = ref.watch(appConfigProvider).value ?? const AppConfig();
  return config.debug;
}

/// Startup configuration provider
@riverpod
StartupConfig startupConfig(Ref ref) {
  final config = ref.watch(appConfigProvider).value ?? const AppConfig();
  return config.startup;
}

/// Development configuration provider
@riverpod
DevelopmentConfig developmentConfig(Ref ref) {
  final config = ref.watch(appConfigProvider).value ?? const AppConfig();
  return config.development;
}

/// Provider for list of available configuration files (development)
@riverpod
Future<List<String>> availableConfigs(Ref ref) async {
  return await AppConfigLoader.getAvailableConfigs();
}
