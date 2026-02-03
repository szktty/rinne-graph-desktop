import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

/// Application-wide configuration
@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    /// Configuration name (for identification)
    @Default('default') String name,

    /// Configuration description
    String? description,

    /// Debug-related configuration
    @Default(DebugConfig()) DebugConfig debug,

    /// Startup configuration
    @Default(StartupConfig()) StartupConfig startup,

    /// Development configuration
    @Default(DevelopmentConfig()) DevelopmentConfig development,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}

/// Debug-related configuration
@freezed
class DebugConfig with _$DebugConfig {
  const factory DebugConfig({
    /// Whether to force enable debug mode
    @Default(null) bool? forceDebugMode,

    /// Whether to enable debug logging
    @Default(null) bool? enableDebugLogging,

    /// Whether to enable screenshot server
    @Default(false) bool enableScreenshotServer,

    /// Whether to enable verbose logging
    @Default(false) bool enableVerboseLogging,
  }) = _DebugConfig;

  factory DebugConfig.fromJson(Map<String, dynamic> json) =>
      _$DebugConfigFromJson(json);
}

/// Startup configuration
@freezed
class StartupConfig with _$StartupConfig {
  const factory StartupConfig({
    /// Whether to automatically open the last opened stack on startup
    @Default(null) bool? autoOpenLastStack,

    /// Path of the last opened stack (usually null in config file)
    @Default(null) String? lastOpenedStackPath,

    /// Behavior when stack is not found
    @Default(null) StartupErrorBehavior? errorBehavior,

    /// Whether this is the first launch of the app (usually null in config file)
    @Default(null) bool? isFirstLaunch,

    /// Whether to enable sample stack auto-generation
    @Default(null) bool? enableSampleStackAutoGeneration,

    /// Whether to enable development stacks
    @Default(false) bool enableDevStacks,
  }) = _StartupConfig;

  factory StartupConfig.fromJson(Map<String, dynamic> json) =>
      _$StartupConfigFromJson(json);
}

/// Behavior when stack is not found
enum StartupErrorBehavior {
  /// Show welcome screen
  @JsonValue('showWelcome')
  showWelcome,

  /// Show error dialog
  @JsonValue('showError')
  showError,

  /// Open last successful stack
  @JsonValue('openLastSuccessful')
  openLastSuccessful,
}

/// Development configuration
@freezed
class DevelopmentConfig with _$DevelopmentConfig {
  const factory DevelopmentConfig({
    /// Whether to perform full reset of all settings
    @Default(false) bool resetAllSettings,

    /// Whether to perform full reset of database
    @Default(false) bool resetDatabase,

    /// Whether to auto-generate test data
    @Default(false) bool generateTestData,

    /// Whether to enable UI development mode
    @Default(false) bool enableUiDevMode,
  }) = _DevelopmentConfig;

  factory DevelopmentConfig.fromJson(Map<String, dynamic> json) =>
      _$DevelopmentConfigFromJson(json);
}
