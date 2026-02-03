import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_app_config/core_app_config.dart';

part 'debug_providers.g.dart';

/// Provider that manages the state of debug mode.
///
/// Controls the debug features of the entire application.
/// Typically disabled in production, enabled only in development and test environments.
@riverpod
class DebugMode extends _$DebugMode {
  @override
  bool build() {
    // Get debug mode settings from config file
    final debugConfig = ref.watch(debugConfigProvider);

    // If forced by config file, use that setting
    if (debugConfig.forceDebugMode != null) {
      return debugConfig.forceDebugMode!;
    }

    // Default is disabled in release builds, enabled in debug builds
    return kDebugMode;
  }

  /// Sets debug mode.
  void setDebugMode(bool enabled) {
    state = enabled;
    debugPrint('Debug mode is ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Toggles debug mode.
  void toggle() {
    setDebugMode(!state);
  }
}

/// Provider that manages the state of debug logging.
///
/// Controls the output of debug logs.
/// If debug mode is disabled, logs will not be output regardless of this flag.
@riverpod
class DebugLogging extends _$DebugLogging {
  @override
  bool build() {
    // Monitor debug mode state
    final debugMode = ref.watch(debugModeProvider);

    // If debug mode is disabled, force disable
    if (!debugMode) {
      return false;
    }

    // Get debug logging settings from config file
    final debugConfig = ref.watch(debugConfigProvider);

    // If explicitly specified in config file, use that setting
    if (debugConfig.enableDebugLogging != null) {
      return debugConfig.enableDebugLogging!;
    }

    // Default is enabled in debug builds
    return kDebugMode;
  }

  /// Sets debug logging.
  void setDebugLogging(bool enabled) {
    final debugMode = ref.read(debugModeProvider);

    // If debug mode is disabled, ignore setting
    if (!debugMode) {
      debugPrint('Cannot enable debug logging because debug mode is disabled');
      return;
    }

    state = enabled;
    debugPrint('Debug logging is ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Toggles debug logging.
  void toggle() {
    setDebugLogging(!state);
  }
}

/// Provider that determines if debug features are available.
///
/// Returns true if it's a debug build or debug mode is explicitly enabled.
@riverpod
bool debugAvailable(Ref ref) {
  final debugMode = ref.watch(debugModeProvider);
  return kDebugMode || debugMode;
}

/// Provider that determines if debug logs are enabled.
///
/// Returns true if debug features are available and debug logging is enabled.
@riverpod
bool debugLogEnabled(Ref ref) {
  final debugAvailable = ref.watch(debugAvailableProvider);
  final debugLogging = ref.watch(debugLoggingProvider);
  return debugAvailable && debugLogging;
}
