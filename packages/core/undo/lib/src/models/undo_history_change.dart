import 'package:meta/meta.dart';
import '../commands/undoable_command.dart';

/// Represents a change in the undo history.
///
/// Used to notify listeners when the undo/redo stacks change.
@immutable
abstract class UndoHistoryChange {
  /// Timestamp when this change occurred.
  final DateTime timestamp;

  const UndoHistoryChange(this.timestamp);
}

/// A command was executed and added to the undo stack.
@immutable
class CommandExecuted extends UndoHistoryChange {
  /// The command that was executed.
  final UndoableCommand command;

  CommandExecuted(this.command) : super(DateTime.now());

  @override
  String toString() => 'CommandExecuted(${command.description})';
}

/// A command was undone.
@immutable
class CommandUndone extends UndoHistoryChange {
  /// The command that was undone.
  final UndoableCommand command;

  CommandUndone(this.command) : super(DateTime.now());

  @override
  String toString() => 'CommandUndone(${command.description})';
}

/// A command was redone.
@immutable
class CommandRedone extends UndoHistoryChange {
  /// The command that was redone.
  final UndoableCommand command;

  CommandRedone(this.command) : super(DateTime.now());

  @override
  String toString() => 'CommandRedone(${command.description})';
}

/// Two commands were merged in the history.
@immutable
class CommandsMerged extends UndoHistoryChange {
  /// The original command that was replaced.
  final UndoableCommand originalCommand;

  /// The new command that was merged with the original.
  final UndoableCommand newCommand;

  /// The resulting merged command.
  final UndoableCommand mergedCommand;

  CommandsMerged(this.originalCommand, this.newCommand, this.mergedCommand)
    : super(DateTime.now());

  @override
  String toString() =>
      'CommandsMerged(${originalCommand.description} + ${newCommand.description})';
}

/// The undo history was cleared.
@immutable
class HistoryCleared extends UndoHistoryChange {
  /// Number of commands that were cleared from undo stack.
  final int undoCount;

  /// Number of commands that were cleared from redo stack.
  final int redoCount;

  HistoryCleared({required this.undoCount, required this.redoCount})
    : super(DateTime.now());

  @override
  String toString() => 'HistoryCleared(undo: $undoCount, redo: $redoCount)';
}

/// Commands were pruned from history due to memory limits.
@immutable
class HistoryPruned extends UndoHistoryChange {
  /// Number of commands that were pruned.
  final int prunedCount;

  /// Memory usage before pruning (in bytes).
  final int memoryBeforePruning;

  /// Memory usage after pruning (in bytes).
  final int memoryAfterPruning;

  HistoryPruned({
    required this.prunedCount,
    required this.memoryBeforePruning,
    required this.memoryAfterPruning,
  }) : super(DateTime.now());

  @override
  String toString() =>
      'HistoryPruned($prunedCount commands, ${memoryBeforePruning - memoryAfterPruning} bytes freed)';
}
