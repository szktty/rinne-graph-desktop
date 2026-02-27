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
import 'package:figma_squircle/figma_squircle.dart';
import '../styling/app_border_radius.dart';

/// Shape of the icon button
enum AppIconButtonShape {
  /// Rectangle (rounded corners)
  rectangle,

  /// Circular
  circle,
}

/// App app common IconButton
///
/// Functions as a wrapper for Flutter's standard IconButton,
/// and automatically applies AppColorScheme's theme colors.
class AppIconButton extends ConsumerWidget {
  /// Icon
  final IconData icon;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Icon size
  final double? iconSize;

  /// Icon color (uses theme color if not specified)
  final Color? iconColor;

  /// Background color of the button (transparent if not specified)
  final Color? backgroundColor;

  /// Background color on hover
  final Color? hoverColor;

  /// Background color on focus
  final Color? focusColor;

  /// Highlight color on press
  final Color? highlightColor;

  /// Splash color
  final Color? splashColor;

  /// Color when disabled
  final Color? disabledColor;

  /// Tooltip
  final String? tooltip;

  /// Enabled/disabled state
  final bool enabled;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Alignment
  final AlignmentGeometry alignment;

  /// Splash radius
  final double? splashRadius;

  /// Focus node
  final FocusNode? focusNode;

  /// Corner radius (uses AppBorderRadiusValues.medium if not specified)
  final double? cornerRadius;

  /// Corner smoothing (uses 0.6 if not specified)
  final double? cornerSmoothing;

  /// Border settings
  final BorderSide? border;

  /// Button size constraints (used for padding control)
  final BoxConstraints? constraints;

  /// Button shape (rectangle or circle)
  final AppIconButtonShape shape;

  /// Constructor
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding,
    this.alignment = Alignment.center,
    this.splashRadius,
    this.focusNode,
    this.cornerRadius,
    this.cornerSmoothing,
    this.border,
    this.constraints,
    this.shape = AppIconButtonShape.rectangle,
  });

  /// Compact icon button (minimum padding)
  const AppIconButton.compact({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding,
    this.alignment = Alignment.center,
    this.splashRadius,
    this.focusNode,
    this.cornerRadius,
    this.cornerSmoothing,
    this.border,
    this.shape = AppIconButtonShape.rectangle,
  }) : constraints = const BoxConstraints(minWidth: 24, minHeight: 24);

  /// Minimal icon button (no padding)
  const AppIconButton.minimal({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.splashRadius,
    this.focusNode,
    this.cornerRadius,
    this.cornerSmoothing,
    this.border,
    this.shape = AppIconButtonShape.rectangle,
  }) : constraints = const BoxConstraints();

  /// Circular icon button (with background color)
  const AppIconButton.circle({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.splashRadius,
    this.focusNode,
    this.cornerRadius,
    this.cornerSmoothing,
    this.border,
    this.constraints,
  }) : shape = AppIconButtonShape.circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme color using core_themes API
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Scaling based on accessibility settings
    final zoomScale = accessibilityConfig.zoomScale;
    final effectiveIconSize = iconSize != null ? iconSize! * zoomScale : null;

    // Use custom corner radius settings or default values
    final effectiveCornerRadius = cornerRadius ?? AppBorderRadiusValues.medium;
    final effectiveCornerSmoothing = cornerSmoothing ?? 0.6;

    // Create shape based on the button's form
    final buttonShape = switch (shape) {
      AppIconButtonShape.circle => CircleBorder(
        side: border ?? const BorderSide(style: BorderStyle.none),
      ),
      AppIconButtonShape.rectangle => SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: effectiveCornerRadius,
          cornerSmoothing: effectiveCornerSmoothing,
        ),
        side: border ?? const BorderSide(style: BorderStyle.none),
      ),
    };

    final effectiveIconColor = iconColor ?? appColorScheme.base.foreground;

    return IconButton(
      icon: Icon(icon, color: effectiveIconColor),
      onPressed: enabled ? onPressed : null,
      iconSize: effectiveIconSize,
      hoverColor:
          hoverColor ?? appColorScheme.interactive.list.itemBackground.hover,
      focusColor:
          focusColor ??
          appColorScheme.appSpecific.graph.nodeBase.withValues(alpha: 0.1),
      highlightColor:
          highlightColor ??
          appColorScheme.appSpecific.graph.nodeBase.withValues(alpha: 0.2),
      splashColor:
          splashColor ??
          appColorScheme.appSpecific.graph.nodeBase.withValues(alpha: 0.3),
      disabledColor:
          disabledColor ?? appColorScheme.interactive.button.border.disabled,
      tooltip: tooltip,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      focusNode: focusNode,
      constraints: constraints,
      style: ButtonStyle(shape: WidgetStateProperty.all(buttonShape)),
    );
  }
}
