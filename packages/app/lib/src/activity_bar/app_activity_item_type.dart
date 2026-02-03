import 'package:flutter/material.dart';
import 'package:presentation_components/presentation_components.dart';

/// Activity bar item types
enum AppActivityItemType {
  // Main features
  lens(
    icon: AppIcons.graphNavigation,
    label: 'Graph Navigation',
    isMainItem: true,
  ),
  labelList(icon: AppIcons.tag, label: 'Label List', isMainItem: true),
  propertyList(
    icon: AppIcons.properties,
    label: 'Property List',
    isMainItem: true,
  ),

  // Meta features
  stackSwitcher(
    icon: AppIcons.stacks,
    label: 'Stack Switcher',
    isMainItem: false,
  ),
  settings(icon: AppIcons.settings, label: 'Settings', isMainItem: false);

  const AppActivityItemType({
    required this.icon,
    required this.label,
    required this.isMainItem,
  });

  final IconData icon;
  final String label;
  final bool isMainItem;
}

// Extension methods for AppActivityItemType
extension AppActivityItemTypeX on AppActivityItemType {
  ActivityBarItem toActivityBarItem({
    required int logicalIndex,
    String? badge,
    VoidCallback? onTap,
  }) {
    return ActivityBarItem(
      icon: icon,
      label: label,
      logicalIndex: logicalIndex,
      badge: badge,
      onTap: onTap,
    );
  }
}
