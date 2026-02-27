/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/gestures.dart'; // kDoubleTapTimeout のため
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

/// A reusable card component that supports selection state and theming.
///
/// It handles tap/double-tap callbacks and visually indicates selection
/// using themed colors (passed via parameters), while suppressing default
/// InkWell animations.
/// It prioritizes immediate feedback on tap down and implements custom
/// double-tap detection to avoid single tap delays.
class SelectableCard extends StatefulWidget {
  /// Whether the card is currently selected.
  final bool isSelected;

  /// The widget to display inside the card.
  final Widget child;

  /// Callback when the card is tapped (single tap).
  final VoidCallback? onTap;

  /// Callback when the card is double-tapped.
  final VoidCallback? onDoubleTap;

  /// Callback when the card is tapped down (pressed).
  /// This is called immediately on tap down.
  final VoidCallback? onTapDown;

  /// The margin around the card. Defaults to `EdgeInsets.all(4.0)`.
  final EdgeInsetsGeometry? margin;

  /// The elevation of the card. Defaults to `1.0`.
  final double? elevation;

  /// The clipping behavior for the card. Defaults to `Clip.antiAlias`.
  final Clip clipBehavior;

  /// The background color to use when the card is selected.
  /// If null, a default highlight color based on the theme will be used.
  final Color? selectedColor;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const SelectableCard({
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.onTapDown,
    this.onDoubleTap,
    this.margin,
    this.elevation,
    this.clipBehavior = Clip.antiAlias,
    this.selectedColor,
    this.disableZoom = false,
    super.key,
  });

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        final theme = Theme.of(context);

        // Apply zoom scaling to margin and elevation
        final zoomScale =
            widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
        final scaledMargin =
            widget.margin != null
                ? widget.margin!.resolve(TextDirection.ltr)
                : const EdgeInsets.all(4.0);
        final effectiveMargin = EdgeInsets.fromLTRB(
          scaledMargin.left * zoomScale,
          scaledMargin.top * zoomScale,
          scaledMargin.right * zoomScale,
          scaledMargin.bottom * zoomScale,
        );
        final scaledElevation = (widget.elevation ?? 1.0) * zoomScale;

        // Determine background color based on selection and theme
        // Use the passed selectedColor or fallback to theme highlight
        final Color effectiveSelectedColor =
            widget.selectedColor ?? theme.highlightColor.withValues(alpha: 0.3);
        final Color defaultCardColor = theme.cardColor;
        final cardColor =
            widget.isSelected ? effectiveSelectedColor : defaultCardColor;

        return Card(
          margin: effectiveMargin,
          elevation: scaledElevation,
          clipBehavior: widget.clipBehavior,
          color: cardColor,
          child: InkWell(
            onTapDown: (_) {
              widget.onTapDown?.call();
            },
            onTap: () {
              final now = DateTime.now();
              final isDoubleTap =
                  _lastTapTime != null &&
                  now.difference(_lastTapTime!) < kDoubleTapTimeout;

              if (isDoubleTap) {
                widget.onDoubleTap?.call();
                _lastTapTime = null;
              } else {
                widget.onTap?.call();
                _lastTapTime = now;
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: widget.child,
          ),
        );
      },
    );
  }
}
