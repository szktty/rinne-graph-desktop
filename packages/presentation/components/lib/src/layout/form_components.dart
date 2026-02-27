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
import '../widgets/app_expansion_tile.dart';

/// Form item component (horizontal layout).
/// Arranges labels and controls in a single row.
///
/// Note: Basically, do not use description; clearly express the content
/// with the label name.
class FormItemRow extends ConsumerWidget {
  const FormItemRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 200,
    this.spacing = 16,
    this.description,
    this.alignment = Alignment.centerLeft,
  });

  /// Label text.
  final String label;

  /// Setting component (Switch, DropdownButton, etc.).
  final Widget child;

  /// The width of the label column.
  final double labelWidth;

  /// Space between the label and the component.
  final double spacing;

  /// Optional description text.
  final String? description;

  /// Alignment of the control part (default: centerLeft).
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(label, variant: AppTextVariant.labelText),
              if (description != null) ...[
                const SizedBox(height: 4),
                AppText(
                  description!,
                  variant: AppTextVariant.captionText,
                  color: appColorScheme.base.foreground.withAlpha(128),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: spacing),
        Expanded(child: child),
      ],
    );
  }
}

/// Form item component (deprecated).
///
/// Please use [FormItemRow].
@Deprecated(
  'Please use FormItemRow. This class will be removed in a future version.',
)
class FormItem extends FormItemRow {
  const FormItem({
    super.key,
    required super.label,
    required super.child,
    super.labelWidth = 200,
    super.spacing = 16,
    super.description,
    super.alignment = Alignment.centerLeft,
  });
}

/// Form item component (vertical layout).
/// Arranges labels and controls vertically.
///
/// Used in sidebars, etc. where width is limited.
class FormItemColumn extends ConsumerWidget {
  const FormItemColumn({
    super.key,
    required this.label,
    required this.child,
    this.spacing = 8,
    this.description,
    this.disableZoom = false,
  });

  /// Label text.
  final String label;

  /// Setting component (TextField, DropdownButton, etc.).
  final Widget child;

  /// Space between the label and the component.
  final double spacing;

  /// Optional description text.
  final String? description;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              variant: AppTextVariant.labelText,
              disableZoom: disableZoom,
            ),
            if (description != null) ...[
              SizedBox(height: 4 * zoomScale),
              AppText(
                description!,
                variant: AppTextVariant.captionText,
                color: appColorScheme.base.foreground.withAlpha(128),
                disableZoom: disableZoom,
              ),
            ],
          ],
        ),
        SizedBox(height: spacing * zoomScale),
        child,
      ],
    );
  }
}

/// Form list component.
///
/// A component that groups a list of form items or a single child element.
/// Also integrates the functionality of SettingsSection, including right-end
/// widgets and accessibility support.
/// It can also be made collapsible using AppExpansionTile.
class FormList extends ConsumerWidget {
  const FormList({
    super.key,
    this.title,
    this.children,
    this.child,
    this.labelWidth = 200,
    this.titleVariant = AppTextVariant.labelText,
    this.rightWidget,
    this.headerPadding = const EdgeInsets.only(
      bottom: 8.0,
    ), // Changed from 12px to 8px
    this.itemSpacing = 8.0,
    this.bottomPadding =
        8.0, // Bottom padding for the last child element (changed from 16px to 8px)
    this.disableZoom = false,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
    this.expansionController,
  }) : assert(
         (children != null && child == null) ||
             (children == null && child != null),
         'Either children or child must be provided, but not both',
       );

  /// Section title.
  final String? title;

  /// List of form rows (for a list of FormItems).
  final List<Widget>? children;

  /// Single child element (for SettingsSection compatibility).
  final Widget? child;

  /// Common label width for all rows (used only for children).
  final double labelWidth;

  /// Typography variant for the title.
  final AppTextVariant titleVariant;

  /// A widget to place at the right end of the title.
  final Widget? rightWidget;

  /// Padding between the title and the child elements.
  final EdgeInsets headerPadding;

  /// Space between form items.
  final double itemSpacing;

  /// Bottom padding for the last child element.
  final double bottomPadding;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Whether to make it collapsible.
  final bool collapsible;

  /// Initial expanded state (only valid when collapsible is true)
  final bool initiallyExpanded;

  /// Callback when expansion state changes (only valid when collapsible is true)
  final ValueChanged<bool>? onExpansionChanged;

  /// ExpansibleController (only valid when collapsible is true)
  final ExpansibleController? expansionController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final scaledHeaderPadding = EdgeInsets.only(
      left: headerPadding.left * zoomScale,
      top: headerPadding.top * zoomScale,
      right: headerPadding.right * zoomScale,
      bottom: headerPadding.bottom * zoomScale,
    );

    final scaledItemSpacing = itemSpacing * zoomScale;
    final scaledBottomPadding = bottomPadding * zoomScale;

    // Build the content of the child elements
    final contentChildren = <Widget>[];
    if (children != null) {
      contentChildren.addAll(
        children!.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          return Column(
            children: [
              child,
              if (index < children!.length - 1)
                SizedBox(height: scaledItemSpacing),
            ],
          );
        }),
      );
      // Bottom padding for the last child element
      contentChildren.add(SizedBox(height: scaledBottomPadding));
    } else {
      contentChildren.add(child!);
      // Add bottom padding even for a single child element
      contentChildren.add(SizedBox(height: scaledBottomPadding));
    }

    // Use AppExpansionTile if collapsible
    if (collapsible) {
      return AppExpansionTile(
        title: Row(
          children: [
            if (title != null) ...[
              Expanded(
                child: AppText(
                  title!,
                  variant: titleVariant,
                  fontWeight: FontWeight.bold,
                  color: appColorScheme.base.foreground,
                  disableZoom: disableZoom,
                ),
              ),
            ],
            if (rightWidget != null) ...[
              const SizedBox(width: 8),
              rightWidget!,
            ],
          ],
        ),
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
        controller: expansionController,
        childrenPadding: EdgeInsets.only(top: scaledHeaderPadding.bottom),
        children: contentChildren,
      );
    }

    // Normal display
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || rightWidget != null) ...[
            // Header part
            Row(
              children: [
                if (title != null) ...[
                  Expanded(
                    child: AppText(
                      title!,
                      variant: titleVariant,
                      fontWeight: FontWeight.bold, // Set to bold
                      color: appColorScheme.base.foreground,
                      disableZoom: disableZoom,
                    ),
                  ),
                ],
                if (rightWidget != null) ...[
                  const SizedBox(width: 8),
                  rightWidget!,
                ],
              ],
            ),
            // Padding
            SizedBox(height: scaledHeaderPadding.bottom),
          ],
          // Child elements
          ...contentChildren,
        ],
      ),
    );
  }
}
