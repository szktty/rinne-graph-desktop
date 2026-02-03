import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/app_config.dart';

/// Application configuration loader
class AppConfigLoader {
  static const String _configsPath = 'assets/configs';
  static const String _defaultConfigName = 'default';

  /// Get configuration name from command-line arguments
  static String? _getConfigFromArgs(List<String> args) {
    for (int i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg.startsWith('--config=')) {
        return arg.substring('--config='.length);
      }
      if (arg == '--config' && i + 1 < args.length) {
        return args[i + 1];
      }
    }
    return null;
  }

  /// Get configuration name from environment variable
  static String? _getConfigFromEnvironment() {
    return Platform.environment['APP_CONFIG'];
  }

  /// Determine configuration name (priority: command-line > environment > default)
  static String _determineConfigName(List<String> args) {
    return _getConfigFromArgs(args) ??
        _getConfigFromEnvironment() ??
        _defaultConfigName;
  }

  /// Load configuration file
  static Future<AppConfig> loadConfig(List<String> args) async {
    final configName = _determineConfigName(args);

    try {
      // Load configuration file from assets
      final configPath = '$_configsPath/$configName.json';
      final configString = await rootBundle.loadString(configPath);
      final configJson = json.decode(configString) as Map<String, dynamic>;

      final config = AppConfig.fromJson(configJson);

      debugPrint('Configuration file loaded successfully: $configName');
      debugPrint('Configuration: ${config.toString()}');

      return config;
    } catch (e) {
      debugPrint('Configuration file loading error ($configName): $e');

      // Fallback: try default configuration
      if (configName != _defaultConfigName) {
        try {
          final defaultPath = '$_configsPath/$_defaultConfigName.json';
          final defaultString = await rootBundle.loadString(defaultPath);
          final defaultJson =
              json.decode(defaultString) as Map<String, dynamic>;

          final defaultConfig = AppConfig.fromJson(defaultJson);
          debugPrint('Default configuration file loaded successfully');

          return defaultConfig;
        } catch (defaultError) {
          debugPrint('Default configuration file loading error: $defaultError');
        }
      }

      // Final fallback: use hardcoded default configuration
      debugPrint('Using hardcoded default configuration');
      return const AppConfig();
    }
  }

  /// Get list of available configuration files (development)
  static Future<List<String>> getAvailableConfigs() async {
    try {
      // Get list of configuration files from asset manifest
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final configFiles = <String>[];
      for (final key in manifestMap.keys) {
        if (key.startsWith('$_configsPath/') && key.endsWith('.json')) {
          final fileName = key.substring('$_configsPath/'.length);
          final configName = fileName.substring(
            0,
            fileName.length - '.json'.length,
          );
          configFiles.add(configName);
        }
      }

      return configFiles;
    } catch (e) {
      debugPrint('Error getting configuration file list: $e');
      return [_defaultConfigName];
    }
  }
}
