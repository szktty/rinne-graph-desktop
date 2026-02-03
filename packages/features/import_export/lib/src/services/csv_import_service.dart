import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:core_graph_flutter/core_graph.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CsvImportService {
  static Future<Stack?> importCsvToStack({
    required String filePath,
    required String stackName,
    required ProviderContainer container,
    void Function(double)? onProgress,
  }) async {
    try {
      // Report progress
      onProgress?.call(0.0);

      // CSVファイルを読み込む
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final contents = await file.readAsString(encoding: utf8);

      // CSV parsing
      final rows = const CsvToListConverter().convert(contents);

      if (rows.isEmpty) {
        throw Exception('CSV file is empty');
      }

      onProgress?.call(0.2);

      // Get stack creation action
      final stackActions = container.read(stackActionsProvider.notifier);

      // Create new stack
      final stack = await stackActions.createCustomStack(
        name: stackName,
        description: 'Imported from CSV: ${filePath.split('/').last}',
        isScratch: false,
        tags: ['imported', 'csv'],
      );

      if (stack == null) {
        throw Exception('Failed to create stack');
      }

      onProgress?.call(0.5);

      // Create graph storage and context
      final graphDbPath = '${stack.directory.path}/data/graph.db';
      final storage = RinneGraphStorage(graphDbPath);
      await storage.initialize();

      final graphContext = GraphContext(storage: storage);
      await graphContext.initialize();

      // Process header row
      List<String>? headers;
      int dataStartRow = 0;

      if (rows.isNotEmpty) {
        headers = rows.first.map((e) => e.toString()).toList();
        dataStartRow = 1;
      }

      // Create nodes
      final totalRows = rows.length - dataStartRow;

      for (int i = dataStartRow; i < rows.length; i++) {
        final row = rows[i];
        final properties = <String, dynamic>{};

        // Set data for each column as properties
        for (int j = 0; j < row.length; j++) {
          final key =
              headers != null && j < headers.length ? headers[j] : 'column_$j';
          properties[key] = row[j];
        }

        // Create node
        await graphContext.createNode(
          description: EntityDescription(
            type: 'ImportedNode',
            propertyTypes: properties.map(
              (key, value) => MapEntry(key, TextPropertyType()),
            ),
          ),
          labels: {'ImportedNode'},
          properties: properties,
        );

        // Update progress
        final progress = 0.5 + (0.5 * (i - dataStartRow + 1) / totalRows);
        onProgress?.call(progress);
      }

      return stack;
    } catch (e) {
      rethrow;
    }
  }
}
