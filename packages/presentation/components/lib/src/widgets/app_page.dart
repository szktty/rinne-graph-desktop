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

import '../typography/app_text.dart';
import 'app_divider.dart';

/// A page-level component with a "left-aligned title + divider + content" structure.
///
/// A large-structure widget used in master-detail type detail views or independent panels.
/// Provides a base structure similar to Scaffold, intended for use one per screen.
///
/// Usage example:
/// ```dart
/// AppPage(
///   title: "Entity Details",
///   titleVariant: AppTextVariant.pageTitleMedium,
///   child: EntityDetailContent(),
/// )
/// ```
class AppPage extends ConsumerWidget {
  /// The title of the page.
  final String title;

  /// The typography variant for the title (required).
  final AppTextVariant titleVariant;

  /// The main content.
  final Widget child;

  /// The color of the title (optional, automatically obtained from theme if not specified).
  final Color? titleColor;

  /// The text alignment of the title (default: left-aligned).
  final TextAlign titleAlign;

  /// The maximum number of lines for the title (default: 1).
  final int? titleMaxLines;

  /// The overflow handling for the title (default: ellipsis).
  final TextOverflow titleOverflow;

  /// The spacing between the title and content (default: 16px).
  final double spacing;

  /// Whether to show a divider (default: true).
  final bool showDivider;

  /// The color of the divider (optional, automatically obtained from theme if not specified).
  final Color? dividerColor;

  /// The thickness of the divider (default: 2.0).
  final double dividerThickness;

  /// The left and right indent of the divider (default: none).
  final double? dividerIndent;
  final double? dividerEndIndent;

  /// Whether to disable zoom functionality (default: false).
  final bool disableZoom;

  /// The background color (optional).
  final Color? backgroundColor;

  /// Whether to limit the content to its minimum size (default: false).
  /// If true, does not use Expanded even with height constraints, and limits content to its minimum size.
  final bool shrinkWrap;

  /// Creates an AppPage.
  const AppPage({
    required this.title,
    required this.titleVariant,
    required this.child,
    this.titleColor,
    this.titleAlign = TextAlign.start,
    this.titleMaxLines = 1,
    this.titleOverflow = TextOverflow.ellipsis,
    this.spacing = 16.0,
    this.showDivider = true,
    this.dividerColor,
    this.dividerThickness = 2.0,
    this.dividerIndent,
    this.dividerEndIndent,
    this.disableZoom = false,
    this.backgroundColor,
    this.shrinkWrap = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Calculate scaled value
    final scaledSpacing = spacing * zoomScale;

    // 背景色が指定されている場合はContainerで包む
    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        // If shrinkWrap is enabled or there is no height constraint, use normal layout without Expanded
        if (shrinkWrap || constraints.maxHeight == double.infinity) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title section
              AppText(
                title,
                variant: titleVariant,
                color: titleColor,
                textAlign: titleAlign,
                maxLines: titleMaxLines,
                overflow: titleOverflow,
                disableZoom: disableZoom,
              ),

              // Space between title and content
              SizedBox(height: scaledSpacing),

              // Divider (optional)
              if (showDivider) ...[
                AppDivider(
                  color: dividerColor,
                  thickness: dividerThickness,
                  indent: dividerIndent,
                  endIndent: dividerEndIndent,
                  disableZoom: disableZoom,
                ),
                SizedBox(height: scaledSpacing),
              ],

              // Main content (without Expanded)
              child,
            ],
          );
        } else {
          // Use Column if available height
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title section
              AppText(
                title,
                variant: titleVariant,
                color: titleColor,
                textAlign: titleAlign,
                maxLines: titleMaxLines,
                overflow: titleOverflow,
                disableZoom: disableZoom,
              ),

              // Space between title and content
              SizedBox(height: scaledSpacing),

              // Divider (optional)
              if (showDivider) ...[
                AppDivider(
                  color: dividerColor,
                  thickness: dividerThickness,
                  indent: dividerIndent,
                  endIndent: dividerEndIndent,
                  disableZoom: disableZoom,
                ),
                SizedBox(height: scaledSpacing),
              ],

              // Main content
              Expanded(child: child),
            ],
          );
        }
      },
    );

    // Wrap with Container only if background color is specified
    if (backgroundColor != null) {
      return Container(color: backgroundColor, child: content);
    }

    return content;
  }
}
