/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:popover/popover.dart';

import '../styling/app_border_radius.dart';
import '../widgets/app_icon.dart';
import 'app_rectangle_border.dart';

/// Class to manage popover state
class _PopoverState {
  bool _isShowing = false;
  Timer? _autoCloseTimer;

  bool get isShowing => _isShowing;

  void markAsShowing() {
    _isShowing = true;
  }

  void markAsClosed() {
    _isShowing = false;
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }

  void setAutoCloseTimer(Timer timer) {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = timer;
  }

  void dispose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
    _isShowing = false;
  }
}

/// Animation type for AppPopover
enum AppPopoverAnimation {
  /// Scale + Fade (default recommended)
  scaleAndFade,

  /// Slide + Fade
  slideAndFade,

  /// Elastic
  elastic,

  /// Simple Fade
  fade,

  /// No animation
  none,
}

/// Common Popover for App app
///
/// Wraps popover package to provide unified popover style across the app.
/// Theme colors are obtained via AppColorScheme provider,
/// not directly accessing Flutter standard ColorScheme or Theme.of.
class AppPopover extends ConsumerWidget {
  const AppPopover({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This widget is not used directly, only static methods are provided
    return const SizedBox.shrink();
  }

  /// Get animation duration
  static Duration _getAnimationDuration(AppPopoverAnimation animation) {
    switch (animation) {
      case AppPopoverAnimation.scaleAndFade:
        return const Duration(milliseconds: 250);
      case AppPopoverAnimation.slideAndFade:
        return const Duration(milliseconds: 300);
      case AppPopoverAnimation.elastic:
        return const Duration(milliseconds: 400);
      case AppPopoverAnimation.fade:
        return const Duration(milliseconds: 200);
      case AppPopoverAnimation.none:
        return Duration.zero;
    }
  }

  /// Build custom transition
  static Widget _buildCustomTransition(
    Animation<double> animation,
    Widget child,
    AppPopoverAnimation animationType,
    PopoverDirection direction,
  ) {
    switch (animationType) {
      case AppPopoverAnimation.scaleAndFade:
        final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );

      case AppPopoverAnimation.slideAndFade:
        final slideOffset = _getSlideOffset(direction);
        final slideAnimation = Tween<Offset>(
          begin: slideOffset,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
          ),
        );
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );

      case AppPopoverAnimation.elastic:
        final scaleAnimation = Tween<double>(
          begin: 0.7,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut));
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );

      case AppPopoverAnimation.fade:
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(opacity: fadeAnimation, child: child);

      case AppPopoverAnimation.none:
        return child;
    }
  }

  /// Get slide offset
  static Offset _getSlideOffset(PopoverDirection direction) {
    switch (direction) {
      case PopoverDirection.top:
        return const Offset(0.0, 0.3);
      case PopoverDirection.bottom:
        return const Offset(0.0, -0.3);
      case PopoverDirection.left:
        return const Offset(0.3, 0.0);
      case PopoverDirection.right:
        return const Offset(-0.3, 0.0);
    }
  }

  /// Show popover with spotlight effect
  ///
  /// [context] - Build context
  /// [targetKey] - GlobalKey of element to spotlight
  /// [bodyBuilder] - Builder to construct popover content
  /// [direction] - Popover display direction (default: bottom)
  /// [animation] - Animation type (default: fade)
  /// [spotlightOverlayColor] - Darkening color outside spotlight (default: semi-transparent black)
  /// [spotlightRadius] - Corner radius of spotlight area (default: 8.0)
  /// [spotlightPadding] - Padding of spotlight area (default: 8.0)
  /// [rippleCount] - Number of ripple effects (default: 2, 0 to disable)
  /// [rippleDelay] - Delay between ripple effects (default: 800ms)
  /// Other parameters are same as show method
  static void showWithSpotlight({
    required BuildContext context,
    required GlobalKey targetKey,
    required WidgetBuilder bodyBuilder,
    PopoverDirection direction = PopoverDirection.bottom,
    double width = 200,
    double height = 400,
    double arrowHeight = 12,
    double arrowWidth = 20,
    double? radius,
    Color? backgroundColor,
    Color? shadowColor,
    double elevation = 8,
    VoidCallback? onPop,
    bool barrierDismissible = true,
    AppPopoverAnimation animation = AppPopoverAnimation.fade,
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color spotlightOverlayColor = const Color(0x80000000),
    double spotlightRadius = 8.0,
    double spotlightPadding = 8.0,
    int rippleCount = 2,
    Duration rippleDelay = const Duration(milliseconds: 800),
  }) {
    final overlay = Overlay.of(context);
    final renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      // Fallback: show normal popover
      show(
        context: context,
        bodyBuilder: bodyBuilder,
        direction: direction,
        width: width,
        height: height,
        arrowHeight: arrowHeight,
        arrowWidth: arrowWidth,
        radius: radius,
        backgroundColor: backgroundColor,
        shadowColor: shadowColor,
        elevation: elevation,
        onPop: onPop,
        barrierDismissible: barrierDismissible,
        animation: animation,
        transitionDuration: transitionDuration,
      );
      return;
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final targetRect = Rect.fromLTWH(
      position.dx - spotlightPadding,
      position.dy - spotlightPadding,
      size.width + (spotlightPadding * 2),
      size.height + (spotlightPadding * 2),
    );

    OverlayEntry? spotlightEntry;
    bool isSpotlightRemoved = false;

    void removeSpotlight() {
      if (!isSpotlightRemoved && spotlightEntry != null) {
        spotlightEntry.remove();
        isSpotlightRemoved = true;
      }
    }

    // Create spotlight overlay
    spotlightEntry = OverlayEntry(
      builder:
          (context) => _SpotlightOverlay(
            targetRect: targetRect,
            overlayColor: spotlightOverlayColor,
            spotlightRadius: spotlightRadius,
            rippleCount: rippleCount,
            rippleDelay: rippleDelay,
            onDismiss: () {
              removeSpotlight();
              // Close popover only if context is valid
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
    );

    overlay.insert(spotlightEntry);

    // Show popover after spotlight animation completes
    Future.delayed(const Duration(milliseconds: 350), () {
      if (context.mounted) {
        show(
          context: context,
          bodyBuilder: bodyBuilder,
          direction: direction,
          width: width,
          height: height,
          arrowHeight: arrowHeight,
          arrowWidth: arrowWidth,
          radius: radius,
          backgroundColor: backgroundColor,
          shadowColor: shadowColor,
          elevation: elevation,
          onPop: () {
            removeSpotlight();
            onPop?.call();
          },
          barrierColor:
              Colors.transparent, // Make barrier transparent to show spotlight
          barrierDismissible:
              false, // Disable barrier close (handled by spotlight)
          animation: animation,
          transitionDuration: transitionDuration,
        );
      }
    });
  }

  /// Show popover
  ///
  /// [context] - Build context
  /// [bodyBuilder] - Builder to construct popover content
  /// [direction] - Popover display direction (default: bottom)
  /// [width] - Popover width (default: 200)
  /// [height] - Popover height (default: 400)
  /// [arrowHeight] - Arrow height (default: 12)
  /// [arrowWidth] - Arrow width (default: 20)
  /// [radius] - Corner radius (default: 12)
  /// [backgroundColor] - Background color (auto-fetched from theme if not specified)
  /// [shadowColor] - Shadow color (auto-fetched from theme if not specified)
  /// [elevation] - Shadow height (default: 8)
  /// [onPop] - Callback when popover is closed
  /// [barrierColor] - Barrier color (auto-fetched from theme if not specified)
  /// [barrierDismissible] - Whether to close by tapping barrier (default: true)
  /// [animation] - Animation type (default: fade)
  /// [transitionDuration] - Animation duration (default: 200ms, ignored if animation is not none)
  /// [duration] - Time until auto-dismiss (shows until manually closed if not specified)
  /// [delay] - Delay time until display (used for hover tooltips)
  static void show({
    required BuildContext context,
    required WidgetBuilder bodyBuilder,
    PopoverDirection direction = PopoverDirection.bottom,
    double width = 200,
    double height = 400,
    double arrowHeight = 12,
    double arrowWidth = 20,
    double? radius,
    Color? backgroundColor,
    Color? shadowColor,
    double elevation = 8,
    VoidCallback? onPop,
    Color? barrierColor,
    bool barrierDismissible = true,
    AppPopoverAnimation animation = AppPopoverAnimation.fade,
    Duration transitionDuration = const Duration(milliseconds: 200),
    Duration? duration,
    Duration? delay,
  }) {
    // Manage popover state
    final popoverState = _PopoverState();

    void showPopoverInternal() {
      // Set default values (recommended to specify theme colors on caller side)
      final effectiveRadius = radius ?? 12.0;
      final effectiveBackgroundColor = backgroundColor ?? Colors.white;
      final effectiveShadowColor = shadowColor ?? Colors.black.withAlpha(77);
      final effectiveBarrierColor = barrierColor ?? Colors.black.withAlpha(77);

      // Mark popover as showing
      popoverState.markAsShowing();

      showPopover(
        context: context,
        bodyBuilder: bodyBuilder,
        direction: direction,
        width: width,
        height: height,
        arrowHeight: arrowHeight,
        arrowWidth: arrowWidth,
        radius: effectiveRadius,
        backgroundColor: effectiveBackgroundColor,
        shadow: [
          BoxShadow(
            color: effectiveShadowColor,
            blurRadius: elevation,
            offset: const Offset(0, 2),
          ),
        ],
        onPop: () {
          // Handle popover close
          popoverState.markAsClosed();
          onPop?.call();
        },
        barrierColor: effectiveBarrierColor,
        barrierDismissible: barrierDismissible,
        transitionDuration:
            animation == AppPopoverAnimation.none
                ? Duration
                    .zero // No animation
                : _getAnimationDuration(animation),
        popoverTransitionBuilder:
            animation == AppPopoverAnimation.none
                ? (animationController, child) =>
                    child // No animation
                : (animationController, child) => _buildCustomTransition(
                  animationController,
                  child,
                  animation,
                  direction,
                ),
      );

      // Set auto-close timer
      if (duration != null) {
        final timer = Timer(duration, () {
          if (context.mounted && popoverState.isShowing) {
            // Close only if popover is showing
            try {
              Navigator.of(context, rootNavigator: false).pop();
              popoverState.markAsClosed();
            } catch (e) {
              // Clear state if error occurs
              popoverState.markAsClosed();
              assert(() {
                debugPrint('AppPopover: Failed to auto-close popover: $e');
                return true;
              }());
            }
          }
        });
        popoverState.setAutoCloseTimer(timer);
      }
    }

    // Handle delayed display
    if (delay != null) {
      Timer(delay, () {
        if (context.mounted) {
          showPopoverInternal();
        }
      });
    } else {
      showPopoverInternal();
    }
  }

  /// Show simple text popover
  ///
  /// [context] - Build context
  /// [text] - Text to display
  /// [direction] - Popover display direction (default: top)
  /// [width] - Popover width (default: 200)
  /// [height] - Popover height (default: 60)
  /// [animation] - Animation type (default: fade)
  /// Other parameters are same as show method
  static void showText({
    required BuildContext context,
    required String text,
    PopoverDirection direction = PopoverDirection.top,
    double width = 200,
    double? height,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    double arrowHeight = 8,
    double arrowWidth = 16,
    double? radius,
    Color? backgroundColor,
    Color? shadowColor,
    double elevation = 4,
    VoidCallback? onPop,
    Color? barrierColor,
    bool barrierDismissible = true,
    AppPopoverAnimation animation = AppPopoverAnimation.fade,
    Duration transitionDuration = const Duration(milliseconds: 150),
  }) {
    // Set default values
    final effectivePadding = padding ?? const EdgeInsets.all(12);
    final effectiveTextStyle =
        textStyle ?? const TextStyle(color: Colors.black87, fontSize: 14);

    show(
      context: context,
      bodyBuilder:
          (context) => Container(
            padding: effectivePadding,
            child: Text(text, style: effectiveTextStyle),
          ),
      direction: direction,
      width: width,
      height: height ?? 60,
      arrowHeight: arrowHeight,
      arrowWidth: arrowWidth,
      radius: radius,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      onPop: onPop,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      animation: animation,
      transitionDuration: transitionDuration,
    );
  }

  /// Show simple notification (Toast)
  ///
  /// [context] - Build context
  /// [message] - Message to display
  /// [icon] - Icon (optional)
  /// [backgroundColor] - Background color (optional)
  /// [textColor] - Text color (optional)
  /// [duration] - Display duration (default: 3 seconds)
  /// [direction] - Display direction (default: top)
  /// [animation] - Animation type (default: fade)
  static void showToast({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    PopoverDirection direction = PopoverDirection.top,
    AppPopoverAnimation animation = AppPopoverAnimation.fade,
  }) {
    show(
      context: context,
      duration: duration,
      direction: direction,
      animation: animation,
      backgroundColor: backgroundColor ?? Colors.grey.shade800,
      elevation: 4,
      arrowHeight: 0, // Toast style without arrow
      arrowWidth: 0,
      barrierColor: Colors.transparent, // Make barrier transparent
      barrierDismissible: true,
      bodyBuilder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  AppIcon(
                    icon,
                    customSize: 20,
                    customColor: textColor ?? Colors.white,
                    disableZoom: true,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// Show list item popover
  ///
  /// [context] - Build context
  /// [items] - List of items to display
  /// [onItemTap] - Callback when item is tapped
  /// [direction] - Popover display direction (default: bottom)
  /// [width] - Popover width (default: 200)
  /// [animation] - Animation type (default: fade)
  /// Other parameters are same as show method
  static void showList({
    required BuildContext context,
    required List<String> items,
    required void Function(int index, String item) onItemTap,
    PopoverDirection direction = PopoverDirection.bottom,
    double width = 200,
    double? height,
    double arrowHeight = 12,
    double arrowWidth = 20,
    double? radius,
    Color? backgroundColor,
    Color? shadowColor,
    double elevation = 8,
    VoidCallback? onPop,
    Color? barrierColor,
    bool barrierDismissible = true,
    AppPopoverAnimation animation = AppPopoverAnimation.fade,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    // Auto-calculate height if not specified
    final effectiveHeight =
        height ?? (items.length * 48.0 + 16).clamp(60.0, 400.0);

    show(
      context: context,
      bodyBuilder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    onItemTap(index, item);
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      direction: direction,
      width: width,
      height: effectiveHeight,
      arrowHeight: arrowHeight,
      arrowWidth: arrowWidth,
      radius: radius,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      onPop: onPop,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      animation: animation,
      transitionDuration: transitionDuration,
    );
  }
}

/// Overlay widget with spotlight effect
class _SpotlightOverlay extends StatefulWidget {
  const _SpotlightOverlay({
    required this.targetRect,
    required this.overlayColor,
    required this.spotlightRadius,
    required this.rippleCount,
    required this.rippleDelay,
    required this.onDismiss,
  });

  final Rect targetRect;
  final Color overlayColor;
  final double spotlightRadius;
  final int rippleCount;
  final Duration rippleDelay;
  final VoidCallback onDismiss;

  @override
  State<_SpotlightOverlay> createState() => _SpotlightOverlayState();
}

class _SpotlightOverlayState extends State<_SpotlightOverlay>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;

  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  int _currentRippleCount = 0;

  @override
  void initState() {
    super.initState();

    // Overlay fade-in animation
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _overlayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeOut),
    );

    // Ripple effect animation
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Start animation
    _overlayController.forward();

    // Start ripple effect (if count is specified)
    if (widget.rippleCount > 0) {
      _startRippleSequence();
    }
  }

  void _startRippleSequence() async {
    // Initial delay
    await Future.delayed(const Duration(milliseconds: 500));

    while (_currentRippleCount < widget.rippleCount && mounted) {
      await _rippleController.forward();
      _rippleController.reset();
      _currentRippleCount++;

      if (_currentRippleCount < widget.rippleCount) {
        await Future.delayed(widget.rippleDelay);
      }
    }
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_overlayAnimation, _rippleAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onDismiss, // Close by tapping outside spotlight
          child: Stack(
            children: [
              // Spotlight overlay
              CustomPaint(
                painter: _SpotlightPainter(
                  targetRect: widget.targetRect,
                  overlayColor: widget.overlayColor.withValues(
                    alpha: widget.overlayColor.a * _overlayAnimation.value,
                  ),
                  spotlightRadius: widget.spotlightRadius,
                ),
                size: MediaQuery.of(context).size,
              ),

              // Ripple effect
              if (widget.rippleCount > 0 && _rippleAnimation.value > 0)
                Positioned.fromRect(
                  rect: widget.targetRect,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: AppBorderRadiusValues.fromValue(
                        widget.spotlightRadius,
                      ),
                      splashColor: Colors.white.withValues(alpha: 0.3),
                      highlightColor: Colors.transparent,
                      onTap: () {}, // Ignore taps inside spotlight
                      child: AppRectangleBorder(
                        cornerRadius: widget.spotlightRadius,
                        side: BorderSide(
                          color: Colors.white.withValues(
                            alpha: 0.5 * _rippleAnimation.value,
                          ),
                          width: 2.0,
                        ),
                        child: SizedBox(
                          width: widget.targetRect.width,
                          height: widget.targetRect.height,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom painter to draw spotlight effect
class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter({
    required this.targetRect,
    required this.overlayColor,
    required this.spotlightRadius,
  });

  final Rect targetRect;
  final Color overlayColor;
  final double spotlightRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    // Darken full screen
    final fullScreenRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Cut out spotlight area
    final spotlightRect = RRect.fromRectAndRadius(
      targetRect,
      Radius.circular(spotlightRadius),
    );

    final path =
        Path()
          ..addRect(fullScreenRect)
          ..addRRect(spotlightRect)
          ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _SpotlightPainter) return true;
    return oldDelegate.overlayColor != overlayColor ||
        oldDelegate.targetRect != targetRect ||
        oldDelegate.spotlightRadius != spotlightRadius;
  }
}

/// Capsule providing default configuration for AppPopover
///
/// Provides unified popover configuration across the app.
/// Extension point for future theme-based configuration.
class AppPopoverConfig {
  const AppPopoverConfig({
    this.defaultWidth = 200,
    this.defaultHeight = 400,
    this.defaultArrowHeight = 12,
    this.defaultArrowWidth = 20,
    this.defaultRadius = 12,
    this.defaultElevation = 8,
    this.defaultTransitionDuration = const Duration(milliseconds: 200),
  });

  final double defaultWidth;
  final double defaultHeight;
  final double defaultArrowHeight;
  final double defaultArrowWidth;
  final double defaultRadius;
  final double defaultElevation;
  final Duration defaultTransitionDuration;
}

/// Provider for AppPopover configuration
final appPopoverConfigProvider = Provider<AppPopoverConfig>((ref) {
  final accessibilityConfig = ref.watch(accessibilityConfigProvider);
  final zoomScale = accessibilityConfig.zoomScale;

  // Apply zoom scaling to default values
  return AppPopoverConfig(
    defaultWidth: 200 * zoomScale,
    defaultHeight: 400 * zoomScale,
    defaultArrowHeight: 12 * zoomScale,
    defaultArrowWidth: 20 * zoomScale,
    defaultRadius: 12 * zoomScale,
    defaultElevation: 8 * zoomScale,
    defaultTransitionDuration: const Duration(milliseconds: 200),
  );
});
