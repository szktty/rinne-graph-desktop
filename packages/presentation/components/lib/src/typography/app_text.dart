import 'package:core_themes/core_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_text.g.dart';

/// Provider for effective theme data
@riverpod
AppThemeData effectiveThemeDataForText(EffectiveThemeDataForTextRef ref) {
  return AppThemePresets.light;
}

/// The available text variants for AppText.
///
/// These variants map to different font categories and styles within the application.
/// Each variant represents a specific use case and may use different font families
/// depending on the active theme settings.
enum AppTextVariant {
  // === New role-based variants (component role) ===

  // For UI structure
  pageTitle, // Page title (headlineLarge, 32px)
  // Dialog titles (by importance)
  dialogTitleCritical, // Critical dialog title (headlineMedium, 28px) - errors, warnings, destructive actions
  dialogTitleStandard, // Standard dialog title (bodyMedium Bold, 16px) - settings, forms, general actions
  dialogTitleUtility, // Utility dialog title (bodyMedium Bold, 16px) - filters, search, auxiliary functions
  // Section titles (by importance)
  sectionTitlePrimary, // Primary section title (headlineSmall, 24px) - main content area
  sectionTitleSecondary, // Secondary section title (bodyMedium Bold, 16px) - sidebar, panels
  sectionTitleUtility, // Utility section title (bodyMedium, 16px) - filters, lightweight sections

  itemTitle, // List/grid item name (bodyMedium Bold, 16px)
  // For interaction
  buttonLabel, // Button label (bodyMedium, 16px)
  labelText, // Form element label (bodyMedium, 16px)
  inputText, // Text field input (bodyMedium, 16px)
  // For information display
  bodyText, // Standard text/description (bodyMedium, 16px)
  captionText, // Auxiliary info/small description (bodySmall, 14px)
  smallText, // Small label/badge (labelSmall, 11px)
  // For table (extended)
  tableTitle, // Table title (titleLarge)
  tableHeader, // Table header (titleMedium)
  tableBody, // Table body (bodyMedium)
  tableCell, // Normal cell (bodyMedium)
  tableCellEditing, // Editing cell (bodyMedium)
  tableRowHeader, // Row header (bodyMedium Bold)
  tableCellSmall, // Small cell content (bodySmall)
  // === Existing variants (content scale) ===

  // For user-generated content (existing)
  textHeading1, // Document top-level heading
  textHeading2, // Chapter title
  textHeading3, // Section title
  textHeading4, // Subtitle/catchphrase
  textBody, // Body text
  textCaption, // Caption
  textSmall, // Supplementary text (content area)
  // Code block related (existing)
  codeBlock, // Code block body
  codeInline, // Inline code
  // === Deprecated variants (planned for gradual removal) ===
  @Deprecated('Use pageTitle, sectionTitlePrimary, or itemTitle instead')
  uiHeading1, // Large heading (UI component)

  @Deprecated('Use sectionTitlePrimary or itemTitle instead')
  uiHeading2, // Medium heading (UI component)

  @Deprecated('Use itemTitle or bodyText instead')
  uiHeading3, // Small heading (UI component)

  @Deprecated('Use bodyText instead')
  uiBody, // Body text (UI component)

  @Deprecated('Use captionText instead')
  uiCaption, // Caption (UI component)

  @Deprecated('Use smallText instead')
  uiSmall, // Small text (UI component)
  // === Backward compatibility aliases ===
  @Deprecated(
    'Use dialogTitleCritical, dialogTitleStandard, or dialogTitleUtility instead',
  )
  dialogTitle, // Old dialog title -> dialogTitleCritical

  @Deprecated(
    'Use sectionTitlePrimary, sectionTitleSecondary, or sectionTitleUtility instead',
  )
  sectionTitle, // Old section title -> sectionTitlePrimary
  // === Existing special variants (maintained) ===

  // Table related (existing)
  tableFooter, // Table footer
  // Label related (renamed)
  entityLabelPrimary, // labelPrimary -> entityLabelPrimary
  entityLabelSecondary, // labelSecondary -> entityLabelSecondary
  entityLabelMeta, // labelMeta -> entityLabelMeta
  // Page title related (existing)
  pageTitleLarge, // Page title (large)
  pageTitleMedium, // Page title (medium)
  pageTitleSmall, // Page title (small, normal text size)
}

/// A text widget that automatically applies typography styles based on the app theme.
class AppText extends ConsumerWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  /// Custom font family
  final String? fontFamily;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  const AppText(
    this.text, {
    required this.variant,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontFamily,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current ThemeData
    final themeData = ref.watch(effectiveThemeDataForTextProvider);
    // Get accessibility settings
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Get text style from ThemeData
    final flutterTheme = Theme.of(context);

    return Text(
      text,
      style: _buildTextStyle(
        flutterTheme.textTheme,
        flutterTheme.colorScheme,
        zoomScale,
        ref,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _buildTextStyle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    double zoomScale,
    WidgetRef ref,
  ) {
    // Get typography settings from active theme
    final baseStyle = switch (variant) {
      // === New role-based variants ===

      // For UI structure
      AppTextVariant.pageTitle => textTheme.headlineLarge,

      // Dialog titles (by importance)
      AppTextVariant.dialogTitleCritical => textTheme.headlineMedium, // 28px
      AppTextVariant.dialogTitleStandard => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      AppTextVariant.dialogTitleUtility => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      // Section titles (by importance)
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

      // For table (extended)
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

    // Try to get color scope
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
}
