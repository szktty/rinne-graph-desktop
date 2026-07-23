/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import '../exceptions/database_exceptions.dart';
import '../storage/chiffon_schema_generator.dart';
import 'package:chiffondb/chiffondb.dart';

/// Utility class for creating ChiffonDB database files.
class DatabaseCreator {
  /// Creates an empty ChiffonDB database file with the minimal schema.
  ///
  /// The minimal schema contains only the `_Entity` base node type.
  /// Call `ChiffonStorage.initialize` with a full schema to add types later.
  static Future<bool> createEmptyDatabase(String filePath) async {
    try {
      final db = await Connection.create(path: filePath);
      await db.applySchema(schemaText: ChiffonSchemaGenerator.minimalSchema);
      await db.close();
      return true;
    } catch (e) {
      throw DatabaseCreationException(
        'Failed to create ChiffonDB database: $e',
      );
    }
  }
}
