/// データベース作成時の例外
class DatabaseCreationException implements Exception {
  /// エラーメッセージ
  final String message;

  /// コンストラクタ
  const DatabaseCreationException(this.message);

  @override
  String toString() => 'DatabaseCreationException: $message';
}

/// データベース検証時の例外
class DatabaseValidationException implements Exception {
  /// エラーメッセージ
  final String message;

  /// コンストラクタ
  const DatabaseValidationException(this.message);

  @override
  String toString() => 'DatabaseValidationException: $message';
}
