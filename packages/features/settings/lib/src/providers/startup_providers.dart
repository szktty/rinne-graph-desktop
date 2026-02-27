/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_settings/core_settings.dart';
import 'package:core_app_config/core_app_config.dart' as core_app_config;

part 'startup_providers.freezed.dart';
part 'startup_providers.g.dart';

/// Startup settings.
@freezed
abstract class StartupSettings with _$StartupSettings {
  const factory StartupSettings({
    /// Whether to automatically open the last opened stack on startup.
    @Default(false) bool autoOpenLastStack,

    /// Path of the last opened stack.
    String? lastOpenedStackPath,

    /// Behavior when stack is not found.
    @Default(StartupErrorBehavior.showWelcome)
    StartupErrorBehavior errorBehavior,

    /// Whether it is the first launch of the app.
    @Default(true) bool isFirstLaunch,

    /// Whether to enable sample stack auto-generation.
    @Default(true) bool enableSampleStackAutoGeneration,
  }) = _StartupSettings;

  factory StartupSettings.fromJson(Map<String, dynamic> json) =>
      _$StartupSettingsFromJson(json);
}

/// Behavior when stack is not found.
enum StartupErrorBehavior {
  /// Show welcome screen.
  showWelcome,

  /// Show error dialog.
  showError,

  /// Open last successful stack.
  openLastSuccessful,
}

/// Startup settings provider.
@Riverpod(keepAlive: true)
class StartupSettingsNotifier extends _$StartupSettingsNotifier {
  static const _settingsKey = 'startup';

  @override
  Future<StartupSettings> build() async {
    final storage = ref.watch(settingsStorageServiceProvider);
    final json = await storage.load(_settingsKey);

    // Get default values from config file
    final startupConfig = ref.watch(core_app_config.startupConfigProvider);

    // Convert enum from config file to existing enum
    StartupErrorBehavior convertErrorBehavior(
      core_app_config.StartupErrorBehavior? behavior,
    ) {
      switch (behavior) {
        case core_app_config.StartupErrorBehavior.showWelcome:
          return StartupErrorBehavior.showWelcome;
        case core_app_config.StartupErrorBehavior.showError:
          return StartupErrorBehavior.showError;
        case core_app_config.StartupErrorBehavior.openLastSuccessful:
          return StartupErrorBehavior.openLastSuccessful;
        case null:
          return StartupErrorBehavior.showWelcome;
      }
    }

    StartupSettings defaultSettings = StartupSettings(
      autoOpenLastStack: startupConfig.autoOpenLastStack ?? false,
      lastOpenedStackPath: startupConfig.lastOpenedStackPath,
      errorBehavior: convertErrorBehavior(startupConfig.errorBehavior),
      isFirstLaunch: startupConfig.isFirstLaunch ?? true,
      enableSampleStackAutoGeneration:
          startupConfig.enableSampleStackAutoGeneration ?? true,
    );

    if (json != null) {
      try {
        final loadedSettings = StartupSettings.fromJson(json);
        // 設定ファイルで指定されていない項目はデフォルト値を使用
        return StartupSettings(
          autoOpenLastStack: loadedSettings.autoOpenLastStack,
          lastOpenedStackPath: loadedSettings.lastOpenedStackPath,
          errorBehavior: loadedSettings.errorBehavior,
          isFirstLaunch: loadedSettings.isFirstLaunch,
          enableSampleStackAutoGeneration:
              loadedSettings.enableSampleStackAutoGeneration,
        );
      } catch (e) {
        // Use default values if settings fail to load
      }
    }

    return defaultSettings;
  }

  /// Updates startup settings.
  Future<void> updateSettings(StartupSettings settings) async {
    state = AsyncData(settings);

    final storage = ref.read(settingsStorageServiceProvider);
    await storage.save(_settingsKey, settings.toJson());
  }

  /// Path of the last opened stack.を記録
  Future<void> updateLastOpenedStack(String? path) async {
    final current = state.value ?? const StartupSettings();
    await updateSettings(current.copyWith(lastOpenedStackPath: path));
  }

  /// Toggles auto-startup on/off.
  Future<void> toggleAutoOpen(bool enabled) async {
    final current = state.value ?? const StartupSettings();
    await updateSettings(current.copyWith(autoOpenLastStack: enabled));
  }

  /// Updates first launch flag (set to false when first launch is complete).
  Future<void> markFirstLaunchComplete() async {
    final current = state.value ?? const StartupSettings();
    await updateSettings(current.copyWith(isFirstLaunch: false));
  }

  /// Toggles sample stack auto-generation flag.
  Future<void> toggleSampleStackAutoGeneration(bool enabled) async {
    final current = state.value ?? const StartupSettings();
    await updateSettings(
      current.copyWith(enableSampleStackAutoGeneration: enabled),
    );
  }
}

/// Startup settings sync provider (returns default if async not yet loaded).
@Riverpod(keepAlive: true)
StartupSettings startupSettingsSync(Ref ref) {
  return ref.watch(startupSettingsProvider).value ?? const StartupSettings();
}
