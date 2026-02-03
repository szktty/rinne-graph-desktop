import 'package:meta/meta.dart';

/// Actions available for undo/redo operations.
///
/// This class encapsulates the available undo/redo actions and their
/// current state for use in UI components.
@immutable
class UndoActions {
  /// Whether undo is currently possible.
  final bool canUndo;

  /// Whether redo is currently possible.
  final bool canRedo;

  /// Function to execute undo operation.
  final Future<void> Function() undo;

  /// Function to execute redo operation.
  final Future<void> Function() redo;

  /// Function to clear all undo/redo history.
  final void Function() clear;

  /// Optional function to save history to persistent storage.
  final Future<void> Function()? saveHistory;

  /// Optional function to load history from persistent storage.
  final Future<void> Function()? loadHistory;

  const UndoActions({
    required this.canUndo,
    required this.canRedo,
    required this.undo,
    required this.redo,
    required this.clear,
    this.saveHistory,
    this.loadHistory,
  });

  /// Create a disabled state with no available actions.
  const UndoActions.disabled()
    : canUndo = false,
      canRedo = false,
      undo = _noOpAsync,
      redo = _noOpAsync,
      clear = _noOp,
      saveHistory = null,
      loadHistory = null;

  /// Create a copy with updated state.
  UndoActions copyWith({
    bool? canUndo,
    bool? canRedo,
    Future<void> Function()? undo,
    Future<void> Function()? redo,
    void Function()? clear,
    Future<void> Function()? saveHistory,
    Future<void> Function()? loadHistory,
  }) {
    return UndoActions(
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      undo: undo ?? this.undo,
      redo: redo ?? this.redo,
      clear: clear ?? this.clear,
      saveHistory: saveHistory ?? this.saveHistory,
      loadHistory: loadHistory ?? this.loadHistory,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UndoActions &&
          runtimeType == other.runtimeType &&
          canUndo == other.canUndo &&
          canRedo == other.canRedo;

  @override
  int get hashCode => Object.hash(canUndo, canRedo);

  @override
  String toString() => 'UndoActions(canUndo: $canUndo, canRedo: $canRedo)';

  static Future<void> _noOpAsync() async {}
  static void _noOp() {}
}
