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
import 'app_text.dart';

/// A utility class that builds a TextStyle from an AppTextVariant.
///
/// Generates a TextStyle using the same logic as the AppText component.
/// This allows it to automatically follow changes in the AppTextVariant
/// specification.
class AppTextStyleBuilder {
  /// Build a TextStyle from an AppTextVariant.
  ///
  /// [variant] - The text variant.
  /// [context] - BuildContext (for getting TextTheme).
  /// [ref] - WidgetRef (for getting color scope).
  /// [color] - Custom text color (optional).
  /// [fontWeight] - Custom font weight (optional).
  /// [fontFamily] - Custom font family (optional).
  /// [disableZoom] - Whether to disable the zoom function (default: false).
  static TextStyle buildTextStyle({
    required AppTextVariant variant,
    required BuildContext context,
    required WidgetRef ref,
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    bool disableZoom = false,
  }) {
    // Get text style from ThemeData
    final flutterTheme = Theme.of(context);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return _buildTextStyle(
      variant,
      flutterTheme.textTheme,
      flutterTheme.colorScheme,
      zoomScale,
      ref,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Build a TextStyle from an AppTextVariant (internal implementation).
  ///
  /// Same logic as the _buildTextStyle method of the AppText component.
  static TextStyle _buildTextStyle(
    AppTextVariant variant,
    TextTheme textTheme,
    ColorScheme colorScheme,
    double zoomScale,
    WidgetRef ref, {
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    // Get typography settings from the active theme
    final baseStyle = switch (variant) {
      // === New role-based variants ===

      // For UI structure
      AppTextVariant.pageTitle => textTheme.headlineLarge,

      // Dialog title (by importance)
      AppTextVariant.dialogTitleCritical => textTheme.headlineMedium, // 28px
      AppTextVariant.dialogTitleStandard => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      AppTextVariant.dialogTitleUtility => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      // Section title (by importance)
      AppTextVariant.sectionTitlePrimary => textTheme.headlineSmall, // 24px
      AppTextVariant.sectionTitleSecondary => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      AppTextVariant.sectionTitleUtility => textTheme.bodyMedium, // 16px

      AppTextVariant.itemTitle => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),

      // For interaction
      AppTextVariant.buttonLabel => textTheme.bodyMedium,
      AppTextVariant.labelText => textTheme.bodyMedium,
      AppTextVariant.inputText => textTheme.bodyMedium,

      // For information display
      AppTextVariant.bodyText => textTheme.bodyMedium,
      AppTextVariant.captionText => textTheme.bodySmall,
      AppTextVariant.smallText => textTheme.labelSmall,

      // For tables (extended)
      AppTextVariant.tableTitle => textTheme.titleLarge,
      AppTextVariant.tableHeader => textTheme.titleMedium,
      AppTextVariant.tableBody => textTheme.bodyMedium,
      AppTextVariant.tableCell => textTheme.bodyMedium,
      AppTextVariant.tableCellEditing => textTheme.bodyMedium,
      AppTextVariant.tableRowHeader => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      AppTextVariant.tableCellSmall => textTheme.bodySmall,

      // === Existing variants (content scale) ===

      // For user-generated content
      AppTextVariant.textHeading1 => textTheme.displayLarge,
      AppTextVariant.textHeading2 => textTheme.displayMedium,
      AppTextVariant.textHeading3 => textTheme.displaySmall,
      AppTextVariant.textHeading4 => textTheme.headlineSmall,
      AppTextVariant.textBody => textTheme.bodyLarge,
      AppTextVariant.textCaption => textTheme.bodyMedium,
      AppTextVariant.textSmall => textTheme.bodySmall,

      // Code block related
      AppTextVariant.codeBlock => textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
      ),
      AppTextVariant.codeInline => textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
      ),

      // === Deprecated variants (backward compatibility) ===
      AppTextVariant.uiHeading1 => textTheme.headlineLarge,
      AppTextVariant.uiHeading2 => textTheme.headlineMedium,
      AppTextVariant.uiHeading3 => textTheme.headlineSmall,
      AppTextVariant.uiBody => textTheme.bodyMedium,
      AppTextVariant.uiCaption => textTheme.bodySmall,
      AppTextVariant.uiSmall => textTheme.labelSmall,

      // === Backward compatibility aliases ===
      AppTextVariant.dialogTitle =>
        textTheme.headlineMedium, // -> dialogTitleCritical
      AppTextVariant.sectionTitle =>
        textTheme.headlineSmall, // -> sectionTitlePrimary
      // === Existing special variants ===

      // Table related (existing)
      AppTextVariant.tableFooter => textTheme.bodySmall,

      // Label related
      AppTextVariant.entityLabelPrimary => textTheme.labelLarge,
      AppTextVariant.entityLabelSecondary => textTheme.labelMedium,
      AppTextVariant.entityLabelMeta => textTheme.labelSmall,

      // Page title related (existing)
      AppTextVariant.pageTitleLarge => textTheme.headlineLarge,
      AppTextVariant.pageTitleMedium => textTheme.headlineSmall,
      AppTextVariant.pageTitleSmall => textTheme.bodyLarge,
    };

    // Try to get the color scope
    Color textColor;
    try {
      final colorScope = ref.read(colorScopeProvider);
      textColor = color ?? colorScope.text;
    } catch (e) {
      // Fallback if color scope is not available
      textColor = color ?? colorScheme.onSurface;
    }

    final scaledStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: textColor,
      fontWeight: fontWeight, // Apply fontWeight
      fontFamily: fontFamily, // Apply custom font family
    );

    // Apply zoom scale to the font size
    if (scaledStyle.fontSize != null) {
      return scaledStyle.copyWith(fontSize: scaledStyle.fontSize! * zoomScale);
    }

    return scaledStyle;
  }

  /// Helper method to build a TextStyle with a specific color.
  ///
  /// Applies the specified color directly without using a color scope.
  static TextStyle buildTextStyleWithColor({
    required AppTextVariant variant,
    required BuildContext context,
    required WidgetRef ref,
    required Color color,
    FontWeight? fontWeight,
    String? fontFamily,
    bool disableZoom = false,
  }) {
    return buildTextStyle(
      variant: variant,
      context: context,
      ref: ref,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      disableZoom: disableZoom,
    );
  }
}
