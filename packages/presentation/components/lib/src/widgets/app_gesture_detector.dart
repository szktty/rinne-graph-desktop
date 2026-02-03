import 'dart:async';
import 'package:flutter/material.dart';

/// A function that returns the current time.
/// This allows for dependency injection and easier testing.
typedef TimeProvider = DateTime Function();

/// A custom gesture detector that distinguishes between single and double taps
/// without the delay inherent in the default GestureDetector when both are used.
///
/// This widget provides proper single/double tap handling by using a timer-based
/// approach that prevents the execution of both callbacks for a double tap.
///
/// ## Behavior
///
/// ### Single Tap Only
/// When only [onTap] is provided, it's called immediately without delay:
/// ```dart
/// AppGestureDetector(
///   onTap: () => print('Single tap!'),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ### Double Tap Only
/// When only [onDoubleTap] is provided, it requires two taps within [doubleTapTimeout]:
/// ```dart
/// AppGestureDetector(
///   onDoubleTap: () => print('Double tap!'),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ### Both Single and Double Tap
/// When both callbacks are provided, the behavior depends on whether [onTapCancel] is provided:
///
/// **With onTapCancel (immediate response):**
/// [onTap] is called immediately for responsive UI. If a double tap occurs,
/// [onTapCancel] undoes the single tap effect, then [onDoubleTap] is executed:
/// ```dart
/// bool isSelected = false;
///
/// AppGestureDetector(
///   onTap: () => setState(() => isSelected = true),
///   onTapCancel: () => setState(() => isSelected = false),
///   onDoubleTap: () => openItem(),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// **Without onTapCancel (delayed response):**
/// [onTap] is delayed by [doubleTapTimeout]. If a double tap occurs,
/// only [onDoubleTap] is called:
/// ```dart
/// AppGestureDetector(
///   onTap: () => selectItem(),
///   onDoubleTap: () => openItem(),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ### Tap Down/Up Events
/// For debugging or immediate visual feedback, you can use [onTapDown] and [onTapUp]:
/// ```dart
/// AppGestureDetector(
///   onTapDown: (details) => print('Tap started at ${details.localPosition}'),
///   onTapUp: (details) => print('Tap ended at ${details.localPosition}'),
///   onTap: () => print('Single tap confirmed'),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ## Performance Features
/// - Automatically optimizes by not attaching gesture detection when no callbacks are provided
/// - Properly manages timer resources to prevent memory leaks
/// - Handles widget lifecycle correctly (mounted checks, dispose cleanup)
/// - Prevents accidental triggers from rapid successive taps (< 50ms apart)
/// - Includes error handling to prevent callback exceptions from crashing the app
///
/// ## Testing Support
/// The [timeProvider] parameter allows for dependency injection of time functions,
/// making the widget easily testable with mock time providers.
class AppGestureDetector extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This widget will be wrapped with gesture detection capabilities.
  final Widget child;

  /// A callback function for a single tap.
  ///
  /// **Timing behavior:**
  /// - If [onDoubleTap] is null: Called immediately on tap
  /// - If [onDoubleTap] is provided: Called immediately, but may be cancelled
  ///   if a double tap occurs within [doubleTapTimeout]
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final VoidCallback? onTap;

  /// A callback function to cancel/undo the effect of [onTap].
  ///
  /// This is called when a single tap was executed but then a double tap
  /// is detected within [doubleTapTimeout]. This allows for immediate
  /// single tap feedback while still supporting proper double tap handling.
  ///
  /// **Use case:** If [onTap] changes UI state (like selection), this callback
  /// should reverse that change.
  ///
  /// **Example:**
  /// ```dart
  /// bool isSelected = false;
  ///
  /// AppGestureDetector(
  ///   onTap: () => setState(() => isSelected = true),
  ///   onTapCancel: () => setState(() => isSelected = false),
  ///   onDoubleTap: () => openItem(),
  /// )
  /// ```
  final VoidCallback? onTapCancel;

  /// A callback function for a double tap.
  ///
  /// **Requirements:** Two taps must occur within [doubleTapTimeout] duration.
  ///
  /// **Behavior:** When executed, it prevents [onTap] from being called,
  /// ensuring only one callback is executed per gesture sequence.
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final VoidCallback? onDoubleTap;

  /// A callback function for when a tap down event occurs.
  ///
  /// This is called immediately when the user presses down on the widget,
  /// before any tap/double-tap logic is processed. Useful for providing
  /// immediate visual feedback or debugging tap detection.
  ///
  /// **Timing:** Called immediately on pointer down, regardless of whether
  /// this will become a single tap, double tap, or cancelled gesture.
  ///
  /// **Use cases:**
  /// - Immediate visual feedback (highlight, ripple effect)
  /// - Debugging tap detection issues
  /// - Analytics/logging of user interactions
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final GestureTapDownCallback? onTapDown;

  /// A callback function for when a tap up event occurs.
  ///
  /// This is called when the user releases their finger/mouse, but before
  /// the tap/double-tap logic determines the final action. This provides
  /// a way to detect the physical end of a tap gesture.
  ///
  /// **Timing:** Called on pointer up, before [onTap] or [onDoubleTap]
  /// processing occurs.
  ///
  /// **Use cases:**
  /// - Removing visual feedback applied in [onTapDown]
  /// - Debugging gesture completion
  /// - Measuring tap duration
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final GestureTapUpCallback? onTapUp;

  /// How this gesture detector should behave during hit testing.
  ///
  /// This affects how the gesture detector responds to taps on child widgets:
  /// - [HitTestBehavior.deferToChild]: Only responds to taps on empty areas
  /// - [HitTestBehavior.opaque]: Responds to all taps within bounds
  /// - [HitTestBehavior.translucent]: Responds to all taps and passes through
  ///
  /// For table cells, [HitTestBehavior.opaque] is recommended to ensure
  /// taps on text and other content are detected.
  final HitTestBehavior? behavior;

  /// The duration to consider for a double tap.
  ///
  /// **Default:** 250 milliseconds (following platform conventions)
  ///
  /// **Usage:**
  /// - Maximum time between two taps to be considered a double tap
  /// - Delay time for single tap execution when both callbacks are provided
  /// - Should be between 100-500ms for optimal user experience
  final Duration doubleTapTimeout;

  /// Time provider function for testing purposes.
  ///
  /// **Default:** [DateTime.now] in production
  ///
  /// **Testing:** Inject a custom time provider to control time flow in tests:
  /// ```dart
  /// DateTime mockTime = DateTime(2023, 1, 1);
  /// AppGestureDetector(
  ///   timeProvider: () => mockTime,
  ///   // ... other parameters
  /// )
  /// ```
  final TimeProvider timeProvider;

  const AppGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onTapCancel,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapUp,
    this.behavior,
    this.doubleTapTimeout = const Duration(milliseconds: 250),
    this.timeProvider = _defaultTimeProvider,
  });

  /// Default time provider that returns current time.
  static DateTime _defaultTimeProvider() => DateTime.now();

  @override
  State<AppGestureDetector> createState() => _AppGestureDetectorState();
}

class _AppGestureDetectorState extends State<AppGestureDetector> {
  DateTime? _lastTapTime;
  Timer? _singleTapTimer;

  @override
  void dispose() {
    _cancelSingleTapTimer();
    super.dispose();
  }

  /// Cancels the pending single tap timer if it exists.
  void _cancelSingleTapTimer() {
    _singleTapTimer?.cancel();
    _singleTapTimer = null;
  }

  /// Handles tap events with proper single/double tap distinction.
  void _handleTap() {
    if (!mounted) return;

    debugPrint('🔧 [AppGestureDetector] _handleTap called');

    final now = widget.timeProvider();

    // Handle rapid successive taps by ensuring minimum time between taps
    if (_lastTapTime != null) {
      final timeSinceLastTap = now.difference(_lastTapTime!);

      // If taps are too rapid (less than 50ms), ignore to prevent accidental triggers
      if (timeSinceLastTap < const Duration(milliseconds: 50)) {
        debugPrint('🔧 [AppGestureDetector] Tap too rapid, ignoring');
        return;
      }

      // Check if this is within double tap timeout
      if (timeSinceLastTap < widget.doubleTapTimeout) {
        // This is a double tap
        debugPrint('🔧 [AppGestureDetector] Double tap detected');
        _handleDoubleTap();
        return;
      }
    }

    // This is potentially the first tap of a double tap, or a single tap
    debugPrint('🔧 [AppGestureDetector] Handling first tap');
    _handleFirstTap(now);
  }

  /// Handles the first tap, which might be part of a double tap.
  void _handleFirstTap(DateTime tapTime) {
    debugPrint('🔧 [AppGestureDetector] _handleFirstTap called');
    _lastTapTime = tapTime;
    _cancelSingleTapTimer(); // Cancel any existing timer

    if (widget.onDoubleTap == null) {
      // No double tap handler, execute single tap immediately
      debugPrint(
        '🔧 [AppGestureDetector] No double tap handler, executing single tap immediately',
      );
      _executeSingleTap();
    } else if (widget.onTap != null) {
      if (widget.onTapCancel != null) {
        // onTapCancel is provided, execute single tap immediately for responsive UI
        debugPrint(
          '🔧 [AppGestureDetector] onTapCancel provided, executing single tap immediately',
        );
        _executeSingleTap();

        // Set up timer to detect if this becomes a double tap
        _singleTapTimer = Timer(widget.doubleTapTimeout, () {
          // Timer expired, single tap is confirmed (no cancellation needed)
          debugPrint('🔧 [AppGestureDetector] Single tap timer expired');
          _resetTapState();
        });
      } else {
        // No onTapCancel, use traditional delayed execution
        debugPrint(
          '🔧 [AppGestureDetector] No onTapCancel, using delayed execution',
        );
        _singleTapTimer = Timer(widget.doubleTapTimeout, () {
          if (mounted) {
            debugPrint('🔧 [AppGestureDetector] Delayed single tap execution');
            _executeSingleTap();
          }
          _resetTapState();
        });
      }
    } else {
      debugPrint(
        '🔧 [AppGestureDetector] Only double tap handler provided, waiting for second tap',
      );
    }
    // If only onDoubleTap is provided, we wait for the second tap
  }

  /// Safely executes single tap callback with error handling.
  void _executeSingleTap() {
    debugPrint('🔧 [AppGestureDetector] _executeSingleTap called');
    try {
      if (widget.onTap != null) {
        debugPrint('🔧 [AppGestureDetector] Calling onTap callback');
        widget.onTap!.call();
      } else {
        debugPrint('🔧 [AppGestureDetector] onTap is null, nothing to execute');
      }
    } catch (e, stackTrace) {
      // Log error but don't crash the app
      debugPrint('AppGestureDetector: Error in onTap callback: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      // Only reset if this was an immediate execution (no double tap handler)
      if (widget.onDoubleTap == null) {
        _resetTapState();
      }
    }
  }

  /// Safely executes tap cancel callback with error handling.
  void _executeTapCancel() {
    try {
      widget.onTapCancel?.call();
    } catch (e, stackTrace) {
      // Log error but don't crash the app
      debugPrint('AppGestureDetector: Error in onTapCancel callback: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Handles double tap detection and execution.
  void _handleDoubleTap() {
    debugPrint('🔧 [AppGestureDetector] _handleDoubleTap called');
    _cancelSingleTapTimer(); // Cancel pending timer

    // Cancel the effect of the previous single tap if onTapCancel is provided
    // (only if single tap was executed immediately)
    if (widget.onTapCancel != null) {
      debugPrint('🔧 [AppGestureDetector] Executing tap cancel');
      _executeTapCancel();
    }

    _executeDoubleTap();
  }

  /// Safely executes double tap callback with error handling.
  void _executeDoubleTap() {
    debugPrint('🔧 [AppGestureDetector] _executeDoubleTap called');
    try {
      if (widget.onDoubleTap != null) {
        debugPrint('🔧 [AppGestureDetector] Calling onDoubleTap callback');
        widget.onDoubleTap!.call();
      } else {
        debugPrint(
          '🔧 [AppGestureDetector] onDoubleTap is null, nothing to execute',
        );
      }
    } catch (e, stackTrace) {
      // Log error but don't crash the app
      debugPrint('AppGestureDetector: Error in onDoubleTap callback: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      _resetTapState();
    }
  }

  /// Resets the tap state to initial values.
  void _resetTapState() {
    _lastTapTime = null;
    _cancelSingleTapTimer();
  }

  /// Handles tap down events with error handling.
  void _handleTapDown(TapDownDetails details) {
    debugPrint('🚀 [AppGestureDetector] _handleTapDown CALLED!');
    if (!mounted) return;

    try {
      widget.onTapDown?.call(details);
    } catch (e, stackTrace) {
      // Log error but don't crash the app
      debugPrint('AppGestureDetector: Error in onTapDown callback: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Handles tap up events with error handling.
  void _handleTapUp(TapUpDetails details) {
    debugPrint('🚀 [AppGestureDetector] _handleTapUp CALLED!');
    if (!mounted) return;

    try {
      widget.onTapUp?.call(details);
    } catch (e, stackTrace) {
      // Log error but don't crash the app
      debugPrint('AppGestureDetector: Error in onTapUp callback: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only attach the gesture detector if there's a callback to handle.
    if (widget.onTap == null &&
        widget.onDoubleTap == null &&
        widget.onTapDown == null &&
        widget.onTapUp == null) {
      return widget.child;
    }

    debugPrint(
      '🔧 [AppGestureDetector] Building with onTapDown: ${widget.onTapDown != null}',
    );

    return GestureDetector(
      behavior: widget.behavior,
      onTap:
          (widget.onTap != null || widget.onDoubleTap != null)
              ? _handleTap
              : null,
      onTapDown: widget.onTapDown != null ? _handleTapDown : null,
      onTapUp: widget.onTapUp != null ? _handleTapUp : null,
      child: widget.child,
    );
  }
}
