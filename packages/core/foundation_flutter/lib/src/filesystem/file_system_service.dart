import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:core_foundation_common/core_foundation_common.dart';
import '../io/flutter_path_provider.dart';

/// File system service used throughout the application.
///
/// This class abstracts file system access for the application,
/// providing a consistent API.
class FileSystemService {
  static final FileSystemService _instance = FileSystemService._internal();
  late final PathProvider _pathProvider;

  factory FileSystemService() {
    return _instance;
  }

  FileSystemService._internal() {
    _pathProvider = FlutterPathProvider();
  }

  /// Retrieves the user-specific directory.
  ///
  /// ユーザーのホームディレクトリ内に作成される、ユーザー固有の各種情報を保存する
  /// created within the user's home directory to store various user-specific information.
  /// - macOS: ~/Documents/RinneGraph
  /// - Windows: %USERPROFILE%\Documents\RinneGraph
  /// - Linux: ~/Documents/RinneGraph
  /// - iOS: ~/Documents/RinneGraph
  /// - Android: /storage/emulated/0/Documents/RinneGraph
  Future<Directory> getUserSpecificDirectory() async {
    return await _pathProvider.getUserSpecificDirectory();
  }

  /// Retrieves the application's documents directory.
  Future<Directory> getApplicationDocumentsDirectory() async {
    return await _pathProvider.getApplicationDocumentsDirectory();
  }

  /// Retrieves the application's support directory.
  Future<Directory> getApplicationSupportDirectory() async {
    return await _pathProvider.getApplicationSupportDirectory();
  }

  /// Retrieves the application's temporary directory.
  Future<Directory> getTemporaryDirectory() async {
    return await _pathProvider.getTemporaryDirectory();
  }

  /// Retrieves the directory for stacks.
  Future<Directory> getStacksDirectory() async {
    return await _pathProvider.getStacksDirectory();
  }

  /// Retrieves the directory for sample stacks.
  Future<Directory> getSamplesDirectory() async {
    return await _pathProvider.getSamplesDirectory();
  }

  /// Reads a string from a file.
  Future<String?> readStringFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      debugPrint('File read error: $e');
      return null;
    }
  }

  /// Writes a string to a file.
  Future<bool> writeStringToFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      debugPrint('File write error: $e');
      return false;
    }
  }

  /// Deletes a file.
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('File delete error: $e');
      return false;
    }
  }

  /// Creates a directory.
  Future<bool> createDirectory(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return true;
    } catch (e) {
      debugPrint('Directory creation error: $e');
      return false;
    }
  }

  /// Initializes user-specific directories.
  Future<bool> initializeUserSpecificDirectories() async {
    try {
      final userDir = await getUserSpecificDirectory();
      final stacksDir = await getStacksDirectory();

      // 必要なディレクトリを作成
      await userDir.create(recursive: true);
      await stacksDir.create(recursive: true);

      debugPrint('✅ Initialized user-specific directory: ${userDir.path}');
      return true;
    } catch (e) {
      debugPrint('❌ User-specific directory initialization error: $e');
      return false;
    }
  }

  /// Retrieves information about user-specific directories.
  Future<Map<String, String>> getUserSpecificDirectoryInfo() async {
    try {
      final userDir = await getUserSpecificDirectory();
      final stacksDir = await getStacksDirectory();
      final documentsDir = await getApplicationDocumentsDirectory();
      final supportDir = await getApplicationSupportDirectory();
      final tempDir = await getTemporaryDirectory();

      return {
        'user': userDir.path,
        'stacks': stacksDir.path,
        'documents': documentsDir.path,
        'support': supportDir.path,
        'temp': tempDir.path,
      };
    } catch (e) {
      debugPrint('Directory information retrieval error: $e');
      return {};
    }
  }

  /// Checks if a file exists.
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      debugPrint('File existence check error: $e');
      return false;
    }
  }

  /// Ensures a directory exists, creating it if it doesn't.
  Future<Directory> ensureDirectoryExists(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Deletes a directory.
  Future<bool> deleteDirectory(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Directory deletion error: $e');
      return false;
    }
  }

  /// Retrieves a list of files within a directory.
  Future<List<String>> listFiles(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) return [];

      final entities = await dir.list().toList();
      return entities.whereType<File>().map((entity) => entity.path).toList();
    } catch (e) {
      debugPrint('File list retrieval error: $e');
      return [];
    }
  }

  /// Retrieves only files within a directory.
  Future<List<String>> listFilesOnly(String dirPath) async {
    return await listFiles(dirPath);
  }

  /// Retrieves only directories within a directory.
  Future<List<String>> listDirectoriesOnly(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) return [];

      final entities = await dir.list().toList();
      return entities
          .whereType<Directory>()
          .map((entity) => entity.path)
          .toList();
    } catch (e) {
      debugPrint('Directory list retrieval error: $e');
      return [];
    }
  }
}
