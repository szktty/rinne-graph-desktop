import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:core_themes/core_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-specific page indicator.
///
/// This widget uses the `dots_indicator` package to create a pagination
/// dot indicator. The app's theme color is automatically applied.
class AppPageIndicator extends ConsumerWidget {
  /// Constructs the page indicator.
  ///
  /// [dotsCount] specifies the total number of pages, and [position] specifies
  /// the current page position (starting from 0).
  const AppPageIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
    this.onDotTapped,
    this.axis = Axis.horizontal,
    this.dotSize = 6.0,
    this.dotSpacing = 15.0,
    this.mainAxisSize = MainAxisSize.min,
    this.decorator,
  });

  /// Total number of dots (number of pages).
  final int dotsCount;

  /// Position of the current active dot (0-based).
  final double position;

  /// Callback when a dot is tapped.
  final Function(int)? onDotTapped;

  /// Orientation of the dots (horizontal or vertical).
  final Axis axis;

  /// Size of each dot.
  final double dotSize;

  /// Spacing between dots.
  final double dotSpacing;

  /// Size of the main axis.
  final MainAxisSize mainAxisSize;

  /// Custom dot decorator.
  final DotsDecorator? decorator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Default dot decorator based on theme
    final defaultDecorator = DotsDecorator(
      size: Size.square(dotSize),
      activeSize: Size.square(dotSize + 2.0),
      color: appColorScheme.interactive.input.border,
      activeColor: appColorScheme.appSpecific.graph.nodeBase,
      spacing: EdgeInsets.all(dotSpacing / 2),
      activeShape: const CircleBorder(),
      shape: const CircleBorder(),
    );

    return DotsIndicator(
      dotsCount: dotsCount,
      position: position,
      onTap: onDotTapped,
      axis: axis,
      mainAxisSize: mainAxisSize,
      decorator: decorator ?? defaultDecorator,
    );
  }
}
