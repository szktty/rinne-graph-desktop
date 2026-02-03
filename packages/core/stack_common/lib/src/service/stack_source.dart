import 'dart:io';

import '../model.dart';
import 'asset_stack_metadata_service.dart';
import 'stack_metadata_service.dart';

/// Abstract interface for stack data sources
/// Unified interface to support both file system and assets
abstract class StackSource {
  /// Stack identifier (path or asset key)
  String get identifier;

  /// Stack display name
  String get displayName;

  /// Whether the stack is asset-based
  bool get isAssetBased;

  /// Loads stack metadata
  Future<(StackInfo?, StackSettings?)> loadMetadata();

  /// Gets the stack's virtual directory (only for file system based)
  Directory? get directory;
}

/// File system based stack source
class FileSystemStackSource implements StackSource {
  FileSystemStackSource(this._directory);
  final Directory _directory;

  @override
  String get identifier => _directory.path;

  @override
  String get displayName =>
      _directory.path.split('/').last.replaceAll('.stack', '');

  @override
  bool get isAssetBased => false;

  @override
  Directory? get directory => _directory;

  @override
  Future<(StackInfo?, StackSettings?)> loadMetadata() async {
    // Use existing StackMetadataService implementation
    final metadataService = StackMetadataService();
    return metadataService.loadMetadata(_directory);
  }
}

/// Asset-based stack source
class AssetStackSource implements StackSource {
  AssetStackSource(this._assetPath, this._displayName);
  final String _assetPath;
  final String _displayName;

  @override
  String get identifier => _assetPath;

  @override
  String get displayName => _displayName;

  @override
  bool get isAssetBased => true;

  @override
  Directory? get directory => null;

  @override
  Future<(StackInfo?, StackSettings?)> loadMetadata() async {
    // Implementation to load metadata from assets
    final metadataService = AssetStackMetadataService();
    return metadataService.loadMetadata(_assetPath);
  }
}
