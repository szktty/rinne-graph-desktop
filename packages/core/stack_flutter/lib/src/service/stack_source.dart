/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';

import 'package:core_samples/core_samples.dart';
import 'package:core_stack_common/core_stack_common.dart';

/// Abstract interface for stack data sources
/// Unified interface to support both file system and assets
abstract class StackSource {
  /// Stack identifier (path or asset key)
  String get identifier;

  /// Display name of the stack
  String get displayName;

  /// Whether the stack is asset-based
  bool get isAssetBased;

  /// Loads stack metadata
  Future<(StackInfo?, StackSettings?)> loadMetadata();

  /// Gets the virtual directory of the stack (only for file system based)
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

/// Manifest-based asset stack template source (for stack exchange format)
///
/// This class is a source for generating stacks from asset templates
/// that have manifest files in the stack exchange format.
class ManifestBasedAssetStackTemplateSource implements StackSource {
  ManifestBasedAssetStackTemplateSource(this._assetPath, this._displayName);
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
    // Load metadata from manifest file
    try {
      final manifestInstaller = StackTemplateInstaller();
      final manifestMetadata = await manifestInstaller.getManifestMetadata(
        _assetPath,
      );

      if (manifestMetadata == null) {
        return (null, null);
      }

      // Generate StackInfo from manifest metadata
      final stackInfo = StackInfo(
        name: manifestMetadata['name'] as String? ?? _displayName,
        description: manifestMetadata['description'] as String? ?? '',
        author: manifestMetadata['author'] as String? ?? 'Unknown',
        version: manifestMetadata['version'] as String? ?? '1.0.0',
        createdAt:
            DateTime.tryParse(
              manifestMetadata['created_at'] as String? ?? '',
            ) ??
            DateTime.now(),
        lastModifiedAt: DateTime.now(),
        tags:
            (manifestMetadata['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      );

      // Generate default StackSettings
      const stackSettings = StackSettings();

      return (stackInfo, stackSettings);
    } catch (e) {
      print('[ManifestBasedAssetStackSource] Error loading metadata: $e');
      return (null, null);
    }
  }
}
