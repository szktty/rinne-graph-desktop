/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:presentation_components/presentation_components.dart';

/// Activity bar item types
enum AppActivityItemType {
  // Main features
  lens(label: 'Graph Navigation', isMainItem: true),
  labelList(label: 'Label List', isMainItem: true),
  propertyList(label: 'Property List', isMainItem: true),

  // Meta features
  stackSwitcher(label: 'Stack Switcher', isMainItem: false),
  settings(label: 'Settings', isMainItem: false);

  const AppActivityItemType({required this.label, required this.isMainItem});

  final String label;
  final bool isMainItem;

  IconData get icon {
    switch (this) {
      case AppActivityItemType.lens:
        return FondeIcons.graphNavigation;
      case AppActivityItemType.labelList:
        return FondeIcons.tag;
      case AppActivityItemType.propertyList:
        return FondeIcons.properties;
      case AppActivityItemType.stackSwitcher:
        return FondeIcons.stacks;
      case AppActivityItemType.settings:
        return FondeIcons.settings;
    }
  }
}

// Extension methods for AppActivityItemType
extension AppActivityItemTypeX on AppActivityItemType {
  FondeLaunchBarItem toLaunchBarItem({
    required int logicalIndex,
    String? badge,
    VoidCallback? onTap,
  }) {
    return FondeLaunchBarItem(
      icon: icon,
      label: label,
      logicalIndex: logicalIndex,
      badge: badge,
      onTap: onTap,
    );
  }
}
