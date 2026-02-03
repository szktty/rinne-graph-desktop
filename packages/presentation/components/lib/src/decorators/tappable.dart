import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Decorator for managing tap events.
///
/// Wraps widgets like AppCard to provide tap functionality.
/// By adopting the decorator pattern, tap functionality is separated from other
/// components, improving reusability.
///
/// Similar to the existing SelectableCard, it implements custom double-tap
/// detection and avoids single-tap delays.
///
/// Usage example:
/// ```dart
/// Tappable(
///   onTap: () => print('Tapped'),
///   onDoubleTap: () => print('Double Tapped'),
///   child: AppCard(
///     child: Text('Tappable Card'),
///   ),
/// )
/// ```
class Tappable extends StatefulWidget {
  /// The child widget.
  final Widget child;

  /// Callback for when a tap occurs.
  final VoidCallback? onTap;

  /// Callback for when a double tap occurs.
  final VoidCallback? onDoubleTap;

  /// Callback for when a long press occurs.
  final VoidCallback? onLongPress;

  /// Callback for when a tap down occurs (called immediately).
  final VoidCallback? onTapDown;

  /// Callback for when a hover occurs.
  final ValueChanged<bool>? onHover;

  /// The cursor type.
  final MouseCursor cursor;

  /// Whether to disable the tap animation.
  final bool disableInkWell;

  /// The splash color (transparent if null).
  final Color? splashColor;

  /// The highlight color (transparent if null).
  final Color? highlightColor;

  const Tappable({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onHover,
    this.cursor = SystemMouseCursors.click,
    this.disableInkWell = true,
    this.splashColor,
    this.highlightColor,
  });

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    // Manage hover state
    if (widget.onHover != null) {
      result = MouseRegion(
        cursor: widget.cursor,
        onEnter: (_) => widget.onHover!(true),
        onExit: (_) => widget.onHover!(false),
        child: result,
      );
    } else if (widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onLongPress != null) {
      result = MouseRegion(cursor: widget.cursor, child: result);
    }

    // Handle tap events
    if (widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onLongPress != null ||
        widget.onTapDown != null) {
      if (widget.disableInkWell) {
        // When not using InkWell (animation disabled)
        result = GestureDetector(
          onTapDown:
              widget.onTapDown != null ? (_) => widget.onTapDown!() : null,
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          child: result,
        );
      } else {
        // When using InkWell (animation enabled)
        result = InkWell(
          onTapDown:
              widget.onTapDown != null ? (_) => widget.onTapDown!() : null,
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          splashColor: widget.splashColor ?? Colors.transparent,
          highlightColor: widget.highlightColor ?? Colors.transparent,
          child: result,
        );
      }
    }

    return result;
  }

  void _handleTap() {
    if (widget.onDoubleTap != null) {
      // Double-tap detection logic (same as SelectableCard)
      final now = DateTime.now();
      final isDoubleTap =
          _lastTapTime != null &&
          now.difference(_lastTapTime!) < kDoubleTapTimeout;

      if (isDoubleTap) {
        widget.onDoubleTap!();
        _lastTapTime = null;
      } else {
        widget.onTap?.call();
        _lastTapTime = now;
      }
    } else {
      // For single taps only
      widget.onTap?.call();
    }
  }
}

/// Mixin for tappable items.
///
/// Can be used to implement tap functionality in a StatefulWidget.
mixin TappableMixin<T extends StatefulWidget> on State<T> {
  DateTime? _lastTapTime;

  /// Custom double-tap detection.
  void handleTap({VoidCallback? onTap, VoidCallback? onDoubleTap}) {
    if (onDoubleTap != null) {
      final now = DateTime.now();
      final isDoubleTap =
          _lastTapTime != null &&
          now.difference(_lastTapTime!) < kDoubleTapTimeout;

      if (isDoubleTap) {
        onDoubleTap();
        _lastTapTime = null;
      } else {
        onTap?.call();
        _lastTapTime = now;
      }
    } else {
      onTap?.call();
    }
  }
}
