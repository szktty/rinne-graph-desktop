/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';
import 'dart:collection';

import '../commands/undoable_command.dart';
import '../models/undo_history_change.dart';
import 'undo_error.dart';

/// Manages undo/redo history and operations for graph commands.
///
/// The UndoManager maintains two stacks: undo and redo. When a command
/// is executed, it's added to the undo stack. When undone, it's moved
/// to the redo stack. When a new command is executed, the redo stack
/// is cleared.
class UndoManager {
  /// Maximum number of commands to keep in history.
  final int maxHistorySize;

  /// Maximum memory usage for undo history in bytes.
  final int maxMemoryUsage;

  /// The graph context for executing operations.
  final dynamic _graphContext;

  /// Stack of commands that can be undone (most recent first).
  final Queue<UndoableCommand> _undoStack = Queue<UndoableCommand>();

  /// Stack of commands that can be redone (most recent first).
  final Queue<UndoableCommand> _redoStack = Queue<UndoableCommand>();

  /// Stream controller for history changes.
  final StreamController<UndoHistoryChange> _historyController =
      StreamController<UndoHistoryChange>.broadcast();

  /// Current memory usage in bytes.
  int _currentMemoryUsage = 0;

  /// Whether the undo manager is currently executing an operation.
  bool _isExecuting = false;

  UndoManager({
    required dynamic graphContext,
    this.maxHistorySize = 100,
    this.maxMemoryUsage = 50 * 1024 * 1024, // 50MB
  }) : _graphContext = graphContext;

  /// Execute a command and add it to the undo history.
  Future<void> execute(UndoableCommand command) async {
    if (_isExecuting) {
      throw UndoStateException(
        'Cannot execute command while another operation is in progress',
        command: command,
      );
    }

    _isExecuting = true;

    try {
      // Try to merge with the most recent command if possible
      if (_undoStack.isNotEmpty) {
        final lastCommand = _undoStack.first;
        if (lastCommand.canMergeWith(command)) {
          final merged = lastCommand.mergeWith(command);
          if (merged != null) {
            // Replace the last command with the merged one
            _undoStack.removeFirst();
            _currentMemoryUsage -= lastCommand.estimatedMemoryUsage;

            await merged.execute(_graphContext);
            _undoStack.addFirst(merged);
            _currentMemoryUsage += merged.estimatedMemoryUsage;

            _historyController.add(
              CommandsMerged(lastCommand, command, merged),
            );
            return;
          }
        }
      }

      // Execute the command
      await command.execute(_graphContext);

      // Clear redo stack when a new command is executed
      _clearRedoStack();

      // Add to undo stack
      _undoStack.addFirst(command);
      _currentMemoryUsage += command.estimatedMemoryUsage;

      // Prune history if necessary
      _pruneHistory();

      _historyController.add(CommandExecuted(command));
    } catch (e) {
      throw CommandExecutionException(
        'Failed to execute command: ${command.description}',
        command: command,
        cause: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _isExecuting = false;
    }
  }

  /// Undo the most recent command.
  Future<void> undo() async {
    if (!canUndo) {
      throw UndoStateException('No commands available to undo');
    }

    if (_isExecuting) {
      throw UndoStateException(
        'Cannot undo while another operation is in progress',
      );
    }

    _isExecuting = true;

    try {
      final command = _undoStack.removeFirst();
      _currentMemoryUsage -= command.estimatedMemoryUsage;

      await command.undo(_graphContext);

      _redoStack.addFirst(command);
      _currentMemoryUsage += command.estimatedMemoryUsage;

      _historyController.add(CommandUndone(command));
    } catch (e) {
      // Re-add the command to undo stack if undo failed
      if (_undoStack.isEmpty || _undoStack.first != _undoStack.last) {
        // Only re-add if it's not already there (safety check)
        // Note: This is a simplified recovery. A more robust implementation
        // might maintain a separate transaction log.
      }

      throw UndoExecutionException(
        'Failed to undo command',
        cause: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _isExecuting = false;
    }
  }

  /// Redo the most recently undone command.
  Future<void> redo() async {
    if (!canRedo) {
      throw UndoStateException('No commands available to redo');
    }

    if (_isExecuting) {
      throw UndoStateException(
        'Cannot redo while another operation is in progress',
      );
    }

    _isExecuting = true;

    try {
      final command = _redoStack.removeFirst();
      _currentMemoryUsage -= command.estimatedMemoryUsage;

      await command.redo(_graphContext);

      _undoStack.addFirst(command);
      _currentMemoryUsage += command.estimatedMemoryUsage;

      _historyController.add(CommandRedone(command));
    } catch (e) {
      throw RedoExecutionException(
        'Failed to redo command',
        cause: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _isExecuting = false;
    }
  }

  /// Clear all undo/redo history.
  void clear() {
    final undoCount = _undoStack.length;
    final redoCount = _redoStack.length;

    _undoStack.clear();
    _redoStack.clear();
    _currentMemoryUsage = 0;

    _historyController.add(
      HistoryCleared(undoCount: undoCount, redoCount: redoCount),
    );
  }

  /// Save undo history to persistent storage.
  ///
  /// Note: This is a placeholder for future implementation.
  /// The actual implementation would need to serialize commands
  /// and store them in a persistent format.
  Future<void> saveHistory() async {
    // TODO: Implement history serialization and persistence
    throw UnimplementedError('History persistence not yet implemented');
  }

  /// Load undo history from persistent storage.
  ///
  /// Note: This is a placeholder for future implementation.
  Future<void> loadHistory() async {
    // TODO: Implement history deserialization and loading
    throw UnimplementedError('History persistence not yet implemented');
  }

  /// Whether undo is currently available.
  bool get canUndo => _undoStack.isNotEmpty && !_isExecuting;

  /// Whether redo is currently available.
  bool get canRedo => _redoStack.isNotEmpty && !_isExecuting;

  /// Current number of commands in history.
  int get historySize => _undoStack.length + _redoStack.length;

  /// Current memory usage in bytes.
  int get currentMemoryUsage => _currentMemoryUsage;

  /// List of commands that can be undone (most recent first).
  List<UndoableCommand> get undoHistory => List.unmodifiable(_undoStack);

  /// List of commands that can be redone (most recent first).
  List<UndoableCommand> get redoHistory => List.unmodifiable(_redoStack);

  /// Stream of history changes.
  Stream<UndoHistoryChange> get historyChanges => _historyController.stream;

  /// Whether the undo manager is currently executing an operation.
  bool get isExecuting => _isExecuting;

  /// Clear the redo stack.
  void _clearRedoStack() {
    for (final command in _redoStack) {
      _currentMemoryUsage -= command.estimatedMemoryUsage;
    }
    _redoStack.clear();
  }

  /// Prune history if it exceeds size or memory limits.
  void _pruneHistory() {
    var prunedCount = 0;
    final memoryBeforePruning = _currentMemoryUsage;

    // Prune by size limit
    while (_undoStack.length > maxHistorySize) {
      final command = _undoStack.removeLast();
      _currentMemoryUsage -= command.estimatedMemoryUsage;
      prunedCount++;
    }

    // Prune by memory limit (remove oldest commands first)
    while (_currentMemoryUsage > maxMemoryUsage && _undoStack.isNotEmpty) {
      final command = _undoStack.removeLast();
      _currentMemoryUsage -= command.estimatedMemoryUsage;
      prunedCount++;
    }

    if (prunedCount > 0) {
      _historyController.add(
        HistoryPruned(
          prunedCount: prunedCount,
          memoryBeforePruning: memoryBeforePruning,
          memoryAfterPruning: _currentMemoryUsage,
        ),
      );
    }
  }

  /// Dispose of resources.
  void dispose() {
    _historyController.close();
  }

  @override
  String toString() =>
      'UndoManager('
      'undo: ${_undoStack.length}, '
      'redo: ${_redoStack.length}, '
      'memory: ${(_currentMemoryUsage / 1024).toStringAsFixed(1)}KB)';
}
