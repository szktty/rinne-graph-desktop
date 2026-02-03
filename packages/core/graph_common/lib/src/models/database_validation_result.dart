import 'package:rinne_graph/rinne_graph.dart' as rg;
import '../exceptions/database_exceptions.dart';

/// データベース検証結果を表すクラス
class DatabaseValidationResult {
  /// 検証が成功したかどうか
  final bool isSuccess;

  /// データベースファイルのパス
  final String filePath;

  /// データベースが有効かどうか
  final bool isValid;

  /// データベースが初期化されているかどうか
  final bool isInitialized;

  /// データベースが完全に初期化されているかどうか
  final bool isFullyInitialized;

  /// 不足しているテーブルのリスト
  final List<String> missingTables;

  /// 不足しているインデックスのリスト
  final List<String> missingIndexes;

  /// 不足しているトリガーのリスト
  final List<String> missingTriggers;

  /// スキーマバージョン
  final int? schemaVersion;

  /// 成功時のメッセージ
  final String? message;

  /// エラー情報
  final DatabaseValidationException? error;

  const DatabaseValidationResult._({
    required this.isSuccess,
    required this.filePath,
    required this.isValid,
    required this.isInitialized,
    required this.isFullyInitialized,
    required this.missingTables,
    required this.missingIndexes,
    required this.missingTriggers,
    this.schemaVersion,
    this.message,
    this.error,
  });

  /// rinne_graphのDatabaseValidationResultから変換
  factory DatabaseValidationResult.fromRinneGraph(
    rg.DatabaseValidationResult result,
  ) {
    return DatabaseValidationResult._(
      isSuccess: true,
      filePath: '', // rinne_graphの結果にはパス情報がない
      isValid: result.isValid,
      isInitialized: result.isInitialized,
      isFullyInitialized: result.isFullyInitialized,
      missingTables: result.missingTables,
      missingIndexes: result.missingIndexes,
      missingTriggers: result.missingTriggers,
      schemaVersion: result.schemaVersion,
    );
  }

  /// 成功結果を作成
  factory DatabaseValidationResult.success({
    required String filePath,
    String? message,
  }) {
    return DatabaseValidationResult._(
      isSuccess: true,
      filePath: filePath,
      isValid: true,
      isInitialized: true,
      isFullyInitialized: true,
      missingTables: const [],
      missingIndexes: const [],
      missingTriggers: const [],
      message: message,
    );
  }

  /// エラー結果を作成
  factory DatabaseValidationResult.error({
    required String filePath,
    required DatabaseValidationException error,
  }) {
    return DatabaseValidationResult._(
      isSuccess: false,
      filePath: filePath,
      isValid: false,
      isInitialized: false,
      isFullyInitialized: false,
      missingTables: const [],
      missingIndexes: const [],
      missingTriggers: const [],
      error: error,
    );
  }

  /// 検証結果の詳細な説明を取得
  String get description {
    if (!isSuccess) {
      return error?.message ?? 'Validation failed';
    }

    if (message != null) {
      return message!;
    }

    if (isFullyInitialized) {
      return 'データベースは正常に初期化されています（バージョン: $schemaVersion）';
    }

    final issues = <String>[];

    if (!isValid) {
      issues.add('データベースファイルが無効です');
    }

    if (!isInitialized) {
      issues.add('RinneGraph用に初期化されていません');
    }

    if (missingTables.isNotEmpty) {
      issues.add('不足しているテーブル: ${missingTables.join(', ')}');
    }

    if (missingIndexes.isNotEmpty) {
      issues.add('不足しているインデックス: ${missingIndexes.join(', ')}');
    }

    if (missingTriggers.isNotEmpty) {
      issues.add('不足しているトリガー: ${missingTriggers.join(', ')}');
    }

    return issues.join('\n');
  }

  @override
  String toString() =>
      'DatabaseValidationResult(isSuccess: $isSuccess, '
      'filePath: $filePath, isFullyInitialized: $isFullyInitialized)';
}
