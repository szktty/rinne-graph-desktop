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

/// Common RadioButton for App app.
///
/// Provides a unified RadioButton style across the app.
/// It has a circular shape, and when selected, a small circle is displayed in the center.
class AppRadioButton<T> extends ConsumerWidget {
  /// Value of the radio button.
  final T value;

  /// Currently selected group value.
  final T? groupValue;

  /// Callback when the value changes.
  final ValueChanged<T?>? onChanged;

  /// Size of the radio button.
  final double? size;

  /// Focus node of the radio button.
  final FocusNode? focusNode;

  /// Whether the radio button autofocuses.
  final bool autofocus;

  /// Semantic label.
  final String? semanticLabel;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  /// Active color (uses theme color if not specified).
  final Color? activeColor;

  const AppRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.disableZoom = false,
    this.activeColor,
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

    // Determine selected state
    final isSelected = value == groupValue;

    // Determine color
    final effectiveActiveColor =
        activeColor ?? appColorScheme.theme.primaryColor;
    final borderColor =
        isSelected ? effectiveActiveColor : appColorScheme.base.border;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        child: Semantics(
          label: semanticLabel,
          checked: isSelected,
          child: Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2.0 * borderScale),
            ),
            child:
                isSelected
                    ? Center(
                      child: Container(
                        width: effectiveSize * 0.5,
                        height: effectiveSize * 0.5,
                        decoration: BoxDecoration(
                          color: effectiveActiveColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
