/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/src/styling/app_border.dart';
import 'package:presentation_components/src/widgets/app_rectangle_border.dart';

/// A themed segmented button that automatically applies colors from AppColorConfig.
class AppSegmentedButton<T extends Object> extends ConsumerWidget {
  /// The set of segments currently selected.
  final Set<T> selected;

  /// The configuration for each segment in the button.
  final List<ButtonSegment<T>> segments;

  /// The callback that is called when the selection changes.
  final ValueChanged<Set<T>> onSelectionChanged;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  /// Creates a themed segmented button.
  const AppSegmentedButton({
    required this.selected,
    required this.segments,
    required this.onSelectionChanged,
    this.disableZoom = false,
    super.key,
    // TODO: Add other SegmentedButton properties if needed
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    // Optimization: Monitor only necessary properties to prevent unnecessary Widget rebuilds
    final zoomScale =
        disableZoom
            ? 1.0
            : ref.watch(
              accessibilityConfigProvider.select((config) => config.zoomScale),
            );
    final borderScale =
        disableZoom
            ? 1.0
            : ref.watch(
              accessibilityConfigProvider.select(
                (config) => config.borderScale,
              ),
            );

    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      showSelectedIcon: false, // Disable checkbox display
      style: SegmentedButton.styleFrom(
        // Use base background color
        backgroundColor: appColorScheme.base.background,
        // Use theme color when selected
        selectedBackgroundColor: appColorScheme.theme.primaryColor.withValues(
          alpha: 0.1,
        ),
        // Text color when not selected
        foregroundColor: appColorScheme.base.foreground,
        // Text color when selected (theme color)
        selectedForegroundColor: appColorScheme.theme.primaryColor,
        side: BorderSide(
          // Border color
          color: appColorScheme.base.border,
          width: AppBorderWidth.medium * borderScale,
        ),
        // Conforms to design guidelines: Get shape via AppRectangleBorderProvider
        // Prevent animation: Use consistent shape object
        shape: ref.watch(appRectangleBorderProvider),
        // TextStyle conforming to AppTextVariant (zoom support is automatic)
        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize:
              (Theme.of(context).textTheme.labelMedium?.fontSize ?? 14.0) *
              zoomScale,
        ),
        // Zoom support: Icon size is also adjusted
        iconSize: 18.0 * zoomScale,
        // Zoom support: Ensure minimum tap target size (design guideline: 44px or more)
        minimumSize: Size(44.0 * zoomScale, 44.0 * zoomScale),
        // Disable animation: Prevent unnecessary animation during zoom
        animationDuration: Duration.zero,
        // Disable ripple animation: Disable ripple effect on tap
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}
