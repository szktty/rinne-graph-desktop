import 'package:core_graph_flutter/core_graph.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../models/exchange_models.dart';
import '../converters/json_converter.dart';
import '../converters/csv_converter.dart';
import '../converters/schema_processor.dart';

/// Stack data exchange (import/export) management service
class StackExchangeService {
  const StackExchangeService({required this.ref});

  final Ref ref;

  /// Create new stack and import JSON data
  Future<ExchangeResult<Stack>> createStackFromJson({
    required String filePath,
    required ImportConfig config,
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.0);

      // Create new stack
      final stackActions = ref.read(stackActionsProvider.notifier);
      final stack = await stackActions.createCustomStack(
        name: config.stackName,
        description: config.stackDescription,
        isScratch: config.isScratch,
        tags: config.tags,
      );

      if (stack == null) {
        return const ExchangeResult.error('Failed to create stack');
      }

      onProgress?.call(0.2);

      // Get graph context
      final graphContext = ref.read(graphContextProvider);

      // Import JSON data
      final importResult = await JsonConverter.importFromJson(
        filePath: filePath,
        stack: stack,
        graphContext: graphContext,
        config: config,
        onProgress: (progress) => onProgress?.call(0.2 + (0.8 * progress)),
      );

      if (importResult.hasError) {
        return ExchangeResult.error(
          importResult.error!,
          warnings: importResult.warnings,
        );
      }

      // Update stack list
      stackActions.triggerRefresh();

      return ExchangeResult.success(stack, warnings: importResult.warnings);
    } catch (e) {
      return ExchangeResult.error('Stack creation error: $e');
    }
  }

  /// Create new stack and import CSV data
  Future<ExchangeResult<Stack>> createStackFromCsv({
    required String filePath,
    required ImportConfig config,
    required CsvMappingConfig mapping,
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.0);

      // Create new stack
      final stackActions = ref.read(stackActionsProvider.notifier);
      final stack = await stackActions.createCustomStack(
        name: config.stackName,
        description: config.stackDescription,
        isScratch: config.isScratch,
        tags: config.tags,
      );

      if (stack == null) {
        return const ExchangeResult.error('Failed to create stack');
      }

      onProgress?.call(0.2);

      // Get graph context
      final graphContext = ref.read(graphContextProvider);

      // Auto-detect schema file
      final fileDir = path.dirname(filePath);
      final schema = await SchemaProcessor.loadSchemaFromDirectory(fileDir);

      // Import CSV data
      final importResult = await CsvConverter.importFromCsv(
        filePath: filePath,
        stack: stack,
        graphContext: graphContext,
        mapping: mapping,
        config: config,
        schema: schema,
        onProgress: (progress) => onProgress?.call(0.2 + (0.8 * progress)),
      );

      if (importResult.hasError) {
        return ExchangeResult.error(
          importResult.error!,
          warnings: importResult.warnings,
        );
      }

      // Update stack list
      stackActions.triggerRefresh();

      return ExchangeResult.success(stack, warnings: importResult.warnings);
    } catch (e) {
      return ExchangeResult.error('Stack creation error: $e');
    }
  }

  /// Import JSON data to existing stack
  Future<ExchangeResult<ImportStatistics>> importJsonToStack({
    required String filePath,
    required Stack stack,
    ImportConfig? config,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // Get graph context
      final graphContext = ref.read(graphContextProvider);

      // Import JSON data
      return await JsonConverter.importFromJson(
        filePath: filePath,
        stack: stack,
        graphContext: graphContext,
        config: config,
        onProgress: onProgress,
      );
    } catch (e) {
      return ExchangeResult.error('JSON import error: $e');
    }
  }

  /// Import CSV data to existing stack
  Future<ExchangeResult<ImportStatistics>> importCsvToStack({
    required String filePath,
    required Stack stack,
    required CsvMappingConfig mapping,
    ImportConfig? config,
    void Function(double progress)? onProgress,
  }) async {
    try {
      // Get graph context
      final graphContext = ref.read(graphContextProvider);

      // Auto-detect schema file
      final fileDir = path.dirname(filePath);
      final schema = await SchemaProcessor.loadSchemaFromDirectory(fileDir);

      // Import CSV data
      return await CsvConverter.importFromCsv(
        filePath: filePath,
        stack: stack,
        graphContext: graphContext,
        mapping: mapping,
        config: config,
        schema: schema,
        onProgress: onProgress,
      );
    } catch (e) {
      return ExchangeResult.error('CSV import error: $e');
    }
  }

  /// Export stack to JSON
  Future<ExchangeResult<String>> exportStackToJson({
    required Stack stack,
    required ExportConfig config,
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.0);

      // Get graph context
      final graphContext = ref.read(graphContextProvider);

      // TODO: Implement export functionality
      // Currently unimplemented, return error
      return const ExchangeResult.error('Export functionality not implemented');
    } catch (e) {
      return ExchangeResult.error('JSON export error: $e');
    }
  }

  /// Export stack to CSV
  Future<ExchangeResult<String>> exportStackToCsv({
    required Stack stack,
    required ExportConfig config,
    required CsvMappingConfig mapping,
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.0);

      // Get graph context
      final graphContext = ref.read(graphContextProvider);

      // TODO: Implement export functionality
      // Currently unimplemented, return error
      return const ExchangeResult.error('Export functionality not implemented');
    } catch (e) {
      return ExchangeResult.error('CSV export error: $e');
    }
  }

  /// Auto-detect CSV format (node or link)
  static Future<ExchangeResult<CsvMappingConfig>> detectCsvFormat(
    String filePath,
  ) async {
    try {
      // TODO: Implement CSV auto-detection functionality
      // Read header row and determine if it's for nodes or links
      return const ExchangeResult.error('CSV auto-detection not implemented');
    } catch (e) {
      return ExchangeResult.error('CSV detection error: $e');
    }
  }

  /// Validate import configuration
  static ExchangeResult<void> validateImportConfig(ImportConfig config) {
    final errors = <String>[];

    if (config.stackName.trim().isEmpty) {
      errors.add('Stack name is required');
    }

    if (config.stackDescription.trim().isEmpty) {
      errors.add('Stack description is required');
    }

    if (errors.isNotEmpty) {
      return ExchangeResult.error(errors.join(', '));
    }

    return const ExchangeResult.success(null);
  }

  /// Validate CSV mapping configuration
  static ExchangeResult<void> validateCsvMapping(CsvMappingConfig mapping) {
    final errors = <String>[];

    if (!mapping.isNodeConfig && !mapping.isLinkConfig) {
      errors.add('Node or Link configuration is required');
    }

    if (mapping.isNodeConfig && mapping.idColumn == null) {
      errors.add('Node configuration requires ID column');
    }

    if (mapping.isLinkConfig) {
      if (mapping.sourceColumn == null) {
        errors.add('Link configuration requires source column');
      }
      if (mapping.targetColumn == null) {
        errors.add('Link configuration requires target column');
      }
      if (mapping.typeColumn == null) {
        errors.add('Link configuration requires type column');
      }
    }

    if (errors.isNotEmpty) {
      return ExchangeResult.error(errors.join(', '));
    }

    return const ExchangeResult.success(null);
  }
}
