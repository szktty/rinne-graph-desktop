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
import 'package:presentation_components/presentation_components.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import '../providers/app_state_providers.dart';

/// Unified graph sidebar
/// 'Browse' and 'Search' functionalities can be switched via tabs
class UnifiedGraphSidebarContent extends ConsumerWidget {
  const UnifiedGraphSidebarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(unifiedSidebarTabProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab selector
        Container(
          padding: const EdgeInsets.all(8.0),
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(
                value: 0,
                icon: Icon(AppIcons.listTree, size: 16),
                label: const Text('Browse'),
              ),
              ButtonSegment(
                value: 1,
                icon: Icon(AppIcons.search, size: 16),
                label: const Text('Search'),
              ),
            ],
            selected: {selectedTab},
            onSelectionChanged: (Set<int> selection) {
              ref
                  .read(unifiedSidebarTabProvider.notifier)
                  .setTab(selection.first);
            },
          ),
        ),

        const Divider(height: 1),

        // Content area
        Expanded(
          child: IndexedStack(
            index: selectedTab,
            children: const [_BrowseTabContent(), _SearchTabContent()],
          ),
        ),
      ],
    );
  }
}

/// Browse tab content
class _BrowseTabContent extends ConsumerWidget {
  const _BrowseTabContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStack = ref.watch(core_stack.activeStackProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final themeData = ref.watch(effectiveThemeDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick search field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextField(
            hintText: 'Quick Search...',
            prefixIcon: Icon(
              AppIcons.search,
              color: appColorScheme.uiAreas.sideBar.inactiveItemText,
            ),
            // backgroundColor: appColorScheme.uiAreas.sideBar.background.lighten(0.1),
            // borderColor: Colors.transparent,
            // radius: 8.0,
            // style: TextStyle(color: appColorScheme.uiAreas.sideBar.inactiveItemText),
          ),
        ),

        // Active stack display
        if (activeStack != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              activeStack.info.name,
              style: themeData.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

        const Divider(),

        // Main content area
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.listTree,
                  size: 48,
                  color: appColorScheme.uiAreas.sideBar.inactiveItemText
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Graph Navigator',
                  style: themeData.textTheme.titleMedium?.copyWith(
                    color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hierarchically displays nodes and links in the graph',
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.bodySmall?.copyWith(
                    color: appColorScheme.uiAreas.sideBar.inactiveItemText
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Search tab content
class _SearchTabContent extends ConsumerWidget {
  const _SearchTabContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.search,
            size: 48,
            color: appColorScheme.base.foreground.withAlpha(128),
          ),
          const SizedBox(height: 16),
          AppText(
            'Search Feature',
            variant: AppTextVariant.sectionTitlePrimary,
            color: appColorScheme.base.foreground.withAlpha(128),
          ),
          const SizedBox(height: 8),
          AppText(
            'Search feature will be implemented in the future',
            variant: AppTextVariant.bodyText,
            color: appColorScheme.base.foreground.withAlpha(128),
          ),
        ],
      ),
    );
  }
}
