/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import '../exceptions/database_exceptions.dart';

/// データベース作成結果を表すクラス
class DatabaseCreationResult {
  /// 作成が成功したかどうか
  final bool isSuccess;

  /// データベースファイルのパス
  final String filePath;

  /// 成功時のメッセージ
  final String? message;

  /// 失敗時のエラー
  final DatabaseCreationException? error;

  const DatabaseCreationResult._({
    required this.isSuccess,
    required this.filePath,
    this.message,
    this.error,
  });

  /// 成功結果を作成
  factory DatabaseCreationResult.success({
    required String filePath,
    String? message,
  }) {
    return DatabaseCreationResult._(
      isSuccess: true,
      filePath: filePath,
      message: message,
    );
  }

  /// 失敗結果を作成
  factory DatabaseCreationResult.failure({
    required String filePath,
    required DatabaseCreationException error,
  }) {
    return DatabaseCreationResult._(
      isSuccess: false,
      filePath: filePath,
      error: error,
    );
  }

  /// 結果の説明を取得
  String get description {
    if (isSuccess) {
      return message ?? 'Database created successfully';
    } else {
      return error?.message ?? 'Database creation failed';
    }
  }

  @override
  String toString() =>
      'DatabaseCreationResult(isSuccess: $isSuccess, '
      'filePath: $filePath, description: $description)';
}
