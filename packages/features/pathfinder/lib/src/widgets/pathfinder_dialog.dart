/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

import '../providers/pathfinder_providers.dart';
import 'pathfinder_item_widget.dart';

/// Pathfinder dialog
class PathfinderDialog extends ConsumerStatefulWidget {
  /// Constructor
  const PathfinderDialog({super.key});

  @override
  ConsumerState<PathfinderDialog> createState() => _PathfinderDialogState();
}

class _PathfinderDialogState extends ConsumerState<PathfinderDialog> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

    // Set focus when dialog is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final theme = Theme.of(context);
    final searchQuery = ref.watch(pathfinderSearchQueryProvider);

    _controller.text = searchQuery;

    return Dialog(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: appColorScheme.interactive.quickInput.dropdownBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: appColorScheme.interactive.quickInput.dropdownBorder,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchField(context, appColorScheme),
            Flexible(child: _buildItemList(context)),
          ],
        ),
      ),
    );
  }

  /// Builds the search field
  Widget _buildSearchField(
    BuildContext context,
    AppColorScheme appColorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              ref.read(pathfinderActionsProvider.notifier).selectNextItem();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              ref.read(pathfinderActionsProvider.notifier).selectPreviousItem();
            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
              ref
                  .read(pathfinderActionsProvider.notifier)
                  .executeSelectedItem();
              Navigator.of(context).pop();
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.of(context).pop();
            }
          }
        },
        child: AppTextField(
          controller: _controller,
          hintText: 'Search path...',
          prefixIcon: Icon(
            LucideIcons.search,
            size: 18,
            color: appColorScheme.interactive.quickInput.iconColor,
          ),
          backgroundColor:
              appColorScheme.interactive.quickInput.fieldBackground,
          borderColor: appColorScheme.interactive.quickInput.fieldBorder,
          activeBorderColor:
              appColorScheme.interactive.quickInput.fieldActiveBorder,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          style: const TextStyle(fontSize: 14),
          onChanged: (value) {
            ref
                .read(pathfinderSearchQueryProvider.notifier)
                .setSearchQuery(value);

            final activeGraph = ref.read(pathfinderActiveGraphProvider);
            // Execute search if search query is not empty and graph data exists
            if (value.isNotEmpty && activeGraph != null) {
              // Execute search from graph data
              final searchResults = ref.read(searchEntitiesProvider(value));

              // Output search results to log (for debugging)
              debugPrint('Search results: ${searchResults.length} items');

              // Add processing to display search results
              // In a real application, add processing to display search results
            }
          },
          onSubmitted: (_) {
            ref.read(pathfinderActionsProvider.notifier).executeSelectedItem();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  /// Builds the item list
  Widget _buildItemList(BuildContext context) {
    final filteredItems = ref.watch(filteredItemsProvider);
    final selectedIndex = ref.watch(pathfinderSelectedIndexProvider);
    final searchQuery = ref.watch(pathfinderSearchQueryProvider);
    final items = filteredItems;

    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    // If search query is empty, display the list of recently used entities
    if (searchQuery.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Recently Used Entities',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;

                return PathfinderItemWidget(
                  item: item,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(pathfinderSelectedIndexProvider.notifier)
                        .setSelectedIndex(index);
                    ref
                        .read(pathfinderActionsProvider.notifier)
                        .executeSelectedItem();
                    // Process the selected entity
                    ref
                        .read(selectedEntityActionsProvider.notifier)
                        .processSelectedEntity(item);
                    Navigator.of(context).pop();
                  },
                  onHover: () {
                    ref
                        .read(pathfinderSelectedIndexProvider.notifier)
                        .setSelectedIndex(index);
                  },
                );
              },
            ),
          ),
        ],
      );
    }

    // If there is a search query, display search results
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = index == selectedIndex;

        return PathfinderItemWidget(
          item: item,
          isSelected: isSelected,
          onTap: () {
            ref
                .read(pathfinderSelectedIndexProvider.notifier)
                .setSelectedIndex(index);
            ref.read(pathfinderActionsProvider.notifier).executeSelectedItem();
            // Process the selected entity
            ref
                .read(selectedEntityActionsProvider.notifier)
                .processSelectedEntity(item);
            Navigator.of(context).pop();
          },
          onHover: () {
            ref
                .read(pathfinderSelectedIndexProvider.notifier)
                .setSelectedIndex(index);
          },
        );
      },
    );
  }

  /// Display when search results are empty
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.search,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No matching items', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
