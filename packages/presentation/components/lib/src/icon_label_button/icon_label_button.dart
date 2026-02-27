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

/// A button that displays an icon and a label with optional trailing widget.
class IconLabelButton extends ConsumerWidget {
  const IconLabelButton({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.onPressed,
    this.isSelected = false,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 12.0,
    this.iconSpacing = 12.0,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.hoverBackgroundColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.disableZoom = false,
    super.key,
  });

  /// The icon to display.
  final Widget icon;

  /// The label to display.
  final String label;

  /// Optional widget to display after the label.
  final Widget? trailing;

  /// Called when the button is tapped.
  @Deprecated('Use onPressed instead')
  final VoidCallback? onTap;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether this button is currently selected.
  final bool isSelected;

  /// Horizontal padding for the button content.
  final double horizontalPadding;

  /// Vertical padding for the button content.
  final double verticalPadding;

  /// Space between the icon and label.
  final double iconSpacing;

  /// Background color in normal state.
  final Color? backgroundColor;

  /// Background color when selected.
  final Color? selectedBackgroundColor;

  /// Background color when hovered.
  final Color? hoverBackgroundColor;

  /// Text style for the label in normal state.
  final TextStyle? labelStyle;

  /// Text style for the label when selected.
  final TextStyle? selectedLabelStyle;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final themeData = ref.watch(effectiveThemeDataProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Default colors based on rinne_graph_desktop theme
    final defaultBackgroundColor = Colors.transparent;
    final defaultSelectedBackgroundColor = appColorScheme
        .appSpecific
        .graph
        .nodeBase
        .withValues(alpha: 0.2);

    // Default text styles
    final defaultLabelStyle = themeData.textTheme.bodyLarge;
    final defaultSelectedLabelStyle = themeData.textTheme.bodyLarge?.copyWith(
      color: appColorScheme.appSpecific.graph.nodeBase,
      fontWeight: FontWeight.bold,
    );

    // Use onPressed if available, otherwise fall back to onTap
    final callback = onPressed ?? onTap;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: callback,
        child: MouseRegion(
          cursor:
              callback != null
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * zoomScale,
              vertical: verticalPadding * zoomScale,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? (selectedBackgroundColor ??
                          defaultSelectedBackgroundColor)
                      : (backgroundColor ?? defaultBackgroundColor),
            ),
            child: Row(
              children: [
                IconTheme(
                  data: IconThemeData(
                    color:
                        isSelected
                            ? appColorScheme.appSpecific.graph.nodeBase
                            : appColorScheme.uiAreas.sideBar.inactiveItemText,
                  ),
                  child: icon,
                ),
                SizedBox(width: iconSpacing * zoomScale),
                Expanded(
                  child: Text(
                    label,
                    style:
                        isSelected
                            ? (selectedLabelStyle ?? defaultSelectedLabelStyle)
                                ?.copyWith(
                                  fontSize:
                                      ((selectedLabelStyle ??
                                                  defaultSelectedLabelStyle)
                                              ?.fontSize ??
                                          14) *
                                      zoomScale,
                                )
                            : (labelStyle ?? defaultLabelStyle)?.copyWith(
                              fontSize:
                                  ((labelStyle ?? defaultLabelStyle)
                                          ?.fontSize ??
                                      14) *
                                  zoomScale,
                            ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
