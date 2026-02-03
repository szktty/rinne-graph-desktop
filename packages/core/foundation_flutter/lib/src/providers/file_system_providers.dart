import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../filesystem/file_system_service.dart';

part 'file_system_providers.g.dart';

/// Provider that provides a FileSystemService instance
@riverpod
FileSystemService fileSystemService(FileSystemServiceRef ref) {
  return FileSystemService();
}

/// Provider that provides the application's documents directory
@riverpod
Future<Directory> documentsDirectory(DocumentsDirectoryRef ref) async {
  final service = ref.watch(fileSystemServiceProvider);
  return await service.getApplicationDocumentsDirectory();
}

/// Provider that provides the application's support directory
@riverpod
Future<Directory> supportDirectory(SupportDirectoryRef ref) async {
  final service = ref.watch(fileSystemServiceProvider);
  return await service.getApplicationSupportDirectory();
}

/// Provider that provides the application's temporary directory
@riverpod
Future<Directory> temporaryDirectory(TemporaryDirectoryRef ref) async {
  final service = ref.watch(fileSystemServiceProvider);
  return await service.getTemporaryDirectory();
}

/// Provider that provides file system operations
@riverpod
FileSystemOperations fileSystemOperations(FileSystemOperationsRef ref) {
  final service = ref.watch(fileSystemServiceProvider);
  return FileSystemOperations(service);
}

/// Class that manages file system operations
class FileSystemOperations {
  final FileSystemService _service;

  FileSystemOperations(this._service);

  /// Reads a string from a file
  Future<String?> readString(String filePath) =>
      _service.readStringFromFile(filePath);

  /// Writes a string to a file
  Future<bool> writeString(String filePath, String content) =>
      _service.writeStringToFile(filePath, content);

  /// Deletes a file
  Future<bool> deleteFile(String filePath) => _service.deleteFile(filePath);

  /// Deletes a directory
  Future<bool> deleteDirectory(String dirPath) =>
      _service.deleteDirectory(dirPath);

  /// Checks if a file exists
  Future<bool> fileExists(String filePath) => _service.fileExists(filePath);

  /// Ensures a directory exists
  Future<Directory> ensureDirectoryExists(String dirPath) =>
      _service.ensureDirectoryExists(dirPath);

  /// Lists files
  Future<List<String>> listFiles(String dirPath) => _service.listFiles(dirPath);

  /// Lists only files
  Future<List<String>> listFilesOnly(String dirPath) =>
      _service.listFilesOnly(dirPath);

  /// Lists only directories
  Future<List<String>> listDirectoriesOnly(String dirPath) =>
      _service.listDirectoriesOnly(dirPath);
}
