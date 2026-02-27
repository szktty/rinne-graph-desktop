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
import 'app_rectangle_border.dart';
import '../icons/app_icons.dart';

/// Common Checkbox for App app.
///
/// Provides a unified Checkbox style across the app.
/// Features smooth corners and a gray border using AppRectangleBorder,
/// and uses LucideIcons.check for the check icon.
class AppCheckbox extends ConsumerWidget {
  /// Value of the checkbox.
  final bool? value;

  /// Callback when the value changes.
  final ValueChanged<bool?>? onChanged;

  /// Whether the checkbox has three states.
  final bool tristate;

  /// Size of the checkbox.
  final double? size;

  /// Focus node of the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox autofocuses.
  final bool autofocus;

  /// Semantic label.
  final String? semanticLabel;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.size,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme color using core_themes API
    final appColorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Determine size (use default value if not specified)
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final effectiveSize = (size ?? 20.0) * zoomScale;

    // AppRectangleBorder settings
    final borderRadius = AppBorderRadius.create(
      cornerRadius: 4.0 * zoomScale,
      cornerSmoothing: 0.6,
    );

    // Determine background and border colors
    final backgroundColor =
        value == true
            ? appColorScheme.theme.primaryColor
            : const Color(0x00000000);
    final borderColor = appColorScheme.base.border;

    return GestureDetector(
      onTap:
          onChanged != null
              ? () {
                if (tristate) {
                  // For tristate: false -> true -> null -> false
                  if (value == false) {
                    onChanged!(true);
                  } else if (value == true) {
                    onChanged!(null);
                  } else {
                    onChanged!(false);
                  }
                } else {
                  // For dual-state: false -> true -> false
                  onChanged!(!(value ?? false));
                }
              }
              : null,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        child: Semantics(
          label: semanticLabel,
          checked: value,
          child: Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: SmoothRectangleBorder(
                borderRadius: borderRadius.toSmoothBorderRadius(),
                side: BorderSide(color: borderColor, width: 1.5 * borderScale),
              ),
            ),
            child:
                value == true
                    ? Icon(
                      AppIcons.check,
                      size: effectiveSize * 0.6,
                      color:
                          appColorScheme.brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                    )
                    : value == null && tristate
                    ? Container(
                      margin: EdgeInsets.all(effectiveSize * 0.25),
                      decoration: BoxDecoration(
                        color: appColorScheme.base.border,
                        borderRadius: BorderRadius.circular(1.0 * zoomScale),
                      ),
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
