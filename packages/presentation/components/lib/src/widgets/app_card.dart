/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import '../styling/app_border_radius.dart';
import 'app_rectangle_border.dart';

/// App general-purpose card component
///
/// Small panel component with header, content, and footer structure.
/// Used at the granularity of entire panel or one container level of panel,
/// expressing related information and actions as a unified whole.
///
/// Usage examples:
/// - Entire detail area of settings screen
/// - Form section
/// - Information panel
/// - Dashboard widget
class AppCard extends ConsumerStatefulWidget {
  /// Card header section
  final Widget? header;

  /// Card main content (required)
  final Widget content;

  /// Card footer section
  final Widget? footer;

  /// Inner padding (predefined tokens recommended)
  final EdgeInsetsGeometry? padding;

  /// Outer padding (predefined tokens recommended)
  final EdgeInsetsGeometry? margin;

  /// Background color (auto-fetched from theme if null)
  final Color? backgroundColor;

  /// Corner radius (use predefined values only)
  final double? cornerRadius;

  /// Border style
  final BorderSide? borderSide;

  /// Width
  final double? width;

  /// Height
  final double? height;

  /// Alignment
  final AlignmentGeometry alignment;

  /// Whether to disable zoom support
  final bool disableZoom;

  // === Selection feature ===
  /// Selection state
  final bool isSelected;

  /// Background color when selected (auto-fetched from theme if null)
  final Color? selectedBackgroundColor;

  /// Border color when selected (auto-fetched from theme if null)
  final Color? selectedBorderColor;

  /// Border width when selected
  final double selectedBorderWidth;

  // === Tap feature ===
  /// Callback on tap
  final VoidCallback? onTap;

  /// Callback on double-tap
  final VoidCallback? onDoubleTap;

  /// Callback on long press
  final VoidCallback? onLongPress;

  /// Callback on tap down (called immediately)
  final VoidCallback? onTapDown;

  /// Callback on hover
  final ValueChanged<bool>? onHover;

  /// Cursor type
  final MouseCursor cursor;

  /// Whether to disable tap animation
  final bool disableInkWell;

  const AppCard({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.cornerRadius,
    this.borderSide,
    this.width,
    this.height,
    this.alignment = Alignment.topLeft,
    this.disableZoom = false,
    this.isSelected = false,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 2.0,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onHover,
    this.cursor = SystemMouseCursors.basic,
    this.disableInkWell = true,
  });

  @override
  ConsumerState<AppCard> createState() => _AppCardState();
}

class _AppCardState extends ConsumerState<AppCard> {
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Zoom support
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Determine effective values
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.base.background;
    final effectiveCornerRadius =
        widget.cornerRadius ?? AppBorderRadiusValues.medium;

    // Calculate margin with zoom support
    EdgeInsetsGeometry? effectiveMargin;
    if (widget.margin != null) {
      if (widget.margin is EdgeInsets) {
        final edgeInsets = widget.margin as EdgeInsets;
        effectiveMargin = EdgeInsets.only(
          left: edgeInsets.left * zoomScale,
          top: edgeInsets.top * zoomScale,
          right: edgeInsets.right * zoomScale,
          bottom: edgeInsets.bottom * zoomScale,
        );
      } else {
        effectiveMargin = widget.margin! * zoomScale;
      }
    }

    // Handle selection state
    Color finalBackgroundColor = effectiveBackgroundColor;
    BorderSide? finalBorderSide = widget.borderSide;

    if (widget.isSelected) {
      finalBackgroundColor =
          widget.selectedBackgroundColor ??
          colorScheme.interactive.list.selectedBackground.withValues(
            alpha: 0.1,
          );
      finalBorderSide = BorderSide(
        color: widget.selectedBorderColor ?? colorScheme.theme.primaryColor,
        width: widget.selectedBorderWidth * zoomScale,
      );
    }

    // Build card content
    Widget cardContent = _buildCardContent();

    // Build card
    Widget card = AppRectangleBorder(
      cornerRadius: effectiveCornerRadius,
      color: finalBackgroundColor,
      side: finalBorderSide,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      child: cardContent,
    );

    // Add tap functionality
    if (widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onLongPress != null ||
        widget.onTapDown != null ||
        widget.onHover != null) {
      card = _wrapWithTapHandling(card);
    }

    // Apply margin
    if (effectiveMargin != null) {
      card = Padding(padding: effectiveMargin, child: card);
    }

    return card;
  }

  /// Build card content (header, content, footer)
  Widget _buildCardContent() {
    final List<Widget> children = [];

    // Header
    if (widget.header != null) {
      children.add(widget.header!);
      children.add(const SizedBox(height: 16.0));
    }

    // Main content
    // Use Expanded only if height is specified
    if (widget.height != null &&
        (widget.header != null || widget.footer != null)) {
      children.add(Expanded(child: widget.content));
    } else {
      children.add(widget.content);
    }

    // Footer
    if (widget.footer != null) {
      children.add(const SizedBox(height: 16.0));
      children.add(widget.footer!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _wrapWithTapHandling(Widget child) {
    Widget result = child;

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
    if (widget.disableInkWell) {
      // Without InkWell (animation disabled)
      result = GestureDetector(
        onTapDown: widget.onTapDown != null ? (_) => widget.onTapDown!() : null,
        onTap: _handleTap,
        onLongPress: widget.onLongPress,
        child: result,
      );
    } else {
      // With InkWell (animation enabled)
      result = InkWell(
        onTapDown: widget.onTapDown != null ? (_) => widget.onTapDown!() : null,
        onTap: _handleTap,
        onLongPress: widget.onLongPress,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: result,
      );
    }

    return result;
  }

  void _handleTap() {
    if (widget.onDoubleTap != null) {
      // Double-tap detection logic
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
      // Single-tap only
      widget.onTap?.call();
    }
  }
}
