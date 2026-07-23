/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:core_graph_common/core_graph_common.dart';
import 'package:path/path.dart' as path;

import '../model.dart';

/// Service for getting stack statistics
class StackStatisticsService {
  /// Gets stack statistics
  ///
  /// [stack] The stack for which to get statistics
  /// Returns: StackStatisticsInfo (node count, link count, file size, error information)
  Future<StackStatisticsInfo> getStackStatistics(Stack stack) async {
    print(
      '[StackStatisticsService] Start getting stack statistics: ${stack.info.name}',
    );
    print('[StackStatisticsService] Stack directory: ${stack.directory.path}');

    try {
      // Get database file path
      final dbPath = path.join(stack.directory.path, 'data', 'graph.db');
      final dbFile = File(dbPath);
      print('[StackStatisticsService] Database file path: $dbPath');

      // Get file size
      int databaseSize = 0;
      if (await dbFile.exists()) {
        final stat = await dbFile.stat();
        databaseSize = stat.size;
        print(
          '[StackStatisticsService] Database file existence check: OK (size: $databaseSize bytes)',
        );
      } else {
        print(
          '[StackStatisticsService] Error: Database file not found: $dbPath',
        );
        return StackStatisticsInfo(
          nodeCount: 0,
          linkCount: 0,
          databaseSize: 0,
          error: 'Database file not found: $dbPath',
        );
      }

      // Get database statistics using GraphStorage
      try {
        final storage = ChiffonStorage(
          path: dbPath,
          schema: ChiffonSchemaGenerator.minimalSchema,
        );
        await storage.initialize();
        final statistics = await storage.getStatistics();
        await storage.close();

        return StackStatisticsInfo(
          nodeCount: statistics.nodeCount,
          linkCount: statistics.linkCount,
          databaseSize: databaseSize,
        );
      } catch (e, stackTrace) {
        // In case of database access error, return only file size
        print('[StackStatisticsService] Database access error: $e');
        print('[StackStatisticsService] Stack trace: $stackTrace');
        return StackStatisticsInfo(
          nodeCount: 0,
          linkCount: 0,
          databaseSize: databaseSize,
          error: 'Failed to get database information: $e',
        );
      }
    } catch (e, stackTrace) {
      print('[StackStatisticsService] Overall error: $e');
      print('[StackStatisticsService] Stack trace: $stackTrace');
      return StackStatisticsInfo(
        nodeCount: 0,
        linkCount: 0,
        databaseSize: 0,
        error: 'Failed to get stack statistics: $e',
      );
    }
  }
}

/// Class representing stack statistics information
class StackStatisticsInfo {
  const StackStatisticsInfo({
    required this.nodeCount,
    required this.linkCount,
    required this.databaseSize,
    this.error,
  });

  /// Node count
  final int nodeCount;

  /// Link count
  final int linkCount;

  /// Database file size (bytes)
  final int databaseSize;

  /// Error message (if any)
  final String? error;

  /// Whether there is an error
  bool get hasError => error != null;

  /// Returns database size in human-readable format
  String get formattedDatabaseSize {
    if (databaseSize < 1024) {
      return '${databaseSize} B';
    } else if (databaseSize < 1024 * 1024) {
      return '${(databaseSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(databaseSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  @override
  String toString() {
    return 'StackStatisticsInfo(nodeCount: $nodeCount, linkCount: $linkCount, '
        'databaseSize: $databaseSize, error: $error)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StackStatisticsInfo &&
          runtimeType == other.runtimeType &&
          nodeCount == other.nodeCount &&
          linkCount == other.linkCount &&
          databaseSize == other.databaseSize &&
          error == other.error;

  @override
  int get hashCode =>
      nodeCount.hashCode ^
      linkCount.hashCode ^
      databaseSize.hashCode ^
      error.hashCode;
}
