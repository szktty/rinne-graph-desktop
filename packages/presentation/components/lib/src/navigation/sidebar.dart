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

/// A general-purpose widget that represents the application's sidebar.
///
/// Can be used as a primary or secondary sidebar.
/// Applies the appropriate background color based on the theme.
class Sidebar extends ConsumerWidget {
  /// The main content to display within the sidebar.
  final Widget child;

  /// The width of the sidebar (default: 280.0).
  final double width;

  /// The background color of the sidebar. If not specified, it is obtained from the theme.
  final Color? backgroundColor;

  /// The border of the sidebar. By default, a divider is displayed on the right side.
  final Border? border;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  const Sidebar({
    required this.child,
    this.width = 280.0,
    this.backgroundColor,
    this.border,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // Determine background color (use specified color if available, otherwise use theme)
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final resolvedBackgroundColor =
        backgroundColor ?? appColorScheme.uiAreas.sideBar.background;

    // Default border (divider on the right)
    final resolvedBorder =
        border ??
        Border(
          right: BorderSide(
            color: appColorScheme.base.divider,
            width: 1.0 * borderScale,
          ),
        );

    return Container(
      width: width * zoomScale,
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        border: resolvedBorder,
      ),
      child: child,
    );
  }
}
