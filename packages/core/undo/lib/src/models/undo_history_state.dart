/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:meta/meta.dart';
import '../commands/undoable_command.dart';

/// State of the undo history for UI display.
///
/// Contains information about available undo/redo commands and
/// the current state of the history.
@immutable
class UndoHistoryState {
  /// List of commands that can be undone (most recent first).
  final List<UndoableCommand> undoCommands;

  /// List of commands that can be redone (most recent first).
  final List<UndoableCommand> redoCommands;

  /// Whether undo is currently available.
  final bool canUndo;

  /// Whether redo is currently available.
  final bool canRedo;

  /// Current memory usage of the undo history in bytes.
  final int memoryUsage;

  /// Maximum allowed memory usage in bytes.
  final int maxMemoryUsage;

  /// Current number of commands in history.
  final int historySize;

  /// Maximum allowed history size.
  final int maxHistorySize;

  const UndoHistoryState({
    required this.undoCommands,
    required this.redoCommands,
    required this.canUndo,
    required this.canRedo,
    required this.memoryUsage,
    required this.maxMemoryUsage,
    required this.historySize,
    required this.maxHistorySize,
  });

  /// Create an empty state with no history.
  const UndoHistoryState.empty({
    int maxMemoryUsage = 50 * 1024 * 1024, // 50MB
    int maxHistorySize = 100,
  }) : undoCommands = const [],
       redoCommands = const [],
       canUndo = false,
       canRedo = false,
       memoryUsage = 0,
       maxMemoryUsage = maxMemoryUsage,
       historySize = 0,
       maxHistorySize = maxHistorySize;

  /// Total number of commands in both stacks.
  int get totalCommands => undoCommands.length + redoCommands.length;

  /// Memory usage as a percentage of the maximum.
  double get memoryUsagePercentage =>
      maxMemoryUsage > 0 ? (memoryUsage / maxMemoryUsage) * 100 : 0;

  /// History size as a percentage of the maximum.
  double get historySizePercentage =>
      maxHistorySize > 0 ? (historySize / maxHistorySize) * 100 : 0;

  /// Whether the memory usage is near the limit (> 80%).
  bool get isMemoryUsageHigh => memoryUsagePercentage > 80;

  /// Whether the history size is near the limit (> 80%).
  bool get isHistorySizeHigh => historySizePercentage > 80;

  /// Get the next command that would be undone.
  UndoableCommand? get nextUndoCommand =>
      undoCommands.isNotEmpty ? undoCommands.first : null;

  /// Get the next command that would be redone.
  UndoableCommand? get nextRedoCommand =>
      redoCommands.isNotEmpty ? redoCommands.first : null;

  /// Create a copy with updated values.
  UndoHistoryState copyWith({
    List<UndoableCommand>? undoCommands,
    List<UndoableCommand>? redoCommands,
    bool? canUndo,
    bool? canRedo,
    int? memoryUsage,
    int? maxMemoryUsage,
    int? historySize,
    int? maxHistorySize,
  }) {
    return UndoHistoryState(
      undoCommands: undoCommands ?? this.undoCommands,
      redoCommands: redoCommands ?? this.redoCommands,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      maxMemoryUsage: maxMemoryUsage ?? this.maxMemoryUsage,
      historySize: historySize ?? this.historySize,
      maxHistorySize: maxHistorySize ?? this.maxHistorySize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UndoHistoryState &&
          runtimeType == other.runtimeType &&
          undoCommands == other.undoCommands &&
          redoCommands == other.redoCommands &&
          canUndo == other.canUndo &&
          canRedo == other.canRedo &&
          memoryUsage == other.memoryUsage &&
          maxMemoryUsage == other.maxMemoryUsage &&
          historySize == other.historySize &&
          maxHistorySize == other.maxHistorySize;

  @override
  int get hashCode => Object.hash(
    undoCommands,
    redoCommands,
    canUndo,
    canRedo,
    memoryUsage,
    maxMemoryUsage,
    historySize,
    maxHistorySize,
  );

  @override
  String toString() =>
      'UndoHistoryState('
      'undo: ${undoCommands.length}, '
      'redo: ${redoCommands.length}, '
      'memory: ${(memoryUsage / 1024).toStringAsFixed(1)}KB/'
      '${(maxMemoryUsage / 1024).toStringAsFixed(1)}KB)';
}
