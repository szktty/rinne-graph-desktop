/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

import '../providers/label_list_providers.dart';

/// Primary sidebar for label list (filter navigation).
class LabelListSidebar extends ConsumerWidget {
  const LabelListSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedQuickAccessFilterProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppText('Label List', variant: AppTextVariant.itemTitle),
        ),

        // Filter navigation
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              // Filter items (exclude starred filter)
              ...QuickAccessFilter.values
                  .where((filter) => filter != QuickAccessFilter.starred)
                  .map((filter) {
                    final isSelected = selectedFilter == filter;
                    return _buildFilterItem(
                      context,
                      ref,
                      filter,
                      isSelected,
                      appColorScheme,
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    WidgetRef ref,
    QuickAccessFilter filter,
    bool isSelected,
    AppColorScheme colorScheme,
  ) {
    // Select icon based on filter
    IconData icon;
    switch (filter) {
      case QuickAccessFilter.all:
        icon = AppIcons.list;
        break;
      case QuickAccessFilter.starred:
        icon = AppIcons.star;
        break;
      case QuickAccessFilter.recentlyModified:
        icon = AppIcons.timeline;
        break;
      case QuickAccessFilter.recentlyAdded:
        icon = AppIcons.plus;
        break;
      case QuickAccessFilter.unused:
        icon = AppIcons.archiveOutlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
      decoration: BoxDecoration(
        color:
            isSelected
                ? colorScheme.uiAreas.sideBar.activeItemBackground
                : null,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: ListTile(
        dense: true,
        leading: AppIcon(
          icon,
          size: AppIconSize.small,
          customColor:
              isSelected
                  ? colorScheme.theme.primaryColor
                  : colorScheme.uiAreas.sideBar.inactiveItemText,
        ),
        title: AppText(
          filter.displayName,
          variant: AppTextVariant.bodyText,
          color:
              isSelected
                  ? colorScheme.theme.primaryColor
                  : colorScheme.uiAreas.sideBar.inactiveItemText,
        ),
        onTap: () {
          ref.read(selectedQuickAccessFilterProvider.notifier).state = filter;
          // Clear selection
          ref.read(selectedLabelForEditProvider.notifier).state = null;
        },
      ),
    );
  }
}
