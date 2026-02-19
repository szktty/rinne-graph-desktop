import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';

/// Settings file storage directory name
const String _settingsDirName = 'settings';

/// Settings file extension
const String _settingsFileExtension = '.json';

/// Service class that abstracts access to settings storage
/// Settings are stored directly in the file system
class SettingsStorageService {
  static final SettingsStorageService _instance =
      SettingsStorageService._internal();

  factory SettingsStorageService() {
    return _instance;
  }

  SettingsStorageService._internal();

  /// File system service
  final _fileSystemService = FileSystemService();

  /// Get settings directory path
  Future<String> _getSettingsDirectoryPath() async {
    final appDocDir =
        await _fileSystemService.getApplicationDocumentsDirectory();
    final settingsDirPath = '${appDocDir.path}/$_settingsDirName';

    // Create directory if it doesn't exist
    final settingsDir = await _fileSystemService.ensureDirectoryExists(
      settingsDirPath,
    );

    return settingsDir.path;
  }

  /// Get settings file path
  Future<String> _getSettingsFilePath(String key) async {
    final dirPath = await _getSettingsDirectoryPath();
    return '$dirPath/$key$_settingsFileExtension';
  }

  /// Save string
  Future<bool> setString(String key, String value) async {
    try {
      final filePath = await _getSettingsFilePath(key);
      return await _fileSystemService.writeStringToFile(filePath, value);
    } catch (e) {
      debugPrint('SettingsStorageService.setString error: $e');
      return false;
    }
  }

  /// Get string
  Future<String?> getString(String key) async {
    debugPrint('getString: key=$key');
    try {
      final filePath = await _getSettingsFilePath(key);
      return await _fileSystemService.readStringFromFile(filePath);
    } catch (e) {
      debugPrint('SettingsStorageService.getString error: $e');
      return null;
    }
  }

  /// Save integer
  Future<bool> setInt(String key, int value) async {
    return setString(key, value.toString());
  }

  /// Get integer
  Future<int?> getInt(String key) async {
    final value = await getString(key);
    if (value == null) return null;

    try {
      return int.parse(value);
    } catch (e) {
      debugPrint('SettingsStorageService.getInt parse error: $e');
      return null;
    }
  }

  /// Save boolean
  Future<bool> setBool(String key, bool value) async {
    return setString(key, value.toString());
  }

  /// Get boolean
  Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;

    try {
      return value.toLowerCase() == 'true';
    } catch (e) {
      debugPrint('SettingsStorageService.getBool parse error: $e');
      return null;
    }
  }

  /// Save double
  Future<bool> setDouble(String key, double value) async {
    return setString(key, value.toString());
  }

  /// Get double
  Future<double?> getDouble(String key) async {
    final value = await getString(key);
    if (value == null) return null;

    try {
      return double.parse(value);
    } catch (e) {
      debugPrint('SettingsStorageService.getDouble parse error: $e');
      return null;
    }
  }

  /// Save string list
  Future<bool> setStringList(String key, List<String> value) async {
    return setString(key, jsonEncode(value));
  }

  /// Get string list
  Future<List<String>?> getStringList(String key) async {
    final value = await getString(key);
    if (value == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(value);
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint('SettingsStorageService.getStringList parse error: $e');
      return null;
    }
  }

  /// Save object (JSON format)
  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    return setString(key, jsonEncode(value));
  }

  /// Get object (JSON format)
  Future<Map<String, dynamic>?> getObject(String key) async {
    final value = await getString(key);
    if (value == null) return null;

    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('SettingsStorageService.getObject parse error: $e');
      return null;
    }
  }

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      final filePath = await _getSettingsFilePath(key);
      return await _fileSystemService.deleteFile(filePath);
    } catch (e) {
      debugPrint('SettingsStorageService.remove error: $e');
      return false;
    }
  }

  /// Remove all keys
  Future<bool> clear() async {
    try {
      final dirPath = await _getSettingsDirectoryPath();
      // Delete and recreate directory
      final deleted = await _fileSystemService.deleteDirectory(dirPath);
      if (deleted) {
        await _fileSystemService.ensureDirectoryExists(dirPath);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('SettingsStorageService.clear error: $e');
      return false;
    }
  }

  /// Load JSON data (generic method)
  Future<Map<String, dynamic>?> load(String key) async {
    return await getObject(key);
  }

  /// Save JSON data (generic method)
  Future<bool> save(String key, Map<String, dynamic> value) async {
    return await setObject(key, value);
  }
}
