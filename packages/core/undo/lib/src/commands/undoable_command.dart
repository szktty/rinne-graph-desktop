/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';
import 'package:core_graph_flutter/core_graph.dart';

/// Base interface for all undoable commands in the App graph system.
///
/// Commands represent atomic operations that can be executed, undone, and redone.
/// They integrate with the RinneGraph database through [GraphContext] and
/// support optimization through merging and memory estimation.
@immutable
abstract class UndoableCommand {
  /// Unique identifier for this command type.
  /// Used for serialization and command categorization.
  String get id;

  /// Human-readable description for UI display.
  /// Should be localized and meaningful to users.
  String get description;

  /// Timestamp when this command was created.
  DateTime get timestamp;

  /// Execute this command against the graph.
  ///
  /// This method should perform the forward operation and may store
  /// necessary state for later undo operations.
  Future<void> execute(dynamic context);

  /// Undo the effects of this command.
  ///
  /// This method should restore the graph to the state it was in
  /// before [execute] was called.
  Future<void> undo(dynamic context);

  /// Redo this command.
  ///
  /// By default, this calls [execute], but implementations may optimize
  /// this for performance when the command has already been executed once.
  Future<void> redo(dynamic context) => execute(context);

  /// Check if this command can be merged with another command.
  ///
  /// Commands can be merged to optimize undo history and reduce memory usage.
  /// Common examples include:
  /// - Sequential property updates on the same entity
  /// - Rapid position changes during drag operations
  ///
  /// Returns `true` if the commands can be merged.
  bool canMergeWith(UndoableCommand other);

  /// Merge this command with another command.
  ///
  /// This should only be called if [canMergeWith] returns `true`.
  /// Returns a new command that represents the combined effect of both commands,
  /// or `null` if merging fails.
  UndoableCommand? mergeWith(UndoableCommand other);

  /// Estimated memory usage of this command in bytes.
  ///
  /// Used by the undo manager to enforce memory limits and optimize
  /// history management. This should include the size of any stored
  /// state needed for undo operations.
  int get estimatedMemoryUsage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UndoableCommand &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(id, timestamp);

  @override
  String toString() => 'UndoableCommand(id: $id, description: $description)';
}

/// Base implementation for commands that cannot be merged.
///
/// Provides default implementations for merge-related methods.
abstract class NonMergeableCommand extends UndoableCommand {
  @override
  bool canMergeWith(UndoableCommand other) => false;

  @override
  UndoableCommand? mergeWith(UndoableCommand other) => null;
}

/// Base implementation for commands that can be merged with similar commands.
///
/// Provides a framework for implementing mergeable commands with common
/// merge logic.
abstract class MergeableCommand extends UndoableCommand {
  /// Time window in seconds within which commands can be merged.
  /// Default is 2 seconds.
  int get mergeTimeWindowSeconds => 2;

  /// Check if the other command is of the same type and within merge window.
  @protected
  bool canMergeWithBase(UndoableCommand other) {
    if (other.runtimeType != runtimeType) return false;

    final timeDiff = other.timestamp.difference(timestamp).inSeconds.abs();
    return timeDiff <= mergeTimeWindowSeconds;
  }

  /// Additional merge criteria specific to the command type.
  ///
  /// Subclasses should override this to add type-specific merge logic.
  @protected
  bool canMergeWithSpecific(covariant UndoableCommand other);

  @override
  bool canMergeWith(UndoableCommand other) =>
      canMergeWithBase(other) && canMergeWithSpecific(other);
}
