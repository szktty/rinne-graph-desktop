/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import '../exceptions/database_exceptions.dart';

/// Database validation result.
class DatabaseValidationResult {
  final bool isSuccess;
  final String filePath;
  final bool isValid;
  final bool isInitialized;
  final String? message;
  final DatabaseValidationException? error;

  const DatabaseValidationResult._({
    required this.isSuccess,
    required this.filePath,
    required this.isValid,
    required this.isInitialized,
    this.message,
    this.error,
  });

  factory DatabaseValidationResult.success({
    required String filePath,
    String? message,
  }) {
    return DatabaseValidationResult._(
      isSuccess: true,
      filePath: filePath,
      isValid: true,
      isInitialized: true,
      message: message,
    );
  }

  factory DatabaseValidationResult.error({
    required String filePath,
    required DatabaseValidationException error,
  }) {
    return DatabaseValidationResult._(
      isSuccess: false,
      filePath: filePath,
      isValid: false,
      isInitialized: false,
      error: error,
    );
  }

  String get description {
    if (!isSuccess) return error?.message ?? 'Validation failed';
    return message ?? 'Database is valid';
  }

  @override
  String toString() =>
      'DatabaseValidationResult(isSuccess: $isSuccess, '
      'filePath: $filePath, isValid: $isValid)';
}
