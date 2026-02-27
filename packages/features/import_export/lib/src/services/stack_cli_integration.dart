/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:core_stack_flutter/core_stack.dart';

/// Integration service with stack_cli tool.
class StackCliIntegration {
  /// Imports a stack using a manifest.json file.
  static Future<ImportResult> importFromManifest({
    required String manifestPath,
    required String outputDirectory,
    bool verbose = false,
    bool strict = false,
    bool skipValidation = false,
    void Function(String)? onProgress,
  }) async {
    try {
      onProgress?.call('Validating manifest file...');

      // マニフェストファイルの存在確認
      final manifestFile = File(manifestPath);
      if (!await manifestFile.exists()) {
        throw ImportException('Manifest file not found: $manifestPath');
      }

      // マニフェストファイルの読み込みと検証
      final manifestContent = await manifestFile.readAsString();
      final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;

      _validateManifest(manifest);

      onProgress?.call('Executing stack_cli...');

      // stack_cliコマンドの構築
      final stackCliPath = await _findStackCliExecutable();
      final arguments = [
        'import',
        '--manifest',
        manifestPath,
        if (verbose) '--verbose',
        if (strict) '--strict',
        if (skipValidation) '--skip-validation',
        outputDirectory,
      ];

      // stack_cliの実行
      final result = await Process.run(stackCliPath, arguments);

      if (result.exitCode != 0) {
        throw ImportException('stack_cli execution failed: ${result.stderr}');
      }

      onProgress?.call('Import complete');

      // 作成されたスタックの情報を取得
      final stackDirectory = Directory(outputDirectory);
      if (await stackDirectory.exists()) {
        final stackInfo = await _loadStackInfo(outputDirectory);
        return ImportResult.success(
          stackPath: outputDirectory,
          stackInfo: stackInfo,
          message: 'Import from manifest completed',
        );
      } else {
        throw ImportException('Stack directory was not created');
      }
    } catch (e) {
      return ImportResult.failure(
        error: e.toString(),
        message: 'Import from manifest failed',
      );
    }
  }

  /// Imports a stack using a CSV file.
  static Future<ImportResult> importFromCsv({
    required String csvPath,
    required String outputDirectory,
    String? stackName,
    String? description,
    String? author,
    List<String> tags = const [],
    bool verbose = false,
    bool strict = false,
    void Function(String)? onProgress,
  }) async {
    try {
      onProgress?.call('Validating CSV file...');

      // CSVファイルの存在確認
      final csvFile = File(csvPath);
      if (!await csvFile.exists()) {
        throw ImportException('CSV file not found: $csvPath');
      }

      onProgress?.call('Executing stack_cli...');

      // stack_cliコマンドの構築
      final stackCliPath = await _findStackCliExecutable();
      final arguments = <String>[
        'import',
        if (stackName != null) ...['--name', stackName],
        if (description != null) ...['--description', description],
        if (author != null) ...['--author', author],
        for (final tag in tags) ...['--tags', tag],
        if (verbose) '--verbose',
        if (strict) '--strict',
        csvPath,
        outputDirectory,
      ];

      // stack_cliの実行
      final result = await Process.run(stackCliPath, arguments);

      if (result.exitCode != 0) {
        throw ImportException('stack_cli execution failed: ${result.stderr}');
      }

      onProgress?.call('Import complete');

      // 作成されたスタックの情報を取得
      final stackDirectory = Directory(outputDirectory);
      if (await stackDirectory.exists()) {
        final stackInfo = await _loadStackInfo(outputDirectory);
        return ImportResult.success(
          stackPath: outputDirectory,
          stackInfo: stackInfo,
          message: 'Import from CSV completed',
        );
      } else {
        throw ImportException('Stack directory was not created');
      }
    } catch (e) {
      return ImportResult.failure(
        error: e.toString(),
        message: 'Import from CSV failed',
      );
    }
  }

  /// Searches for the stack_cli executable.
  static Future<String> _findStackCliExecutable() async {
    // Relative path in development environment
    final devPath = path.join('apps', 'stack_cli', 'bin', 'app_stack.dart');
    if (await File(devPath).exists()) {
      return 'dart';
    }

    // Search from system PATH
    final result = await Process.run('which', ['stack-cli']);
    if (result.exitCode == 0) {
      return result.stdout.toString().trim();
    }

    throw ImportException('stack_cli executable not found');
  }

  /// Validates the manifest file.
  static void _validateManifest(Map<String, dynamic> manifest) {
    if (!manifest.containsKey('name')) {
      throw ImportException('Manifest file does not contain name field');
    }

    if (!manifest.containsKey('files')) {
      throw ImportException('Manifest file does not contain files field');
    }

    final files = manifest['files'] as List<dynamic>?;
    if (files == null || files.isEmpty) {
      throw ImportException("Manifest file's files field is empty");
    }
  }

  /// Loads stack information.
  static Future<StackInfo> _loadStackInfo(String stackPath) async {
    final infoFile = File(path.join(stackPath, 'meta', 'info.json'));
    if (await infoFile.exists()) {
      final content = await infoFile.readAsString();
      final info = jsonDecode(content) as Map<String, dynamic>;

      return StackInfo(
        name: info['name'] as String,
        description: info['description'] as String? ?? '',
        author: info['author'] as String? ?? '',
        version: info['version'] as String? ?? '1.0.0',
        tags: (info['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(info['created'] as String),
        lastModifiedAt: DateTime.now(),
      );
    } else {
      throw ImportException('Stack info file not found');
    }
  }
}

/// Import result.
class ImportResult {
  final bool success;
  final String? stackPath;
  final StackInfo? stackInfo;
  final String message;
  final String? error;

  const ImportResult._({
    required this.success,
    this.stackPath,
    this.stackInfo,
    required this.message,
    this.error,
  });

  factory ImportResult.success({
    required String stackPath,
    required StackInfo stackInfo,
    required String message,
  }) {
    return ImportResult._(
      success: true,
      stackPath: stackPath,
      stackInfo: stackInfo,
      message: message,
    );
  }

  factory ImportResult.failure({
    required String error,
    required String message,
  }) {
    return ImportResult._(success: false, message: message, error: error);
  }
}

/// Import exception.
class ImportException implements Exception {
  final String message;

  const ImportException(this.message);

  @override
  String toString() => 'ImportException: $message';
}
