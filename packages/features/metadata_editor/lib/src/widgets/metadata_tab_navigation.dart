/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:core_themes/core_themes.dart';

import '../providers/metadata_providers.dart';

/// Tab navigation for metadata management.
class MetadataTabNavigation extends ConsumerWidget {
  /// Constructor.
  const MetadataTabNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabId = ref.watch(metadataTabStateProvider);
    final availableTabs = ref.watch(availableMetadataTabsProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.sideBar.background,
        border: Border(
          right: BorderSide(
            color: appColorScheme.uiAreas.sideBar.divider,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: appColorScheme.uiAreas.sideBar.divider,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.database,
                  size: 20,
                  color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Metadata Management',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                  ),
                ),
              ],
            ),
          ),

          // Tab list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                for (final tab in availableTabs)
                  _buildTabItem(
                    context,
                    tab: tab,
                    isSelected: selectedTabId == tab.id,
                    onTap:
                        () => ref
                            .read(metadataTabStateProvider.notifier)
                            .selectTab(tab.id),
                    appColorScheme: appColorScheme,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build tab item
  Widget _buildTabItem(
    BuildContext context, {
    required MetadataTab tab,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorScheme appColorScheme,
  }) {
    final backgroundColor =
        isSelected
            ? appColorScheme.uiAreas.sideBar.activeItemBackground
            : Colors.transparent;

    final textColor =
        isSelected
            ? appColorScheme.uiAreas.sideBar.activeItemText
            : appColorScheme.uiAreas.sideBar.inactiveItemText;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Icon(_getTabIcon(tab), size: 18, color: textColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tab.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Gets the icon corresponding to the tab.
  IconData _getTabIcon(MetadataTab tab) {
    switch (tab) {
      case MetadataTab.labels:
        return LucideIcons.tag;
      // For future expansion
      // case MetadataTab.propertyTypes:
      //   return LucideIcons.settings;
      // case MetadataTab.entityTemplates:
      //   return LucideIcons.fileTemplate;
    }
  }
}
