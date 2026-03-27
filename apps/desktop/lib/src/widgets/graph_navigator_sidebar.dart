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
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import '../models/search_models.dart';
import '../providers/app_state_providers.dart';
import '../providers/search_providers.dart';
import '../providers/selection_providers.dart';
import '../events/selection_events.dart';
import '../services/search_execution_service.dart';
import 'navigation_tab_content.dart';

class GraphNavigatorSidebarContent extends ConsumerWidget {
  const GraphNavigatorSidebarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(graphNavigatorTabProvider);

    // Tab definition (filter menu removed, only navigator and search)
    final tabs = [
      FondeTab(
        id: 'navigation',
        icon: FondeIcons.bookmarks,
        tooltip: 'Navigator',
        closeable: false,
      ),
      FondeTab(
        id: 'search',
        icon: FondeIcons.search,
        tooltip: 'Search',
        closeable: false,
      ),
    ];

    // Tab content definition
    final contents = [
      FondeTabContent(id: 'navigation', content: NavigationTabContent()),
      FondeTabContent(id: 'search', content: _SearchTabContent()),
    ];

    return FondeTabView(
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

// ---------------------------------------------------------------------------
// Keyword Search UI
// ---------------------------------------------------------------------------

class _SearchTabContent extends ConsumerStatefulWidget {
  const _SearchTabContent();

  @override
  ConsumerState<_SearchTabContent> createState() => _SearchTabContentState();
}

class _SearchTabContentState extends ConsumerState<_SearchTabContent> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(keywordSearchResultProvider);
    final isExecuting = ref.watch(keywordSearchExecutingProvider);
    final searchError = ref.watch(searchErrorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KeywordSearchField(controller: _queryController),
        _SearchFilterChips(),
        // Error display
        if (searchError != null) _SearchErrorBanner(error: searchError),
        // Body: empty hint / executing / results
        Expanded(
          child: isExecuting
              ? _SearchExecutingIndicator()
              : result == null
                  ? _SearchEmptyHint()
                  : _SearchResultList(result: result),
        ),
        // Footer: only shown when result is available
        if (result != null) _SearchResultFooter(result: result),
      ],
    );
  }
}

// --- Keyword search field ---

class _KeywordSearchField extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const _KeywordSearchField({required this.controller});

  @override
  ConsumerState<_KeywordSearchField> createState() =>
      _KeywordSearchFieldState();
}

class _KeywordSearchFieldState extends ConsumerState<_KeywordSearchField> {
  Future<void> _executeSearch() async {
    final query = widget.controller.text;
    final service = ref.read(searchExecutionServiceProvider);
    final filters = ref.read(keywordSearchFiltersStateProvider);
    final resultNotifier = ref.read(keywordSearchResultProvider.notifier);
    final executingNotifier = ref.read(keywordSearchExecutingProvider.notifier);
    final errorNotifier = ref.read(searchErrorProvider.notifier);

    if (service == null) {
      errorNotifier.setError('No stack is open.');
      return;
    }
    if (query.trim().isEmpty) return;

    executingNotifier.start();
    try {
      final result = await service.executeKeywordSearch(
        keyword: query,
        options: ExplorationOptions(maxResults: 200),
      );

      if (!mounted) return;

      final filteredNodes = filters.nodeLabels.isEmpty
          ? result.nodes
          : result.nodes
              .where((n) => n.labels.any((l) => filters.nodeLabels.contains(l)))
              .toList();
      final filteredLinks = filters.linkTypes.isEmpty
          ? result.links
          : result.links
              .where((l) => filters.linkTypes.contains(l.type))
              .toList();

      final newResult = SearchResult(
        nodes: filteredNodes,
        links: filteredLinks,
        totalNodeCount: filteredNodes.length,
        totalLinkCount: filteredLinks.length,
        executionTime: result.executionTime,
      );
      resultNotifier.setResult(newResult);

      // Update highlight IDs from result
      ref.read(searchHighlightProvider.notifier).setIds(
        nodeIds: filteredNodes.map((n) => n.id).toSet(),
        linkIds: filteredLinks.map((l) => l.id).toSet(),
      );
    } catch (e) {
      if (mounted) errorNotifier.setError(e.toString());
    } finally {
      executingNotifier.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(effectiveThemeDataProvider);
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    final isExecuting = ref.watch(keywordSearchExecutingProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  FondeIcons.search,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                hintText: 'Enter keyword to search',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: colorScheme.outline, width: 1.0),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              onChanged: (value) {
                ref.read(keywordSearchQueryProvider.notifier).setQuery(value);
              },
              onFieldSubmitted: (_) => _executeSearch(),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: Icon(FondeIcons.search, size: 18),
            onPressed: isExecuting ? null : _executeSearch,
            tooltip: 'Search',
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Filter chips ---

class _SearchFilterChips extends ConsumerWidget {
  const _SearchFilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodeLabelsAsync = ref.watch(availableNodeLabelsProvider);
    final linkTypesAsync = ref.watch(availableLinkTypesProvider);
    final filters = ref.watch(keywordSearchFiltersStateProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    final nodeLabels = nodeLabelsAsync.asData?.value ?? [];
    final linkTypes = linkTypesAsync.asData?.value ?? [];

    if (nodeLabels.isEmpty && linkTypes.isEmpty) return const SizedBox.shrink();

    final nodeColor = appColorScheme.appSpecific.graph.nodeBase;
    final linkColor = Colors.grey.shade600;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: [
          // [All] chip
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: FilterChip(
              label: const Text('All'),
              selected: filters.nodeLabels.isEmpty && filters.linkTypes.isEmpty,
              onSelected: (_) {
                ref
                    .read(keywordSearchFiltersStateProvider.notifier)
                    .clear();
              },
            ),
          ),
          // Node label chips
          for (final label in nodeLabels)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
                label: Text(label),
                selected: filters.nodeLabels.contains(label),
                selectedColor: nodeColor.withValues(alpha: 0.2),
                checkmarkColor: nodeColor,
                side: BorderSide(color: nodeColor),
                onSelected: (_) {
                  ref
                      .read(keywordSearchFiltersStateProvider.notifier)
                      .toggleNodeLabel(label);
                },
              ),
            ),
          // Link type chips
          for (final type in linkTypes)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
                label: Text('→ $type'),
                selected: filters.linkTypes.contains(type),
                selectedColor: linkColor.withValues(alpha: 0.2),
                checkmarkColor: linkColor,
                side: BorderSide(color: linkColor),
                onSelected: (_) {
                  ref
                      .read(keywordSearchFiltersStateProvider.notifier)
                      .toggleLinkType(type);
                },
              ),
            ),
        ],
      ),
    );
  }
}

// --- Empty hint ---

class _SearchEmptyHint extends StatelessWidget {
  const _SearchEmptyHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AppText(
        'Enter a keyword to search',
        variant: AppTextVariant.captionText,
      ),
    );
  }
}

// --- Executing indicator ---

class _SearchExecutingIndicator extends StatelessWidget {
  const _SearchExecutingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Design Principle: no animation — static indicator
          Icon(FondeIcons.search, size: 16),
          const SizedBox(width: 8),
          const AppText('Searching...', variant: AppTextVariant.captionText),
        ],
      ),
    );
  }
}

// --- Error banner ---

class _SearchErrorBanner extends ConsumerWidget {
  final String error;

  const _SearchErrorBanner({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
        ),
        child: AppText(
          error,
          variant: AppTextVariant.captionText,
          color: colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

// --- Result list ---

class _SearchResultList extends ConsumerWidget {
  final SearchResult result;

  const _SearchResultList({required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    final nodeColor = appColorScheme.appSpecific.graph.nodeBase;

    return ListView(
      children: [
        if (result.nodes.isNotEmpty) ...[
          _SectionHeader(label: 'Nodes (${result.nodes.length})'),
          for (final node in result.nodes)
            _NodeResultRow(
              node: node,
              nodeColor: nodeColor,
              colorScheme: colorScheme,
              onTap: () {
                ref
                    .read(selectionStateProvider.notifier)
                    .selectEntity(
                      node.id,
                      source: SelectionSource.external,
                    );
              },
              onDoubleTap: () {
                ref
                    .read(selectionStateProvider.notifier)
                    .selectEntity(
                      node.id,
                      source: SelectionSource.external,
                    );
                ref
                    .read(searchFocusTargetProvider.notifier)
                    .focus(node.id);
              },
            ),
        ],
        if (result.links.isNotEmpty) ...[
          _SectionHeader(label: 'Links (${result.links.length})'),
          for (final link in result.links)
            _LinkResultRow(
              link: link,
              colorScheme: colorScheme,
              onTap: () {
                ref
                    .read(selectionStateProvider.notifier)
                    .selectEntity(
                      link.id,
                      source: SelectionSource.external,
                    );
              },
            ),
        ],
      ],
    );
  }
}

class _SectionHeader extends ConsumerWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: AppText(
        label,
        variant: AppTextVariant.captionText,
        color: appColorScheme.uiAreas.sideBar.groupHeader,
      ),
    );
  }
}

class _NodeResultRow extends StatelessWidget {
  final core_graph.Node node;
  final Color nodeColor;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const _NodeResultRow({
    required this.node,
    required this.nodeColor,
    required this.colorScheme,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final label =
        node.labels.isNotEmpty ? node.labels.first : node.id.value;
    final secondaryLabel =
        node.labels.length > 1 ? node.labels.skip(1).first : null;

    return FondeListTile(
      dense: true,
      isSelected: false,
      leading: Icon(FondeIcons.circle, size: 16, color: nodeColor),
      title: AppText(label, variant: AppTextVariant.bodyText),
      trailing: secondaryLabel != null
          ? _LabelChip(label: secondaryLabel, color: nodeColor)
          : null,
      onTap: onTap,
      onLongPress: onDoubleTap,
    );
  }
}

class _LinkResultRow extends StatelessWidget {
  final core_graph.Link link;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _LinkResultRow({
    required this.link,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FondeListTile(
      dense: true,
      isSelected: false,
      leading: Icon(
        FondeIcons.arrowRight,
        size: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      title: AppText(link.type, variant: AppTextVariant.bodyText),
      subtitle: AppText(
        '${link.sourceId.value} → ${link.targetId.value}',
        variant: AppTextVariant.captionText,
      ),
      onTap: onTap,
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final Color color;

  const _LabelChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}

// --- Result footer ---

class _SearchResultFooter extends ConsumerWidget {
  final SearchResult result;

  const _SearchResultFooter({required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
    final highlightState = ref.watch(searchHighlightProvider);
    final ms = result.executionTime.inMilliseconds;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              '${result.nodes.length} nodes, ${result.links.length} links  (${ms}ms)',
              variant: AppTextVariant.captionText,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          IconButton(
            icon: Icon(
              highlightState.dimEnabled
                  ? Icons.visibility
                  : Icons.visibility_outlined,
              size: 16,
            ),
            tooltip: highlightState.dimEnabled
                ? 'Dim off'
                : 'Dim non-matching nodes',
            onPressed: () {
              ref.read(searchHighlightProvider.notifier).toggleDim();
            },
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          TextButton(
            onPressed: () {
              ref.read(keywordSearchQueryProvider.notifier).clear();
              ref.read(keywordSearchResultProvider.notifier).clear();
              ref.read(keywordSearchFiltersStateProvider.notifier).clear();
              ref.read(searchErrorProvider.notifier).clearError();
              ref.read(searchHighlightProvider.notifier).clear();
            },
            child: const AppText('Clear', variant: AppTextVariant.captionText),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Path Search UI (deferred — kept for future restoration)
// ---------------------------------------------------------------------------

// ignore_for_file: unused_import
// The following imports are kept for Path Search restoration:
// import '../models/search_models.dart';
//
// class _PathSearchTabContent extends ConsumerStatefulWidget {
//   const _PathSearchTabContent();
//
//   @override
//   ConsumerState<_PathSearchTabContent> createState() =>
//       _PathSearchTabContentState();
// }
//
// class _PathSearchTabContentState
//     extends ConsumerState<_PathSearchTabContent> {
//   final ScrollController _scrollController = ScrollController();
//   final Map<String, ExpansibleController> _controllers = {};
//   final Map<String, ExpansibleController> _linkControllers = {};
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeData = ref.watch(effectiveThemeDataProvider);
//     final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);
//     final appColorScheme = ref.watch(effectiveColorSchemeProvider);
//
//     final explorationOptions = ref.watch(explorationOptionsStateProvider);
//     final searchPatternState = ref.watch(searchPatternStateProvider);
//     final searchResult = ref.watch(searchResultStateProvider);
//     final isExecuting = ref.watch(searchExecutingProvider);
//     final searchError = ref.watch(searchErrorProvider);
//
//     final nodePatterns = searchPatternState.nodePatterns;
//     final linkConfigurations = searchPatternState.linkConfigurations;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // --- Keyword Search Field ---
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4.0),
//                 child: AppText(
//                   'Keyword Search',
//                   variant: AppTextVariant.captionText,
//                   color: appColorScheme.uiAreas.sideBar.groupHeader,
//                 ),
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     FondeIcons.search,
//                     size: 18,
//                     color: colorScheme.primary,
//                   ),
//                   hintText: 'Enter keyword',
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 10,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: BorderSide(
//                       color: colorScheme.outline,
//                       width: 1.0,
//                     ),
//                   ),
//                   filled: true,
//                   fillColor: colorScheme.surface,
//                 ),
//                 style: themeData.textTheme.bodyMedium?.copyWith(
//                   color: colorScheme.onSurface,
//                 ),
//                 onFieldSubmitted: (keyword) {
//                   if (keyword.trim().isNotEmpty) {
//                     // TODO: Implement keyword search
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//
//         const Divider(),
//         // --- Exploration Options ---
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: FondeExpansionTile(
//             title: AppText(
//               'Exploration Options',
//               variant: AppTextVariant.captionText,
//               color: appColorScheme.uiAreas.sideBar.groupHeader,
//             ),
//             initiallyExpanded: false,
//             childrenPadding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 8.0,
//             ),
//             tilePadding: EdgeInsets.zero,
//             iconPosition: FondeExpansionIconPosition.trailing,
//             children: [
//               _buildExplorationOptionRow(
//                 context: context,
//                 label: 'Depth:',
//                 child: FondeDropdownMenu<int>(
//                   initialSelection: explorationOptions.depth,
//                   onSelected: (value) {
//                     if (value == null) return;
//                     final currentOptions = ref.read(
//                       explorationOptionsStateProvider,
//                     );
//                     ref
//                         .read(explorationOptionsStateProvider.notifier)
//                         .setOptions(currentOptions.copyWith(depth: value));
//                   },
//                   dropdownMenuEntries:
//                       [1, 2, 3, 4, 5, 10]
//                           .map(
//                             (d) => DropdownMenuEntry<int>(
//                               value: d,
//                               label: d.toString(),
//                               style: MenuItemButton.styleFrom(
//                                 textStyle: themeData.textTheme.bodyMedium
//                                     ?.copyWith(color: colorScheme.onSurface),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                   width: double.infinity,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               _buildExplorationOptionRow(
//                 context: context,
//                 label: 'Max Results:',
//                 child: AppText(
//                   explorationOptions.maxResults.toString(),
//                   variant: AppTextVariant.bodyText,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         const Divider(),
//
//         // --- Advanced Search FondeSection ---
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: AppText(
//             'Advanced Search',
//             variant: AppTextVariant.captionText,
//             color: appColorScheme.uiAreas.sideBar.groupHeader,
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         // --- Pattern Editing Area ---
//         Expanded(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SizedBox(
//                 width: constraints.maxWidth,
//                 child: Scrollbar(
//                   thumbVisibility: true,
//                   controller: _scrollController,
//                   child: SingleChildScrollView(
//                     controller: _scrollController,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         children: [
//                           for (int i = 0; i < nodePatterns.length; i++)
//                             _buildPatternEntityTile(
//                               context,
//                               nodePatterns[i],
//                               i,
//                               nodePatterns,
//                               linkConfigurations,
//                             ),
//                           _buildAddPatternButton(context),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//
//         // --- Search Execution Button ---
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed:
//                   isExecuting
//                       ? null
//                       : () {
//                         ref
//                             .read(searchActionsProvider.notifier)
//                             .executeSearch();
//                       },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: colorScheme.primary,
//                 foregroundColor: colorScheme.onPrimary,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//               child:
//                   isExecuting
//                       ? Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 16,
//                             height: 16,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: colorScheme.onPrimary,
//                                 width: 2,
//                               ),
//                             ),
//                             child: Center(
//                               child: Container(
//                                 width: 6,
//                                 height: 6,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: colorScheme.onPrimary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           const AppText(
//                             'Searching...',
//                             variant: AppTextVariant.bodyText,
//                           ),
//                         ],
//                       )
//                       : const AppText(
//                         'Execute Search',
//                         variant: AppTextVariant.bodyText,
//                       ),
//             ),
//           ),
//         ),
//
//         // --- Search Error Display ---
//         if (searchError != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: colorScheme.errorContainer,
//                 borderRadius: BorderRadius.circular(4),
//                 border: Border.all(
//                   color: colorScheme.error.withValues(alpha: 0.3),
//                 ),
//               ),
//               child: AppText(
//                 searchError,
//                 variant: AppTextVariant.captionText,
//                 color: colorScheme.onErrorContainer,
//               ),
//             ),
//           ),
//
//         // --- Search Result Display ---
//         if (searchResult != null)
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: colorScheme.surfaceContainerHighest,
//                 borderRadius: BorderRadius.circular(4),
//                 border: Border.all(
//                   color: colorScheme.outline.withValues(alpha: 0.3),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     'Search Results',
//                     variant: AppTextVariant.bodyText,
//                     color: colorScheme.onSurface,
//                   ),
//                   const SizedBox(height: 4),
//                   AppText(
//                     'Nodes: ${searchResult.nodes.length}, Links: ${searchResult.links.length}',
//                     variant: AppTextVariant.captionText,
//                     color: colorScheme.onSurfaceVariant,
//                   ),
//                   AppText(
//                     'Execution Time: ${searchResult.executionTime.inMilliseconds}ms',
//                     variant: AppTextVariant.captionText,
//                     color: colorScheme.onSurfaceVariant,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildExplorationOptionRow({...}) { ... }
//   Widget _buildPatternEntityTile(...) { ... }
//   Widget _buildLinkConfigurationTile(...) { ... }
//   Widget _buildAddPatternButton(...) { ... }
// }
