import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

import '../models/import_config.dart';

/// File import service
class FileImportService {
  static const int maxFileSizeBytes = 100 * 1024 * 1024; // 100MB
  static const Set<String> supportedExtensions = {
    '.csv',
    '.json',
    '.yaml',
    '.yml',
  };

  /// Validates file validity
  Future<FileValidationResult> validateFile(String filePath) async {
    try {
      final file = File(filePath);

      // Check file existence
      if (!await file.exists()) {
        return FileValidationResult.error('File not found: $filePath');
      }

      // Check file size
      final size = await file.length();
      if (size > maxFileSizeBytes) {
        return FileValidationResult.error(
          'File size too large (${_formatFileSize(size)})',
        );
      }

      // Check file format
      final extension = path.extension(filePath).toLowerCase();
      if (!supportedExtensions.contains(extension)) {
        return FileValidationResult.error(
          'Unsupported file format: $extension',
        );
      }

      // Check file readability
      try {
        await file.readAsString(encoding: utf8);
      } catch (e) {
        return FileValidationResult.error('Cannot read file: $e');
      }

      return FileValidationResult.success();
    } catch (e) {
      return FileValidationResult.error('File validation error: $e');
    }
  }

  /// Detects file type
  ImportType detectFileType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.csv':
        return ImportType.csv;
      case '.json':
        return ImportType.json;
      case '.yaml':
      case '.yml':
        return ImportType.yaml;
      default:
        throw UnsupportedError('Unsupported file format: $extension');
    }
  }

  /// Parses CSV file to get headers and sample data
  Future<CsvAnalysisResult> analyzeCsv(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);

      const converter = CsvToListConverter();
      final rows = converter.convert(content);

      if (rows.isEmpty) {
        throw ImportException('CSV file is empty');
      }

      final headers = rows.first.cast<String>();
      final sampleRows =
          rows.skip(1).take(5).map((row) {
            final map = <String, dynamic>{};
            for (int i = 0; i < headers.length && i < row.length; i++) {
              map[headers[i]] = row[i];
            }
            return map;
          }).toList();

      return CsvAnalysisResult(
        headers: headers,
        sampleRows: sampleRows,
        totalRows: rows.length - 1, // Exclude header
      );
    } catch (e) {
      throw ImportException('CSV parsing error: $e');
    }
  }

  /// Parses JSON file
  Future<JsonAnalysisResult> analyzeJson(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);

      final data = json.decode(content);

      if (data is! Map<String, dynamic>) {
        throw ImportException('JSON file must be in object format');
      }

      // Check for metadata existence
      final hasMetadata = data.containsKey('metadata');
      final hasEntities = data.containsKey('entities');
      final hasRelations = data.containsKey('relations');

      Map<String, dynamic>? metadata;
      if (hasMetadata && data['metadata'] is Map<String, dynamic>) {
        metadata = Map<String, dynamic>.from(data['metadata']);
      }

      return JsonAnalysisResult(
        hasMetadata: hasMetadata,
        hasEntities: hasEntities,
        hasRelations: hasRelations,
        metadata: metadata,
        entitiesCount:
            hasEntities && data['entities'] is List
                ? (data['entities'] as List).length
                : 0,
        relationsCount:
            hasRelations && data['relations'] is List
                ? (data['relations'] as List).length
                : 0,
      );
    } catch (e) {
      throw ImportException('JSON parsing error: $e');
    }
  }

  /// Parses YAML file
  Future<YamlAnalysisResult> analyzeYaml(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);

      final yamlData = loadYaml(content);

      if (yamlData is! Map) {
        throw ImportException('YAML file must be in map format');
      }

      final data = Map<String, dynamic>.from(yamlData);

      // Check if it's an rinne-graph-desktop configuration file
      final hasMetadata = data.containsKey('metadata');
      final hasDataSources = data.containsKey('data_sources');

      Map<String, dynamic>? metadata;
      if (hasMetadata && data['metadata'] is Map) {
        metadata = Map<String, dynamic>.from(data['metadata']);
      }

      return YamlAnalysisResult(
        isStackConfig: hasMetadata && hasDataSources,
        hasMetadata: hasMetadata,
        hasDataSources: hasDataSources,
        metadata: metadata,
      );
    } catch (e) {
      throw ImportException('YAML parsing error: $e');
    }
  }

  /// Formats file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// File validation result
class FileValidationResult {
  final bool isValid;
  final String? errorMessage;

  const FileValidationResult._(this.isValid, this.errorMessage);

  factory FileValidationResult.success() =>
      const FileValidationResult._(true, null);
  factory FileValidationResult.error(String message) =>
      FileValidationResult._(false, message);
}

/// CSV analysis result
class CsvAnalysisResult {
  final List<String> headers;
  final List<Map<String, dynamic>> sampleRows;
  final int totalRows;

  const CsvAnalysisResult({
    required this.headers,
    required this.sampleRows,
    required this.totalRows,
  });
}

/// JSON analysis result
class JsonAnalysisResult {
  final bool hasMetadata;
  final bool hasEntities;
  final bool hasRelations;
  final Map<String, dynamic>? metadata;
  final int entitiesCount;
  final int relationsCount;

  const JsonAnalysisResult({
    required this.hasMetadata,
    required this.hasEntities,
    required this.hasRelations,
    this.metadata,
    required this.entitiesCount,
    required this.relationsCount,
  });
}

/// YAML analysis result
class YamlAnalysisResult {
  final bool isStackConfig;
  final bool hasMetadata;
  final bool hasDataSources;
  final Map<String, dynamic>? metadata;

  const YamlAnalysisResult({
    required this.isStackConfig,
    required this.hasMetadata,
    required this.hasDataSources,
    this.metadata,
  });
}

/// Import exception
class ImportException implements Exception {
  final String message;
  const ImportException(this.message);

  @override
  String toString() => 'ImportException: $message';
}
