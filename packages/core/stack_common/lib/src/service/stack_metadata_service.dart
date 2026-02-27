/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import '../model.dart';
import 'package:path/path.dart' as p;

/// Service for loading stack metadata (`info.json`, `settings.json`)
class StackMetadataService {
  /// Asynchronously loads metadata from the stack directory.
  ///
  /// [stackDir] The stack directory (`.stack`) from which to load metadata.
  ///
  /// Returns `(StackInfo?, StackSettings?)` if loading is successful.
  /// If `info.json` or `settings.json` does not exist, or
  /// if the JSON format is invalid, the corresponding value will be `null`.
  /// I/O errors such as the directory itself not existing may throw an exception.
  Future<(StackInfo?, StackSettings?)> loadMetadata(Directory stackDir) async {
    print(
      '[StackMetadataService.loadMetadata] Start loading metadata for ${stackDir.path}',
    );

    final infoFile = File(p.join(stackDir.path, 'meta', 'info.json'));
    final settingsFile = File(p.join(stackDir.path, 'meta', 'settings.json'));

    StackInfo? stackInfo;
    StackSettings? stackSettings;

    // Load info.json
    if (await infoFile.exists()) {
      try {
        final content = await infoFile.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        stackInfo = StackInfo.fromJson(json);
        print(
          '[StackMetadataService.loadMetadata] Successfully loaded info.json for ${stackDir.path}',
        );
      } catch (e, stackTrace) {
        print(
          '[StackMetadataService.loadMetadata] Error loading/parsing info.json for ${stackDir.path}: $e',
        );
        print(stackTrace);
        stackInfo = null;
      }
    } else {
      print(
        '[StackMetadataService.loadMetadata] info.json not found in ${stackDir.path}',
      );
      stackInfo = null;
    }

    // Load settings.json
    if (await settingsFile.exists()) {
      try {
        final content = await settingsFile.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        stackSettings = StackSettings.fromJson(json);
        print(
          '[StackMetadataService.loadMetadata] Successfully loaded settings.json for ${stackDir.path}',
        );
      } catch (e, stackTrace) {
        print(
          '[StackMetadataService.loadMetadata] Error loading/parsing settings.json for ${stackDir.path}: $e',
        );
        print(stackTrace);
        stackSettings = null;
      }
    } else {
      print(
        '[StackMetadataService.loadMetadata] settings.json not found in ${stackDir.path}',
      );
      stackSettings = null;
    }

    print(
      '[StackMetadataService.loadMetadata] Finished loading metadata for ${stackDir.path}. Info: ${stackInfo != null}, Settings: ${stackSettings != null}',
    );
    return (stackInfo, stackSettings);
  }

  /// Searches for the stack's thumbnail image file
  ///
  /// [stackDir] The stack directory (`.stack`) in which to search for the thumbnail image.
  /// [thumbnailFileName] The file name of the thumbnail image to search for.
  ///
  /// Returns: The File object if the thumbnail image file exists, otherwise null.
  Future<File?> findThumbnailFile(
    Directory stackDir,
    String? thumbnailFileName,
  ) async {
    if (thumbnailFileName == null || thumbnailFileName.isEmpty) {
      return null;
    }

    final metaDir = Directory(p.join(stackDir.path, 'meta'));
    if (!await metaDir.exists()) {
      return null;
    }

    final thumbnailFile = File(p.join(metaDir.path, thumbnailFileName));
    if (await thumbnailFile.exists()) {
      return thumbnailFile;
    }

    return null;
  }

  /// Saves the stack's thumbnail image file path
  Future<String?> getThumbnailFilePath(
    Directory stackDir,
    String? thumbnailFileName,
  ) async {
    final thumbnailFile = await findThumbnailFile(stackDir, thumbnailFileName);
    return thumbnailFile?.path;
  }

  /// Asynchronously saves metadata to the stack directory.
  ///
  /// [stackDir] The stack directory (`.stack`) where metadata will be saved.
  /// [info] The StackInfo object to save to `info.json`.
  /// [settings] The StackSettings object to save to `settings.json`.
  Future<void> saveMetadata(
    Directory stackDir,
    StackInfo info,
    StackSettings settings,
  ) async {
    await saveStackInfo(stackDir, info);
    await saveStackSettings(stackDir, settings);
  }

  /// Asynchronously saves StackInfo to `info.json`.
  ///
  /// [stackDir] The stack directory (`.stack`).
  /// [info] The StackInfo object to save.
  Future<void> saveStackInfo(Directory stackDir, StackInfo info) async {
    print(
      '[StackMetadataService.saveStackInfo] Start saving info.json for ${stackDir.path}',
    );
    try {
      final metaDir = Directory(p.join(stackDir.path, 'meta'));
      if (!await metaDir.exists()) {
        await metaDir.create(recursive: true);
      }
      final infoFile = File(p.join(metaDir.path, 'info.json'));
      final json = info.toJson();
      const encoder = JsonEncoder.withIndent('  ');
      await infoFile.writeAsString(encoder.convert(json));
      print(
        '[StackMetadataService.saveStackInfo] Successfully saved info.json for ${stackDir.path}',
      );
    } catch (e, stackTrace) {
      print(
        '[StackMetadataService.saveStackInfo] Error saving info.json for ${stackDir.path}: $e',
      );
      print(stackTrace);
      rethrow;
    }
  }

  /// Asynchronously saves StackSettings to `settings.json`.
  ///
  /// [stackDir] The stack directory (`.stack`).
  /// [settings] The StackSettings object to save.
  Future<void> saveStackSettings(
    Directory stackDir,
    StackSettings settings,
  ) async {
    print(
      '[StackMetadataService.saveStackSettings] Start saving settings.json for ${stackDir.path}',
    );
    try {
      final metaDir = Directory(p.join(stackDir.path, 'meta'));
      if (!await metaDir.exists()) {
        await metaDir.create(recursive: true);
      }
      final settingsFile = File(p.join(metaDir.path, 'settings.json'));
      final json = settings.toJson();
      const encoder = JsonEncoder.withIndent('  ');
      await settingsFile.writeAsString(encoder.convert(json));
      print(
        '[StackMetadataService.saveStackSettings] Successfully saved settings.json for ${stackDir.path}',
      );
    } catch (e, stackTrace) {
      print(
        '[StackMetadataService.saveStackSettings] Error saving settings.json for ${stackDir.path}: $e',
      );
      print(stackTrace);
      rethrow;
    }
  }
}
