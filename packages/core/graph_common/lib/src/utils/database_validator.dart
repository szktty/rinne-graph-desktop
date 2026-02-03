import 'package:rinne_graph/rinne_graph.dart' as rg;
import '../models/database_validation_result.dart';
import '../exceptions/database_exceptions.dart';

/// Utility class for validating RinneGraph database files.
class DatabaseValidator {
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
      return DatabaseValidationResult.error(
        filePath: filePath,
        error: DatabaseValidationException('Failed to validate database: $e'),
      );
    }
  }

  /// Tests if basic operations are possible by opening the database file.
  ///
  /// [filePath] テストするデータベースファイルのパス
  ///
  /// Returns: テスト結果
  static Future<DatabaseValidationResult> testDatabaseAccess(
    String filePath,
  ) async {
    try {
      final graph = await rg.Graph.open(filePath);

      // 基本的な統計情報を取得してみる
      final stats = await graph.getStatistics();

      await graph.close();

      return DatabaseValidationResult.success(
        filePath: filePath,
        message:
            'Database access test passed. Vertices: ${stats.totalVertices}, Edges: ${stats.totalEdges}',
      );
    } catch (e) {
      return DatabaseValidationResult.error(
        filePath: filePath,
        error: DatabaseValidationException('Database access test failed: $e'),
      );
    }
  }
}
