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

/// A badge element to be displayed on a navigation item.
class NavigationBadge extends ConsumerWidget {
  /// The text to display on the badge.
  final String? text;

  /// The background color of the badge.
  final Color? backgroundColor;

  /// The text color of the badge.
  final Color? textColor;

  /// The size of the badge.
  final double size;

  /// Whether to display "99+" when the text overflows.
  final bool isOverflowing;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [NavigationBadge].
  ///
  /// [text] - The text to display on the badge (if null, only a dot is displayed).
  /// [backgroundColor] - The background color of the badge.
  /// [textColor] - The text color of the badge.
  /// [size] - The size of the badge.
  /// [isOverflowing] - A flag for handling text overflow.
  const NavigationBadge({
    super.key,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.size = 18,
    this.isOverflowing = false,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.onPrimary;

    if (text == null || text!.isEmpty) {
      // Display only a dot
      return Container(
        width: (size / 2) * zoomScale,
        height: (size / 2) * zoomScale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: effectiveBackgroundColor,
        ),
      );
    }

    final effectiveText = isOverflowing && text!.length > 2 ? "99+" : text;

    return Container(
      constraints: BoxConstraints(
        minWidth: size * zoomScale,
        minHeight: size * zoomScale,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 6.0 * zoomScale,
        vertical: 2.0 * zoomScale,
      ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular((size / 2) * zoomScale),
      ),
      child: Center(
        child: AppText(
          effectiveText!,
          variant: AppTextVariant.smallText,
          color: effectiveTextColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
