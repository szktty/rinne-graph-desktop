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
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import '../providers/app_state_providers.dart';
import '../providers/search_providers.dart';
import '../models/search_models.dart';
import 'navigation_tab_content.dart';

class GraphNavigatorSidebarContent extends ConsumerWidget {
  const GraphNavigatorSidebarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(graphNavigatorTabProvider);

    // Tab definition (filter menu removed, only navigator and search)
    final tabs = [
      const AppTab(
        id: 'navigation',
        icon: AppIcons.bookmarks,
        tooltip: 'Navigator',
        closeable: false,
      ),
      const AppTab(
        id: 'search',
        icon: AppIcons.search,
        tooltip: 'Search',
        closeable: false,
      ),
    ];

    // Tab content definition
    final contents = [
      const AppTabContent(id: 'navigation', content: NavigationTabContent()),
      const AppTabContent(id: 'search', content: _SearchTabContent()),
    ];

    return AppTabView(
      tabs: tabs,
      contents: contents,
      initialSelectedTabId: selectedTab == 0 ? 'navigation' : 'search',
      onTabSelected: (tabId) {
        final tabIndex = tabId == 'navigation' ? 0 : 1;
        ref.read(graphNavigatorTabProvider.notifier).setTab(tabIndex);
      },
      tabBarHeight: 48.0,
      showDivider: true,
      contentPadding: EdgeInsets.zero,
      alignment: TabAlignment.center,
    );
  }
}

/// 検索タブのコンテンツウィジェット
class _SearchTabContent extends ConsumerStatefulWidget {
  const _SearchTabContent();

  @override
  ConsumerState<_SearchTabContent> createState() => _SearchTabContentState();
}

class _SearchTabContentState extends ConsumerState<_SearchTabContent> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, ExpansibleController> _controllers = {};
  final Map<String, ExpansibleController> _linkControllers = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(effectiveThemeDataProvider);
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    final explorationOptions = ref.watch(explorationOptionsStateProvider);
    final searchPatternState = ref.watch(searchPatternStateProvider);
    final searchResult = ref.watch(searchResultStateProvider);
    final isExecuting = ref.watch(searchExecutingProvider);
    final searchError = ref.watch(searchErrorProvider);

    final nodePatterns = searchPatternState.nodePatterns;
    final linkConfigurations = searchPatternState.linkConfigurations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Keyword Search Field ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: AppText(
                  'Keyword Search',
                  variant: AppTextVariant.captionText,
                  color: appColorScheme.uiAreas.sideBar.groupHeader,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    AppIcons.search,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  hintText: 'Enter keyword',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: colorScheme.outline,
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                onFieldSubmitted: (keyword) {
                  if (keyword.trim().isNotEmpty) {
                    // TODO: Implement keyword search
                  }
                },
              ),
            ],
          ),
        ),

        const Divider(),
        // --- Exploration Options ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppExpansionTile(
            title: AppText(
              'Exploration Options',
              variant: AppTextVariant.captionText,
              color: appColorScheme.uiAreas.sideBar.groupHeader,
            ),
            initiallyExpanded: false,
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            tilePadding: EdgeInsets.zero,
            iconPosition: ExpansionIconPosition.trailing,
            children: [
              _buildExplorationOptionRow(
                context: context,
                label: 'Depth:',
                child: AppDropdownMenu<int>(
                  initialSelection: explorationOptions.depth,
                  onSelected: (value) {
                    if (value == null) return;
                    final currentOptions = ref.read(
                      explorationOptionsStateProvider,
                    );
                    ref
                        .read(explorationOptionsStateProvider.notifier)
                        .setOptions(currentOptions.copyWith(depth: value));
                  },
                  dropdownMenuEntries:
                      [1, 2, 3, 4, 5, 10]
                          .map(
                            (d) => DropdownMenuEntry<int>(
                              value: d,
                              label: d.toString(),
                              style: MenuItemButton.styleFrom(
                                textStyle: themeData.textTheme.bodyMedium
                                    ?.copyWith(color: colorScheme.onSurface),
                              ),
                            ),
                          )
                          .toList(),
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 8),
              _buildExplorationOptionRow(
                context: context,
                label: 'Max Results:',
                child: AppText(
                  explorationOptions.maxResults.toString(),
                  variant: AppTextVariant.bodyText,
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // --- Advanced Search Section ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppText(
            'Advanced Search',
            variant: AppTextVariant.captionText,
            color: appColorScheme.uiAreas.sideBar.groupHeader,
          ),
        ),

        const SizedBox(height: 8),

        // --- Pattern Editing Area ---
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Draw node patterns and link settings alternately
                          for (int i = 0; i < nodePatterns.length; i++)
                            _buildPatternEntityTile(
                              context,
                              nodePatterns[i],
                              i,
                              nodePatterns,
                              linkConfigurations,
                            ),

                          // Add pattern button
                          _buildAddPatternButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // --- Search Execution Button ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isExecuting
                      ? null
                      : () {
                        ref
                            .read(searchActionsProvider.notifier)
                            .executeSearch();
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child:
                  isExecuting
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Design Principle #6: Animation Prohibition - use a static indicator
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.onPrimary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const AppText(
                            'Searching...',
                            variant: AppTextVariant.bodyText,
                          ),
                        ],
                      )
                      : const AppText(
                        'Execute Search',
                        variant: AppTextVariant.bodyText,
                      ),
            ),
          ),
        ),

        // --- Search Error Display ---
        if (searchError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: AppText(
                searchError,
                variant: AppTextVariant.captionText,
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),

        // --- Search Result Display ---
        if (searchResult != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Search Results',
                    variant: AppTextVariant.bodyText,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    'Nodes: ${searchResult.nodes.length}, Links: ${searchResult.links.length}',
                    variant: AppTextVariant.captionText,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  AppText(
                    'Execution Time: ${searchResult.executionTime.inMilliseconds}ms',
                    variant: AppTextVariant.captionText,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExplorationOptionRow({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: AppText(
            label,
            variant: AppTextVariant.captionText,
            color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildPatternEntityTile(
    BuildContext context,
    PatternEntity entity,
    int index,
    List<PatternEntity> nodePatterns,
    Map<String, LinkConfiguration> linkConfigurations,
  ) {
    final themeData = ref.watch(effectiveThemeDataProvider);
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    final bool isNode = entity.type == PatternEntityType.node;
    final iconData = isNode ? AppIcons.circle : AppIcons.link;
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final iconColor =
        isNode ? appColorScheme.appSpecific.graph.nodeBase : Colors.grey;

    final nodeController = _controllers.putIfAbsent(
      entity.id,
      () => ExpansibleController(),
    );

    final bool hasNextNode = index < nodePatterns.length - 1;
    final linkConfig = hasNextNode ? linkConfigurations[entity.id] : null;
    final linkController =
        hasNextNode
            ? _linkControllers.putIfAbsent(
              entity.id,
              () => ExpansibleController(),
            )
            : null;

    return Column(
      key: ValueKey(entity.id),
      children: [
        // Node pattern tile
        AppExpansionTile(
          key: ValueKey('${entity.id}_expansion'),
          controller: nodeController,
          title: Row(
            children: [
              Icon(iconData, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: entity.label,
                  onChanged: (value) {
                    final updatedEntity = entity.copyWith(label: value);
                    ref
                        .read(searchPatternStateProvider.notifier)
                        .updateNodePattern(entity.id, updatedEntity);
                  },
                  decoration: InputDecoration(
                    hintText: isNode ? 'Label' : 'Type',
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                  ),
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(AppIcons.x, size: 16, color: Colors.red.shade300),
                onPressed: () {
                  ref
                      .read(searchPatternStateProvider.notifier)
                      .removeNodePattern(entity.id);
                  _controllers.remove(entity.id);
                  _linkControllers.remove(entity.id);
                },
                tooltip: 'Delete pattern',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          backgroundColor:
              isNode
                  ? appColorScheme.appSpecific.graph.nodeBase.withValues(
                    alpha: 0.05,
                  )
                  : Colors.grey.withValues(alpha: 0.05),
          collapsedBackgroundColor:
              isNode
                  ? appColorScheme.appSpecific.graph.nodeBase.withValues(
                    alpha: 0.05,
                  )
                  : Colors.grey.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: iconColor),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: iconColor),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: entity.keyword,
                  onChanged: (value) {
                    final updatedEntity = entity.copyWith(keyword: value);
                    ref
                        .read(searchPatternStateProvider.notifier)
                        .updateNodePattern(entity.id, updatedEntity);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      AppIcons.search,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    hintText: 'Keyword',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    /* TODO: Expand property area */
                  },
                  child: Row(
                    children: [
                      Icon(AppIcons.plus, size: 16, color: iconColor),
                      const SizedBox(width: 4),
                      AppText(
                        'Add Property Condition',
                        variant: AppTextVariant.captionText,
                        color: iconColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Link configuration tile (if there is a next node)
        if (hasNextNode && linkController != null)
          _buildLinkConfigurationTile(
            context,
            entity.id,
            linkConfig ?? const LinkConfiguration(),
            linkController,
          ),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLinkConfigurationTile(
    BuildContext context,
    String previousNodeId,
    LinkConfiguration config,
    ExpansibleController controller,
  ) {
    final themeData = ref.watch(effectiveThemeDataProvider);
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    final iconColor = Colors.grey.shade600;

    IconData getDirectionIcon(LinkDirection direction) {
      switch (direction) {
        case LinkDirection.outgoing:
          return AppIcons.arrowRight;
        case LinkDirection.incoming:
          return AppIcons.arrowLeft;
        case LinkDirection.both:
          return AppIcons.arrowLeftRight;
      }
    }

    final directionDropdown = AppDropdownMenu<LinkDirection>(
      initialSelection: config.direction,
      onSelected: (newDirection) {
        if (newDirection != null) {
          final updatedConfig = config.copyWith(direction: newDirection);
          ref
              .read(searchPatternStateProvider.notifier)
              .addLinkConfiguration(previousNodeId, updatedConfig);
        }
      },
      cornerRadius: 20.0,
      dropdownMenuEntries:
          LinkDirection.values
              .map(
                (direction) => DropdownMenuEntry<LinkDirection>(
                  value: direction,
                  labelWidget: Icon(
                    getDirectionIcon(direction),
                    size: 18,
                    color: colorScheme.onSurface,
                  ),
                  label: '',
                  style: MenuItemButton.styleFrom(
                    textStyle: themeData.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              )
              .toList(),
    );

    return AppExpansionTile(
      key: ValueKey('${previousNodeId}_link_expansion'),
      controller: controller,
      title: directionDropdown,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      collapsedBackgroundColor: Colors.grey.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: iconColor),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: iconColor),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
      children: [
        TextFormField(
          initialValue: config.type,
          onChanged: (value) {
            final updatedConfig = config.copyWith(type: value);
            ref
                .read(searchPatternStateProvider.notifier)
                .addLinkConfiguration(previousNodeId, updatedConfig);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(AppIcons.stickyNote, size: 18, color: iconColor),
            hintText: 'Type',
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: config.keyword,
          onChanged: (value) {
            final updatedConfig = config.copyWith(keyword: value);
            ref
                .read(searchPatternStateProvider.notifier)
                .addLinkConfiguration(previousNodeId, updatedConfig);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              AppIcons.search,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            hintText: 'Keyword',
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            /* TODO: Add link properties */
          },
          child: Row(
            children: [
              Icon(AppIcons.plus, size: 16, color: iconColor),
              const SizedBox(width: 4),
              AppText(
                'Add Property Condition',
                variant: AppTextVariant.captionText,
                color: iconColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPatternButton(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    return InkWell(
      onTap: () {
        final newNode = PatternEntity(
          id: UniqueId().toString(),
          type: PatternEntityType.node,
          label: 'New Node',
          keyword: '',
        );

        ref.read(searchPatternStateProvider.notifier).addNodePattern(newNode);

        // Create a new controller
        _controllers.putIfAbsent(newNode.id, () => ExpansibleController());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: appColorScheme.appSpecific.graph.nodeBase.withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: appColorScheme.appSpecific.graph.nodeBase.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.plus,
              size: 18,
              color: appColorScheme.appSpecific.graph.nodeBase,
            ),
            const SizedBox(width: 8),
            AppText(
              'Add Pattern',
              variant: AppTextVariant.bodyText,
              color: appColorScheme.appSpecific.graph.nodeBase,
            ),
          ],
        ),
      ),
    );
  }
}
