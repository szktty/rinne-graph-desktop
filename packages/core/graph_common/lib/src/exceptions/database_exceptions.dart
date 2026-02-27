/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

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
