/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

/// Development stack auto-import service
class DevStackImporter {
  static const String _devStacksPath =
      'tools/rinne-graph-desktop/examples/dev_stacks';
  static const String _registryFileName = 'dev_stack_registry.json';

  /// Check if development stacks should be auto-imported
  static Future<bool> shouldImportDevStacks() async {
    debugPrint(
      'DevStackImporter: Checking if dev stacks should be imported (debug mode: $kDebugMode)',
    );
    if (!kDebugMode) {
      debugPrint('DevStackImporter: Not in debug mode, skipping');
      return false;
    }

    try {
      final projectRoot = await _findProjectRoot();
      debugPrint('DevStackImporter: Project root: ${projectRoot?.path}');
      if (projectRoot == null) {
        debugPrint('DevStackImporter: Project root not found');
        return false;
      }

      final devStacksDir = Directory(
        path.join(projectRoot.path, _devStacksPath),
      );
      final registryFile = File(
        path.join(devStacksDir.path, _registryFileName),
      );

      debugPrint('DevStackImporter: Dev stacks dir: ${devStacksDir.path}');
      debugPrint('DevStackImporter: Registry file: ${registryFile.path}');
      debugPrint('DevStackImporter: Dir exists: ${devStacksDir.existsSync()}');
      debugPrint(
        'DevStackImporter: Registry exists: ${registryFile.existsSync()}',
      );

      final result = devStacksDir.existsSync() && registryFile.existsSync();
      debugPrint('DevStackImporter: Should import: $result');
      return result;
    } catch (e) {
      debugPrint('Error checking dev stacks availability: $e');
      return false;
    }
  }

  /// Import development stacks to user documents directory
  static Future<void> importDevStacks() async {
    if (!kDebugMode) return;

    try {
      final projectRoot = await _findProjectRoot();
      if (projectRoot == null) {
        debugPrint('Could not find project root for dev stack import');
        return;
      }

      final devStacksDir = Directory(
        path.join(projectRoot.path, _devStacksPath),
      );
      if (!devStacksDir.existsSync()) {
        debugPrint('Dev stacks directory not found: ${devStacksDir.path}');
        return;
      }

      final documentsDir = await _getDocumentsDirectory();
      final appDir = Directory(path.join(documentsDir.path, 'App'));
      final devStacksTargetDir = Directory(path.join(appDir.path, 'DevStacks'));

      // Create target directory if it doesn't exist
      if (!devStacksTargetDir.existsSync()) {
        await devStacksTargetDir.create(recursive: true);
      }

      // Read registry file
      final registryFile = File(
        path.join(devStacksDir.path, _registryFileName),
      );
      if (!registryFile.existsSync()) {
        debugPrint('Dev stack registry not found: ${registryFile.path}');
        return;
      }

      final registryContent = await registryFile.readAsString();
      final registryData = jsonDecode(registryContent) as Map<String, dynamic>;
      final devStacks = registryData['dev_stacks'] as List<dynamic>? ?? [];

      debugPrint('Found ${devStacks.length} development stacks to import');

      // Import each stack
      for (final stackData in devStacks) {
        final stackMap = stackData as Map<String, dynamic>;
        final stackId = stackMap['id'] as String;
        final configFile = stackMap['config_file'] as String;

        await _importSingleStack(
          devStacksDir,
          devStacksTargetDir,
          stackId,
          configFile,
        );
      }

      debugPrint('Development stacks imported successfully');
    } catch (e) {
      debugPrint('Error importing development stacks: $e');
    }
  }

  /// Import a single development stack
  static Future<void> _importSingleStack(
    Directory sourceDir,
    Directory targetDir,
    String stackId,
    String configFile,
  ) async {
    try {
      final configPath = path.join(sourceDir.path, configFile);
      final configFileObj = File(configPath);

      if (!configFileObj.existsSync()) {
        debugPrint('Config file not found for stack $stackId: $configPath');
        return;
      }

      // Create stack directory
      final stackTargetDir = Directory(path.join(targetDir.path, stackId));
      if (!stackTargetDir.existsSync()) {
        await stackTargetDir.create(recursive: true);
      }

      // Copy config file
      final targetConfigFile = File(
        path.join(stackTargetDir.path, 'stack.yaml'),
      );
      await configFileObj.copy(targetConfigFile.path);

      // Copy data directory if it exists
      final dataDir = Directory(path.join(sourceDir.path, 'data'));
      if (dataDir.existsSync()) {
        final targetDataDir = Directory(path.join(stackTargetDir.path, 'data'));
        await _copyDirectory(dataDir, targetDataDir);
      }

      debugPrint('Imported development stack: $stackId');
    } catch (e) {
      debugPrint('Error importing stack $stackId: $e');
    }
  }

  /// Copy directory recursively
  static Future<void> _copyDirectory(Directory source, Directory target) async {
    if (!target.existsSync()) {
      await target.create(recursive: true);
    }

    await for (final entity in source.list()) {
      if (entity is File) {
        final targetFile = File(
          path.join(target.path, path.basename(entity.path)),
        );
        await entity.copy(targetFile.path);
      } else if (entity is Directory) {
        final targetSubDir = Directory(
          path.join(target.path, path.basename(entity.path)),
        );
        await _copyDirectory(entity, targetSubDir);
      }
    }
  }

  /// Find project root directory by looking for pubspec.yaml
  static Future<Directory?> _findProjectRoot() async {
    var current = Directory.current;

    // Look for project root by finding pubspec.yaml
    while (current.path != current.parent.path) {
      final pubspecFile = File(path.join(current.path, 'pubspec.yaml'));
      if (pubspecFile.existsSync()) {
        final content = await pubspecFile.readAsString();
        if (content.contains('name: rinne_graph_desktop')) {
          return current;
        }
      }
      current = current.parent;
    }

    return null;
  }

  /// Get documents directory compatible with the app's file system structure
  static Future<Directory> _getDocumentsDirectory() async {
    if (Platform.isMacOS) {
      final homeDir = Platform.environment['HOME'];
      if (homeDir != null) {
        return Directory('$homeDir/Documents');
      }
    }

    // Fallback to system documents directory
    return Directory.systemTemp; // Simple fallback for now
  }
}
