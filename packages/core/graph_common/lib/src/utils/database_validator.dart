/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import '../exceptions/database_exceptions.dart';
import '../models/database_validation_result.dart';
import 'package:chiffondb/chiffondb.dart';

/// Utility class for validating ChiffonDB database files.
class DatabaseValidator {
  /// Validates a database file by attempting to open it.
  ///
  /// Returns success if the file can be opened as a valid ChiffonDB database.
  static Future<DatabaseValidationResult> validateDatabase(
    String filePath,
  ) async {
    try {
      final db = await Connection.open(path: filePath);
      await db.close();
      return DatabaseValidationResult.success(filePath: filePath);
    } catch (e) {
      return DatabaseValidationResult.error(
        filePath: filePath,
        error: DatabaseValidationException('Failed to validate database: $e'),
      );
    }
  }

  /// Tests basic read access by opening the database.
  static Future<DatabaseValidationResult> testDatabaseAccess(
    String filePath,
  ) async {
    try {
      final db = await Connection.open(path: filePath);
      await db.close();
      return DatabaseValidationResult.success(
        filePath: filePath,
        message: 'Database access test passed',
      );
    } catch (e) {
      return DatabaseValidationResult.error(
        filePath: filePath,
        error: DatabaseValidationException('Database access test failed: $e'),
      );
    }
  }
}
