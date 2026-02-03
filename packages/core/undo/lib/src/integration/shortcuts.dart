import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'actions.dart';

/// Widget that wraps its child with undo/redo shortcuts and actions.
///
/// This widget provides keyboard shortcuts for undo/redo operations
/// and integrates with the undo system through Riverpod providers.
class UndoShortcuts extends ConsumerWidget {
  /// The child widget to wrap with undo/redo functionality.
  final Widget child;

  /// Whether to enable undo/redo shortcuts.
  final bool enabled;

  const UndoShortcuts({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) {
      return child;
    }

    final undoActions = ref.watch(undoActionsProvider);

    return Shortcuts(
      shortcuts: _createShortcuts(),
      child: Actions(actions: _createActions(undoActions), child: child),
    );
  }

  /// Create platform-appropriate shortcuts for undo/redo.
  Map<LogicalKeySet, Intent> _createShortcuts() {
    return UndoShortcutsHelper.shortcuts;
  }

  /// Create actions for undo/redo operations.
  Map<Type, Action<Intent>> _createActions(dynamic undoActions) {
    return UndoActionsHelper.createActions(
      onUndo: undoActions.canUndo ? () => undoActions.undo() : null,
      onRedo: undoActions.canRedo ? () => undoActions.redo() : null,
      onClear: () => undoActions.clear(),
      canUndo: undoActions.canUndo,
      canRedo: undoActions.canRedo,
    );
  }
}

/// Widget that provides undo/redo functionality through menu bar integration.
///
/// This widget is designed to be used with macOS PlatformMenuBar or similar
/// menu systems to provide undo/redo menu items.
class UndoMenuIntegration extends ConsumerWidget {
  /// Builder function that receives undo actions and returns menu items.
  final Widget Function(BuildContext context, dynamic undoActions) builder;

  const UndoMenuIntegration({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final undoActions = ref.watch(undoActionsProvider);
    return builder(context, undoActions);
  }
}

/// Helper class for creating platform-specific undo/redo shortcuts.
class UndoShortcutsHelper {
  /// Get the primary modifier key for the current platform.
  static LogicalKeyboardKey get primaryModifierKey {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return LogicalKeyboardKey.meta;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return LogicalKeyboardKey.control;
      default:
        return LogicalKeyboardKey.control;
    }
  }

  /// Create undo shortcut for the current platform.
  static LogicalKeySet createUndoShortcut() {
    return LogicalKeySet(primaryModifierKey, LogicalKeyboardKey.keyZ);
  }

  /// Create redo shortcut for the current platform.
  static LogicalKeySet createRedoShortcut() {
    return LogicalKeySet(
      primaryModifierKey,
      LogicalKeyboardKey.shift,
      LogicalKeyboardKey.keyZ,
    );
  }

  /// Create alternative redo shortcut (Ctrl+Y / Cmd+Y).
  static LogicalKeySet createRedoAlternativeShortcut() {
    return LogicalKeySet(primaryModifierKey, LogicalKeyboardKey.keyY);
  }

  /// Get all standard undo/redo shortcuts.
  static Map<LogicalKeySet, Intent> get shortcuts => {
    createUndoShortcut(): const UndoIntent(),
    createRedoShortcut(): const RedoIntent(),
    createRedoAlternativeShortcut(): const RedoIntent(),
  };
}

/// Widget that provides a button for undo operations.
class UndoButton extends StatelessWidget {
  /// Optional custom icon for the undo button.
  final IconData? icon;

  /// Optional tooltip text.
  final String? tooltip;

  /// Optional custom onPressed callback.
  final VoidCallback? onPressed;

  const UndoButton({super.key, this.icon, this.tooltip, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon ?? Icons.undo),
      tooltip: tooltip ?? 'Undo',
      onPressed: onPressed,
    );
  }
}

/// Widget that provides a button for redo operations.
class RedoButton extends StatelessWidget {
  /// Optional custom icon for the redo button.
  final IconData? icon;

  /// Optional tooltip text.
  final String? tooltip;

  /// Optional custom onPressed callback.
  final VoidCallback? onPressed;

  const RedoButton({super.key, this.icon, this.tooltip, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon ?? Icons.redo),
      tooltip: tooltip ?? 'Redo',
      onPressed: onPressed,
    );
  }
}

/// Widget that displays the current undo history state.
///
/// This can be used in status bars or debug panels to show
/// information about the undo system state.
class UndoHistoryIndicator extends StatelessWidget {
  /// Whether to show detailed information.
  final bool showDetails;

  /// Undo commands count
  final int undoCount;

  /// Redo commands count
  final int redoCount;

  /// Memory usage in bytes
  final int memoryUsage;

  const UndoHistoryIndicator({
    super.key,
    this.showDetails = false,
    this.undoCount = 0,
    this.redoCount = 0,
    this.memoryUsage = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (!showDetails) {
      return Text(
        '$undoCount/$redoCount',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Undo: $undoCount', style: Theme.of(context).textTheme.bodySmall),
        Text('Redo: $redoCount', style: Theme.of(context).textTheme.bodySmall),
        Text(
          'Memory: ${(memoryUsage / 1024).toStringAsFixed(1)}KB',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
