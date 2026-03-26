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
import '../models/settings_item.dart';
import '../utils/search_utils.dart';
import 'settings_list_item.dart';

/// Main component for the settings panel.
class SettingsPanel extends ConsumerStatefulWidget {
  const SettingsPanel({
    required this.items,
    this.initialSelectedId,
    this.searchable = true,
    this.searchPlaceholder = 'Search settings...',
    this.emptySelectionBuilder,
    this.noResultsBuilder,
    super.key,
  });

  /// List of settings items.
  final List<SettingsItem> items;

  /// Initially selected ID.
  final String? initialSelectedId;

  /// Whether to enable search functionality.
  final bool searchable;

  /// Placeholder for the search field.
  final String searchPlaceholder;

  /// A builder function for the widget to display when nothing is selected.
  final Widget Function(BuildContext)? emptySelectionBuilder;

  /// A builder function for the widget to display when there are no search results.
  final Widget Function(BuildContext, String)? noResultsBuilder;

  @override
  ConsumerState<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends ConsumerState<SettingsPanel> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final filteredItems = searchSettings(
      items: widget.items,
      getSearchKeywords: (item) => item.keywords,
      query: query,
    );

    // Sync search controller with query only when needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchController.text != query) {
        _searchController.text = query;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: query.length),
        );
      }
    });

    return FondeMasterDetailLayout(
      items: filteredItems.map((item) => item.id).toList(),
      initialSelectedId: widget.initialSelectedId,
      masterPadding: const EdgeInsets.only(top: 20.0, right: 20.0),
      detailPadding:
          EdgeInsets.zero, // Detail view manages its own padding internally.
      masterItemBuilder: (context, itemId, isSelected, onSelect) {
        final item = widget.items.firstWhere((item) => item.id == itemId);
        return Padding(
          padding: EdgeInsetsGeometry.only(bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.searchable &&
                  itemId == filteredItems.firstOrNull?.id) ...[
                Container(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 16.0,
                    top: 0,
                    bottom: 8,
                  ),
                  child: FondeSearchField(
                    hint: widget.searchPlaceholder,
                    value: query,
                    onChange: (text) {
                      ref.read(searchQueryProvider.notifier).updateQuery(text);
                    },
                    onClear:
                        query.isNotEmpty
                            ? () {
                              _searchController.clear();
                              ref
                                  .read(searchQueryProvider.notifier)
                                  .clearQuery();
                            }
                            : null,
                  ),
                ),
              ],
              SettingsListItem(
                item: item,
                isSelected: isSelected,
                onTap: onSelect,
              ),
            ],
          ),
        );
      },
      detailBuilder: (context, selectedId, showMaster) {
        Widget detailContent;
        if (selectedId == null) {
          if (query.isNotEmpty && filteredItems.isEmpty) {
            if (widget.noResultsBuilder != null) {
              detailContent = widget.noResultsBuilder!(context, query);
            } else {
              detailContent = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FondeIcon(
                      FondeIcons.search,
                      size: FondeIconSize.xlarge,
                      color: FondeIconColor.onSurfaceVariant,
                    ),
                    FondeSpacing.lg(),
                    AppText(
                      'No settings found for "$query"',
                      variant: AppTextVariant.bodyText,
                    ),
                  ],
                ),
              );
            }
          } else if (widget.emptySelectionBuilder != null) {
            detailContent = widget.emptySelectionBuilder!(context);
          } else {
            detailContent = const Center(
              child: AppText(
                'Select a setting item to continue',
                variant: AppTextVariant.bodyText,
              ),
            );
          }
        } else {
          final item = widget.items.firstWhere((item) => item.id == selectedId);
          detailContent = item.builder();
        }
        return detailContent;
      },
    );
  }
}
