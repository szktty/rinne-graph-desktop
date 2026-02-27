/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Standard vocabulary for command return codes (fixed)
///
/// - OK: Normal termination
/// - BAD_PARAMS: Invalid parameters (missing, type mismatch, etc.)
/// - NOT_FOUND: Target or resource does not exist
/// - COMMAND_ERROR: Internal app exception/business error during execution
class CommandResultCode {
  static const ok = 'OK';
  static const badParams = 'BAD_PARAMS';
  static const notFound = 'NOT_FOUND';
  static const commandError = 'COMMAND_ERROR';
}
