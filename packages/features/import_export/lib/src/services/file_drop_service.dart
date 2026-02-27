/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as path;

/// File drop processing service
class FileDropService {
  /// Analyze dropped files to determine the import method.
  static Future<FileDropAnalysis> analyzeDroppedFiles(List<XFile> files) async {
    final analysis = FileDropAnalysis();

    for (final file in files) {
      final fileName = path.basename(file.path);
      final extension = path.extension(file.path).toLowerCase();

      // Determine file format
      switch (extension) {
        case '.json':
          if (fileName == 'manifest.json') {
            analysis.manifestFiles.add(file);
          } else {
            analysis.jsonFiles.add(file);
          }
          break;
        case '.csv':
          analysis.csvFiles.add(file);
          break;
        case '.yaml':
        case '.yml':
          analysis.yamlFiles.add(file);
          break;
        default:
          analysis.unknownFiles.add(file);
      }
    }

    // Estimate import method
    analysis.importMethod = _determineImportMethod(analysis);

    return analysis;
  }

  /// Determine the import method.
  static ImportMethod _determineImportMethod(FileDropAnalysis analysis) {
    // Prioritize if manifest.json exists
    if (analysis.manifestFiles.isNotEmpty) {
      return ImportMethod.manifest;
    }

    // If there are CSV files
    if (analysis.csvFiles.isNotEmpty) {
      return ImportMethod.csv;
    }

    // If there are JSON files
    if (analysis.jsonFiles.isNotEmpty) {
      return ImportMethod.json;
    }

    // If there are YAML files
    if (analysis.yamlFiles.isNotEmpty) {
      return ImportMethod.yaml;
    }

    return ImportMethod.unknown;
  }

  /// Generate an import preview from a manifest file.
  static Future<ImportPreview> generateManifestPreview(
    XFile manifestFile,
  ) async {
    try {
      final content = await manifestFile.readAsString();
      final manifest = jsonDecode(content) as Map<String, dynamic>;

      final files = manifest['files'] as List<dynamic>? ?? [];
      final manifestDir = path.dirname(manifestFile.path);

      final preview = ImportPreview(
        method: ImportMethod.manifest,
        stackName: manifest['name'] as String? ?? 'Unnamed Stack',
        description: manifest['description'] as String? ?? '',
        estimatedNodes: _estimateNodesFromManifest(manifest),
        estimatedLinks: _estimateLinksFromManifest(manifest),
        files: files.map((f) => path.join(manifestDir, f.toString())).toList(),
        warnings: [],
      );

      // Check for file existence
      for (final filePath in preview.files) {
        if (!await File(filePath).exists()) {
          preview.warnings.add('File not found: ${path.basename(filePath)}');
        }
      }

      return preview;
    } catch (e) {
      return ImportPreview.error('Failed to parse manifest file: $e');
    }
  }

  /// Generate an import preview from CSV files.
  static Future<ImportPreview> generateCsvPreview(List<XFile> csvFiles) async {
    try {
      int totalEstimatedNodes = 0;
      int totalEstimatedLinks = 0;
      final warnings = <String>[];

      for (final file in csvFiles) {
        final content = await file.readAsString();
        final lines =
            content
                .split('\n')
                .where((line) => line.trim().isNotEmpty)
                .toList();

        if (lines.length > 1) {
          // Exclude header row
          final fileName = path.basenameWithoutExtension(file.path);
          if (fileName.toLowerCase().contains('node')) {
            totalEstimatedNodes += lines.length - 1;
          } else if (fileName.toLowerCase().contains('link') ||
              fileName.toLowerCase().contains('edge')) {
            totalEstimatedLinks += lines.length - 1;
          } else {
            // If the file type cannot be determined from the file name, treat it as a node.
            totalEstimatedNodes += lines.length - 1;
            warnings.add(
              '${path.basename(file.path)}: Could not determine file type (processing as a node)',
            );
          }
        }
      }

      return ImportPreview(
        method: ImportMethod.csv,
        stackName: 'CSV Import ${DateTime.now().millisecondsSinceEpoch}',
        description: 'Stack imported from CSV files',
        estimatedNodes: totalEstimatedNodes,
        estimatedLinks: totalEstimatedLinks,
        files: csvFiles.map((f) => f.path).toList(),
        warnings: warnings,
      );
    } catch (e) {
      return ImportPreview.error('Failed to parse CSV file: $e');
    }
  }

  /// Estimate the number of nodes from the manifest.
  static int _estimateNodesFromManifest(Map<String, dynamic> manifest) {
    // Simple estimation (in the actual implementation, the file will be parsed).
    final files = manifest['files'] as List<dynamic>? ?? [];
    return files.length * 100; // Tentative estimated value
  }

  /// Estimate the number of links from the manifest.
  static int _estimateLinksFromManifest(Map<String, dynamic> manifest) {
    // Simple estimation (in the actual implementation, the file will be parsed).
    final files = manifest['files'] as List<dynamic>? ?? [];
    return files.length * 50; // Tentative estimated value
  }
}

/// File drop analysis result
class FileDropAnalysis {
  final List<XFile> manifestFiles = [];
  final List<XFile> csvFiles = [];
  final List<XFile> jsonFiles = [];
  final List<XFile> yamlFiles = [];
  final List<XFile> unknownFiles = [];

  ImportMethod importMethod = ImportMethod.unknown;

  /// Whether there are processable files.
  bool get hasProcessableFiles =>
      manifestFiles.isNotEmpty ||
      csvFiles.isNotEmpty ||
      jsonFiles.isNotEmpty ||
      yamlFiles.isNotEmpty;

  /// Total number of files.
  int get totalFiles =>
      manifestFiles.length +
      csvFiles.length +
      jsonFiles.length +
      yamlFiles.length +
      unknownFiles.length;
}

/// Import method.
enum ImportMethod { manifest, csv, json, yaml, unknown }

/// Import preview.
class ImportPreview {
  final ImportMethod method;
  final String stackName;
  final String description;
  final int estimatedNodes;
  final int estimatedLinks;
  final List<String> files;
  final List<String> warnings;
  final String? error;

  const ImportPreview({
    required this.method,
    required this.stackName,
    required this.description,
    required this.estimatedNodes,
    required this.estimatedLinks,
    required this.files,
    required this.warnings,
    this.error,
  });

  factory ImportPreview.error(String error) {
    return ImportPreview(
      method: ImportMethod.unknown,
      stackName: '',
      description: '',
      estimatedNodes: 0,
      estimatedLinks: 0,
      files: [],
      warnings: [],
      error: error,
    );
  }

  bool get hasError => error != null;
  bool get hasWarnings => warnings.isNotEmpty;
}
