import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Intent for undo action in the Flutter Actions/Shortcuts system.
class UndoIntent extends Intent {
  const UndoIntent();
}

/// Intent for redo action in the Flutter Actions/Shortcuts system.
class RedoIntent extends Intent {
  const RedoIntent();
}

/// Intent for clearing undo history.
class ClearUndoHistoryIntent extends Intent {
  const ClearUndoHistoryIntent();
}

/// Action that handles undo operations.
class UndoAction extends Action<UndoIntent> {
  /// Function to execute when undo is invoked.
  final VoidCallback? onUndo;

  /// Whether undo is currently available.
  final bool canUndo;

  UndoAction({required this.onUndo, required this.canUndo});

  @override
  bool isEnabled(UndoIntent intent) => canUndo && onUndo != null;

  @override
  void invoke(UndoIntent intent) {
    if (isEnabled(intent)) {
      onUndo?.call();
    }
  }
}

/// Action that handles redo operations.
class RedoAction extends Action<RedoIntent> {
  /// Function to execute when redo is invoked.
  final VoidCallback? onRedo;

  /// Whether redo is currently available.
  final bool canRedo;

  RedoAction({required this.onRedo, required this.canRedo});

  @override
  bool isEnabled(RedoIntent intent) => canRedo && onRedo != null;

  @override
  void invoke(RedoIntent intent) {
    if (isEnabled(intent)) {
      onRedo?.call();
    }
  }
}

/// Action that handles clearing undo history.
class ClearUndoHistoryAction extends Action<ClearUndoHistoryIntent> {
  /// Function to execute when clear is invoked.
  final VoidCallback? onClear;

  ClearUndoHistoryAction({required this.onClear});

  @override
  bool isEnabled(ClearUndoHistoryIntent intent) => onClear != null;

  @override
  void invoke(ClearUndoHistoryIntent intent) {
    if (isEnabled(intent)) {
      onClear?.call();
    }
  }
}

/// Helper class to create standard undo/redo shortcuts for different platforms.
class UndoShortcutsConstants {
  /// Standard undo shortcut for the current platform.
  static LogicalKeySet get undo {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ);
    } else {
      return LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ);
    }
  }

  /// Standard redo shortcut for the current platform.
  static LogicalKeySet get redo {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return LogicalKeySet(
        LogicalKeyboardKey.meta,
        LogicalKeyboardKey.shift,
        LogicalKeyboardKey.keyZ,
      );
    } else {
      return LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.shift,
        LogicalKeyboardKey.keyZ,
      );
    }
  }

  /// Alternative redo shortcut (Ctrl+Y on Windows/Linux, Cmd+Y on Mac).
  static LogicalKeySet get redoAlternative {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyY);
    } else {
      return LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyY);
    }
  }

  /// Get all undo/redo shortcuts as a map for use with Flutter's Shortcuts widget.
  static Map<LogicalKeySet, Intent> get shortcuts => {
    undo: const UndoIntent(),
    redo: const RedoIntent(),
    redoAlternative: const RedoIntent(),
  };
}

/// Helper class to create actions map for use with Flutter's Actions widget.
class UndoActionsHelper {
  /// Create an actions map for undo/redo functionality.
  static Map<Type, Action<Intent>> createActions({
    required VoidCallback? onUndo,
    required VoidCallback? onRedo,
    required VoidCallback? onClear,
    required bool canUndo,
    required bool canRedo,
  }) {
    return {
      UndoIntent: UndoAction(onUndo: onUndo, canUndo: canUndo),
      RedoIntent: RedoAction(onRedo: onRedo, canRedo: canRedo),
      ClearUndoHistoryIntent: ClearUndoHistoryAction(onClear: onClear),
    };
  }
}
