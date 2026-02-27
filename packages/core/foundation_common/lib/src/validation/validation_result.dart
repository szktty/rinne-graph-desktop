/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';

/// Class representing validation result
///
/// Holds the validation result and error message (if any).
@immutable
class ValidationResult {
  const ValidationResult({required this.isValid, this.error, this.kind});

  /// Whether validation succeeded
  final bool isValid;

  /// Error message (valid only on failure)
  final String? error;

  /// Error type (valid only on failure)
  final ValidationResultKind? kind;

  /// Creates a success result
  static const success = ValidationResult(isValid: true);

  /// Creates an error result
  const ValidationResult.error(this.error, {this.kind}) : isValid = false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationResult &&
        other.isValid == isValid &&
        other.error == error &&
        other.kind == kind;
  }

  @override
  int get hashCode => Object.hash(isValid, error, kind);

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult.success()';
    } else {
      return 'ValidationResult.error(error: $error, kind: $kind)';
    }
  }
}

enum ValidationResultKind { typeError, constraintError, otherError }
