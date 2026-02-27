/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';
import '../commands/undoable_command.dart';

/// Base exception for undo system errors.
@immutable
abstract class UndoException implements Exception {
  /// Human-readable error message.
  final String message;

  /// The command that caused the error, if any.
  final UndoableCommand? command;

  /// Underlying cause of the error, if any.
  final Exception? cause;

  const UndoException(this.message, {this.command, this.cause});

  @override
  String toString() => 'UndoException: $message';
}

/// Exception thrown when a command execution fails.
class CommandExecutionException extends UndoException {
  const CommandExecutionException(super.message, {super.command, super.cause});

  @override
  String toString() => 'CommandExecutionException: $message';
}

/// Exception thrown when an undo operation fails.
class UndoExecutionException extends UndoException {
  const UndoExecutionException(super.message, {super.command, super.cause});

  @override
  String toString() => 'UndoExecutionException: $message';
}

/// Exception thrown when a redo operation fails.
class RedoExecutionException extends UndoException {
  const RedoExecutionException(super.message, {super.command, super.cause});

  @override
  String toString() => 'RedoExecutionException: $message';
}

/// Exception thrown when trying to merge incompatible commands.
class CommandMergeException extends UndoException {
  /// The other command that merge was attempted with.
  final UndoableCommand? otherCommand;

  const CommandMergeException(
    super.message, {
    super.command,
    this.otherCommand,
    super.cause,
  });

  @override
  String toString() => 'CommandMergeException: $message';
}

/// Exception thrown when undo manager reaches limits (memory, history size).
class UndoLimitException extends UndoException {
  /// The type of limit that was exceeded.
  final UndoLimitType limitType;

  /// The current value that exceeded the limit.
  final int currentValue;

  /// The maximum allowed value.
  final int maxValue;

  const UndoLimitException(
    super.message,
    this.limitType,
    this.currentValue,
    this.maxValue, {
    super.command,
    super.cause,
  });

  @override
  String toString() =>
      'UndoLimitException: $message (${limitType.name}: $currentValue > $maxValue)';
}

/// Types of limits that can be exceeded in the undo system.
enum UndoLimitType {
  /// Maximum number of commands in history.
  historySize,

  /// Maximum memory usage for undo history.
  memoryUsage,
}

/// Exception thrown when the undo system is in an invalid state.
class UndoStateException extends UndoException {
  const UndoStateException(super.message, {super.command, super.cause});

  @override
  String toString() => 'UndoStateException: $message';
}
