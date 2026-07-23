/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_graph_common/core_graph_common.dart';
import 'package:path/path.dart' as path;
import '../widgets/dialogs/stack_creation_dialog.dart';

/// Stack management service
class StackManagementService {
  /// Gets the default save path (for relative path display)
  static Future<String> getDefaultSavePath() async {
    final fileSystemService = FileSystemService();
    final appDir = await fileSystemService.getApplicationDocumentsDirectory();
    final stacksDir = Directory(path.join(appDir.path, 'Stacks'));

    // Create Stacks directory if it does not exist
    if (!await stacksDir.exists()) {
      await stacksDir.create(recursive: true);
    }

    // Convert to relative path display
    return _convertToRelativePath(stacksDir.path);
  }

  /// Converts absolute path to relative path display
  static String _convertToRelativePath(String absolutePath) {
    // Get home directory
    final homeDir =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (homeDir != null && absolutePath.startsWith(homeDir)) {
      return absolutePath.replaceFirst(homeDir, '~');
    }
    return absolutePath;
  }

  /// Converts relative path to absolute path
  static String _convertToAbsolutePath(String relativePath) {
    if (relativePath.startsWith('~')) {
      final homeDir =
          Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (homeDir != null) {
        return relativePath.replaceFirst('~', homeDir);
      }
    }
    return relativePath;
  }

  /// Displays the new stack creation dialog and processes the result
  static Future<core_stack.Stack?> createNewStack(
    BuildContext context, {
    String? initialSavePath,
    String? language,
  }) async {
    // Set default save path
    final defaultSavePath = initialSavePath ?? await getDefaultSavePath();

    if (!context.mounted) return null;

    final result = await showStackCreationDialog(
      context: context,
      initialSavePath: defaultSavePath,
    );

    if (result != null) {
      try {
        // Implement actual stack creation process
        final createdStack = await _createStackFromResult(
          result,
          language: language,
        );

        if (context.mounted) {
          // Display success message in dialog
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Stack Creation Complete'),
                  content: Text('Stack "${result.name}" created'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }

        return createdStack;
      } catch (e) {
        if (context.mounted) {
          // Display error message in dialog
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Stack Creation Error'),
                  content: Text('An error occurred during stack creation:\n$e'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
        return null;
      }
    }

    return null;
  }

  /// Internal method to create a stack from stack creation results
  static Future<core_stack.Stack?> _createStackFromResult(
    StackCreationResult result, {
    String? language,
  }) async {
    // Convert relative path to absolute path
    final absoluteSavePath = _convertToAbsolutePath(result.savePath);
    final saveDir = Directory(absoluteSavePath);

    // Sanitize stack name
    final sanitizedName = _sanitizeFileName(result.name);
    final stackDirPath = path.join(absoluteSavePath, '$sanitizedName.stack');
    final stackDir = Directory(stackDirPath);

    // Create stack directory structure
    await stackDir.create(recursive: true);
    await Directory(path.join(stackDirPath, 'meta')).create();
    await Directory(path.join(stackDirPath, 'data')).create();
    await Directory(path.join(stackDirPath, 'datasets')).create();
    await Directory(path.join(stackDirPath, 'filters')).create();
    await Directory(path.join(stackDirPath, 'assets')).create();

    // Create metadata files
    await _createMetadataFiles(stackDir, result.name, language: language);

    // Create empty graph database
    await _createEmptyGraphDatabase(stackDir);

    // Create and return Stack object
    final stackInfo = core_stack.StackInfo(
      name: result.name,
      createdAt: DateTime.now(),
      lastModifiedAt: DateTime.now(),
      version: '1.0',
      language: language,
    );

    final stackSettings = core_stack.StackSettings();

    return core_stack.Stack(
      directory: stackDir,
      info: stackInfo,
      settings: stackSettings,
    );
  }

  /// Sanitizes the file name
  static String _sanitizeFileName(String name) {
    // Specification: spaces become hyphens, path separators become underscores, others are removed
    return name
        .replaceAll(RegExp(r'[\\/]'), '_') // Replace path separators with _
        .replaceAll(RegExp(r'\s+'), '-') // Replace one or more spaces with -
        .replaceAll(RegExp(r'[<>:"|?*]'), '') // Remove other invalid characters
        .trim();
  }

  /// Creates metadata files
  static Future<void> _createMetadataFiles(
    Directory stackDir,
    String name, {
    String? language,
  }) async {
    final infoFile = File(path.join(stackDir.path, 'meta', 'info.json'));
    final settingsFile = File(
      path.join(stackDir.path, 'meta', 'settings.json'),
    );

    final infoData = {
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
      'lastModifiedAt': DateTime.now().toIso8601String(),
      'version': '1.0',
      if (language != null) 'language': language,
    };

    final settingsData = <String, dynamic>{};

    await infoFile.writeAsString(jsonEncode(infoData));
    await settingsFile.writeAsString(jsonEncode(settingsData));
  }

  /// Creates an empty graph database
  static Future<void> _createEmptyGraphDatabase(Directory stackDir) async {
    final dbPath = path.join(stackDir.path, 'data', 'graph.db');
    final absolutePath = File(dbPath).absolute.path;
    await DatabaseCreator.createEmptyDatabase(absolutePath);
  }
}
