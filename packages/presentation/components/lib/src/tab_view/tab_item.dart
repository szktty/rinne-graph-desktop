import 'package:flutter/material.dart';

/// Definition class for a tab item.
/// Used in icon-based tab navigation.
class TabItem {
  /// The unique identifier for the tab.
  final String id;

  /// The icon to display on the tab.
  final IconData icon;

  /// The tooltip for the tab.
  final String? tooltip;

  /// The icon color when active.
  final Color? activeIconColor;

  /// The icon color when inactive.
  final Color? inactiveIconColor;

  /// The content widget of the tab.
  final Widget content;

  const TabItem._({
    required this.id,
    required this.icon,
    required this.content,
    this.tooltip,
    this.activeIconColor,
    this.inactiveIconColor,
  });

  /// Creates an icon-only tab item.
  static TabItem iconOnly({
    required String id,
    required IconData icon,
    required Widget content,
    String? tooltip,
    Color? activeIconColor,
    Color? inactiveIconColor,
  }) {
    return TabItem._(
      id: id,
      icon: icon,
      content: content,
      tooltip: tooltip,
      activeIconColor: activeIconColor,
      inactiveIconColor: inactiveIconColor,
    );
  }
}
