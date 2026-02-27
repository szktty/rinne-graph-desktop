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
import '../icons/app_icons.dart';

/// Menu that contains features that cannot be displayed due to screen size
///
/// This component is used to achieve responsive UI,
/// displaying items that cannot be shown when screen size becomes small as a menu.
class OverflowMenu extends ConsumerWidget {
  /// List of items to display in menu
  final List<OverflowMenuItem> items;

  /// Menu icon
  final IconData icon;

  /// Icon color
  final Color? iconColor;

  /// Icon size
  final double iconSize;

  /// Menu description (tooltip)
  final String? tooltip;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Create [OverflowMenu]
  ///
  /// [items] - List of items to display in menu
  /// [icon] - Menu icon
  /// [iconColor] - Icon color
  /// [iconSize] - Icon size
  /// [tooltip] - Menu description (tooltip)
  const OverflowMenu({
    super.key,
    required this.items,
    this.icon = AppIcons.moreVert,
    this.iconColor,
    this.iconSize = 24.0,
    this.tooltip = 'More options',
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // Pre-build and cache menu items
    final menuEntries = _buildMenuItems(items, appColorScheme, zoomScale);

    // Handle menu selection
    void handleSelected(String value) {
      final selectedItem = items.firstWhere(
        (item) => item.value == value,
        orElse: () => OverflowMenuItem(title: '', value: value),
      );
      selectedItem.onSelected?.call(value);
    }

    return PopupMenuButton<String>(
      // Fine-tune offset for fast display
      offset: Offset(0.0, (4.0 * zoomScale).toDouble()),
      // Use simple transition for fast display
      popUpAnimationStyle: AnimationStyle.noAnimation,
      // Use pre-built menu items
      itemBuilder: (_) => menuEntries,
      // Pre-built selection handler
      onSelected: handleSelected,
      tooltip: tooltip,
      // Visual improvement
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0 * borderScale),
      ),
      // Icon configuration
      icon: Icon(
        icon,
        color: iconColor ?? appColorScheme.uiAreas.sideBar.inactiveItemText,
        size: iconSize * zoomScale,
      ),
    );
  }

  // Build list of menu items
  List<PopupMenuEntry<String>> _buildMenuItems(
    List<OverflowMenuItem> items,
    AppColorScheme appColorScheme,
    double zoomScale,
  ) {
    return items.map<PopupMenuEntry<String>>((item) {
      // If divider
      if (item is OverflowMenuDivider) {
        return const PopupMenuDivider();
      }

      // Submenu (treated as normal item in implementation)
      if (item is OverflowSubmenuItem) {
        return PopupMenuItem<String>(
          value: item.value,
          enabled: item.enabled,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  color:
                      item.enabled
                          ? appColorScheme.uiAreas.sideBar.inactiveItemText
                          : appColorScheme.uiAreas.sideBar.inactiveItemText,
                  size: 18.0,
                ),
                SizedBox(width: 8.0 * zoomScale),
              ],
              Expanded(child: Text(item.title)),
              Icon(
                AppIcons.arrowRight,
                color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                size: 18.0,
              ),
            ],
          ),
        );
      }

      // Normal menu item
      return PopupMenuItem<String>(
        value: item.value,
        enabled: item.enabled,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                color:
                    item.enabled
                        ? appColorScheme.uiAreas.sideBar.inactiveItemText
                        : appColorScheme.uiAreas.sideBar.inactiveItemText,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
            ],
            Expanded(child: Text(item.title)),
          ],
        ),
      );
    }).toList();
  }
}

/// Overflow menu item
class OverflowMenuItem {
  /// Item title
  final String title;

  /// Value returned when item is selected
  final String value;

  /// Icon to display in item (optional)
  final IconData? icon;

  /// Whether item is selectable
  final bool enabled;

  /// Callback when item is selected
  final void Function(String)? onSelected;

  /// Create [OverflowMenuItem]
  ///
  /// [title] - Item title
  /// [value] - Value returned when item is selected
  /// [icon] - Icon to display in item (optional)
  /// [enabled] - Whether item is selectable
  /// [onSelected] - Callback when item is selected
  const OverflowMenuItem({
    required this.title,
    required this.value,
    this.icon,
    this.enabled = true,
    this.onSelected,
  });
}

/// Overflow menu separator
class OverflowMenuDivider extends OverflowMenuItem {
  /// Create [OverflowMenuDivider]
  const OverflowMenuDivider() : super(title: '', value: '');
}

/// Overflow menu item with submenu
class OverflowSubmenuItem extends OverflowMenuItem {
  /// List of submenu items
  final List<OverflowMenuItem> children;

  /// Create [OverflowSubmenuItem]
  ///
  /// [title] - Item title
  /// [value] - Value returned when item is selected
  /// [icon] - Icon to display in item (optional)
  /// [enabled] - Whether item is selectable
  /// [onSelected] - Callback when item is selected
  /// [children] - List of submenu items
  const OverflowSubmenuItem({
    required super.title,
    required super.value,
    super.icon,
    super.enabled = true,
    super.onSelected,
    required this.children,
  });
}
