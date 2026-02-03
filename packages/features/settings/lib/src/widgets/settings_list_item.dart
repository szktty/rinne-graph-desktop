import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import '../models/settings_item.dart';

/// List item component for the settings screen.
///
/// A dedicated list item used in the left-side list of the settings screen.
/// It is designed with the appropriate granularity as a list item, not a card.
class SettingsListItem extends ConsumerWidget {
  /// Data for the settings item.
  final SettingsItem item;

  /// Selection state.
  final bool isSelected;

  /// Callback on tap.
  final VoidCallback? onTap;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  const SettingsListItem({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Zoom support
    final zoomScale = accessibilityConfig.zoomScale;

    // Determine color based on selection state
    final backgroundColor =
        isSelected
            ? colorScheme.interactive.list.selectedBackground
            : Colors.transparent;

    final textColor =
        isSelected
            ? colorScheme.interactive.button.primaryText
            : colorScheme.base.foreground;

    final iconColor =
        isSelected
            ? colorScheme.interactive.button.primaryText
            : colorScheme.base.foreground;

    Widget listItem = AppBorderContainer(
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(AppBorderRadiusValues.small),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacingValues.md * zoomScale, // 12px
          vertical: AppSpacingValues.sm * zoomScale, // 8px
        ),
        child: Row(
          children: [
            AppIcon(
              item.icon,
              size: AppIconSize.medium,
              customColor: iconColor,
            ),
            SizedBox(width: AppSpacingValues.md * zoomScale),
            Expanded(
              child: AppText(
                item.title,
                variant: AppTextVariant.bodyText,
                color: textColor,
              ),
            ),
            if (item.badge != null) ...[
              SizedBox(width: AppSpacingValues.md * zoomScale),
              item.badge!,
            ],
          ],
        ),
      ),
    );

    // Add tap functionality
    if (onTap != null) {
      listItem = GestureDetector(onTap: onTap, child: listItem);
    }

    return listItem;
  }
}

/// Data class for settings list items.
class SettingsListItemData {
  final IconData icon;
  final String title;
  final Widget? badge;

  const SettingsListItemData({
    required this.icon,
    required this.title,
    this.badge,
  });
}
