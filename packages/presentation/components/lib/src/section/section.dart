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

/// A section container with a title and description.
///
/// Automatically inserts dividers between child elements and supports accessibility
/// zoom features. Provides a unified style for the layout of titles,
/// descriptions, and child elements.
class Section extends ConsumerWidget {
  /// Creates a new section.
  const Section({
    required this.children,
    this.title,
    this.description,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16.0,
    this.showDividers = true,
    this.showTopDivider = false,
    this.showBottomDivider = false,
    this.backgroundColor,
    this.disableZoom = false,
    super.key,
  });

  final List<Widget> children;
  final Widget? title;
  final Widget? description;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool showDividers;
  final bool showTopDivider;
  final bool showBottomDivider;
  final Color? backgroundColor;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final scaledSpacing = spacing * zoomScale;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) title!,
        if (description != null) ...[
          SizedBox(height: 4 * zoomScale),
          description!,
        ],
      ],
    );

    final childrenWithDividers =
        showDividers
            ? _insertDividers(children, theme.dividerColor, scaledSpacing)
            : children;

    // Scale the padding if it's the default value
    final scaledPadding =
        padding == const EdgeInsets.all(16)
            ? EdgeInsets.all(16 * zoomScale)
            : padding;

    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top divider
          if (showTopDivider) ...[
            Divider(height: 1, color: theme.dividerColor),
            SizedBox(height: 16 * zoomScale), // Changed to 16px (lg)
          ],

          if (title != null || description != null) ...[
            header,
            SizedBox(height: scaledSpacing),
          ],

          ...childrenWithDividers,

          // Bottom divider
          if (showBottomDivider) ...[
            SizedBox(height: 16 * zoomScale), // Changed to 16px (lg)
            Divider(height: 1, color: theme.dividerColor),
          ],
        ],
      ),
    );
  }

  List<Widget> _insertDividers(
    List<Widget> items,
    Color? dividerColor,
    double scaledSpacing,
  ) {
    if (items.isEmpty) return items;

    final result = <Widget>[];
    // Set the top and bottom space of the divider to 16px (lg)
    final dividerSpacing = 16.0 * (scaledSpacing / 16.0); // Apply zoom factor

    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        result.add(SizedBox(height: dividerSpacing));
        result.add(Divider(height: 1, color: dividerColor));
        result.add(SizedBox(height: dividerSpacing));
      }
      result.add(items[i]);
    }
    return result;
  }
}
