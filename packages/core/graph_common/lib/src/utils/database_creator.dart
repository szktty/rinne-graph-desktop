import 'dart:io';
import 'package:rinne_graph/rinne_graph.dart' as rg;
import '../exceptions/database_exceptions.dart';
import '../models/database_validation_result.dart';

/// Utility class for creating RinneGraph database files.
class DatabaseCreator {
  /// Creates an empty RinneGraph database file.
  ///
  /// [filePath] 作成するデータベースファイルのパス
  ///
  /// Returns: 作成に成功した場合はtrue、失敗した場合はfalse
  ///
  /// Throws: [DatabaseCreationException] データベース作成に失敗した場合
  static Future<bool> createEmptyDatabase(String filePath) async {
    try {
      // Convert path to absolute path
      final absolutePath = File(filePath).absolute.path;

      // Create RinneGraph database
      final graph = await rg.Graph.open(absolutePath);

      // Close properly if initialization is successful
      await graph.close();

      return true;
    } catch (e) {
      throw DatabaseCreationException(
        'Failed to create RinneGraph database: $e',
      );
    }
  }

  /// Validates if the database file is properly initialized.
  ///
  /// [filePath] 検証するデータベースファイルのパス
  ///
  /// Returns: 検証結果
  static Future<DatabaseValidationResult> validateDatabase(
    String filePath,
  ) async {
    try {
      final manager = rg.DatabaseManager();
      final rinneResult = await manager.validateDatabaseFile(filePath);
      return DatabaseValidationResult.fromRinneGraph(rinneResult);
    } catch (e) {
      throw DatabaseValidationException('Failed to validate database: $e');
    }
  }
}
