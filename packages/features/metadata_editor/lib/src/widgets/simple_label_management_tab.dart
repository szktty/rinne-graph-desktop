/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_flutter/core_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

import 'improved_label_editor.dart';
import '../providers/label_management_providers.dart';

/// Simple label management tab (for demo).
class SimpleLabelManagementTab extends ConsumerWidget {
  /// コンストラクタ
  const SimpleLabelManagementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('[SimpleLabelManagementTab] Building');

    // Providers for label management
    final filteredLabels = ref.watch(filteredLabelsProvider);
    final searchQuery = ref.watch(labelSearchQueryProvider);
    final selectedLabel = ref.watch(selectedLabelProvider);
    final searchNotifier = ref.read(labelSearchQueryProvider.notifier);
    final selectedLabelNotifier = ref.read(selectedLabelProvider.notifier);
    final labelActions = ref.read(labelActionsProvider.notifier);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Row(
      children: [
        // Left side: Label list
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: appColorScheme.base.background,
              border: Border(
                right: BorderSide(
                  color: appColorScheme.base.divider,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              children: [
                // ヘッダー
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: appColorScheme.base.divider,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 検索フィールドとアクションボタン
                      Row(
                        children: [
                          // 検索フィールド
                          Expanded(
                            child: FondeTextField(
                              controller: TextEditingController(
                                text: searchQuery,
                              ),
                              hintText: 'Search labels...',
                              prefixIcon: Icon(
                                FondeIcons.search,
                                size: 18,
                                color:
                                    appColorScheme
                                        .appSpecific
                                        .metadata
                                        .propertyValue,
                              ),
                              suffixIcon:
                                  searchQuery.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(
                                          FondeIcons.x,
                                          size: 16,
                                          color:
                                              appColorScheme
                                                  .appSpecific
                                                  .metadata
                                                  .propertyValue,
                                        ),
                                        onPressed:
                                            () => searchNotifier.clearQuery(),
                                        tooltip: 'Clear',
                                      )
                                      : null,
                              style: TextStyle(
                                color:
                                    appColorScheme
                                        .uiAreas
                                        .sideBar
                                        .activeItemText,
                                fontSize: 14,
                              ),
                              onChanged:
                                  (text) => searchNotifier.setSearchQuery(text),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Filter button
                          IconButton(
                            onPressed: () {
                              // TODO: Show filter menu
                            },
                            icon: Icon(
                              FondeIcons.listFilter,
                              size: 18,
                              color:
                                  appColorScheme
                                      .appSpecific
                                      .metadata
                                      .propertyValue,
                            ),
                            tooltip: 'Filter',
                          ),

                          // Sort button
                          IconButton(
                            onPressed: () {
                              // TODO: Show sort menu
                            },
                            icon: Icon(
                              FondeIcons.arrowUpDown,
                              size: 18,
                              color:
                                  appColorScheme
                                      .appSpecific
                                      .metadata
                                      .propertyValue,
                            ),
                            tooltip: 'Sort',
                          ),

                          // Create New button
                          IconButton(
                            onPressed: labelActions.createNewLabel,
                            icon: Icon(
                              FondeIcons.plus,
                              size: 18,
                              color:
                                  appColorScheme
                                      .appSpecific
                                      .metadata
                                      .propertyValue,
                            ),
                            tooltip: 'Create New',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Label list
                Expanded(
                  child: _buildLabelList(
                    context,
                    labels: filteredLabels,
                    selectedLabel: selectedLabel,
                    onLabelTap: selectedLabelNotifier.setSelectedLabel,
                    appColorScheme: appColorScheme,
                    labelActions: labelActions,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right side: Label details
        Expanded(
          flex: 1,
          child: Container(
            color: appColorScheme.base.background,
            child:
                selectedLabel != null
                    ? ImprovedLabelEditor(
                      label: selectedLabel,
                      isEditMode: false,
                    )
                    : _buildEmptyState(context),
          ),
        ),
      ],
    );
  }

  /// Builds the label list.
  Widget _buildLabelList(
    BuildContext context, {
    required List<LabelMetadata> labels,
    required LabelMetadata? selectedLabel,
    required ValueChanged<LabelMetadata> onLabelTap,
    required AppColorScheme appColorScheme,
    required dynamic labelActions,
  }) {
    if (labels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FondeIcons.tag, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No labels found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: labels.length,
      itemBuilder: (context, index) {
        final label = labels[index];
        final isSelected = selectedLabel?.name == label.name;

        return _buildLabelListItem(
          context,
          label: label,
          isSelected: isSelected,
          onTap: () => onLabelTap(label),
          appColorScheme: appColorScheme,
          labelActions: labelActions,
        );
      },
    );
  }

  /// Builds a label list item.
  Widget _buildLabelListItem(
    BuildContext context, {
    required LabelMetadata label,
    required bool isSelected,
    required VoidCallback onTap,
    required AppColorScheme appColorScheme,
    required dynamic labelActions,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: FondeListTile(
        isSelected: isSelected,
        onTap: onTap,
        title: Row(
          children: [
            // Label name (enclosed in FondeRectangleBorder)
            FondeRectangleBorder(
              color: label.color ?? Colors.grey,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              cornerRadius: 6.0,
              child: Text(
                label.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getContrastColor(label.color ?? Colors.grey),
                ),
              ),
            ),

            // Spacer
            const Spacer(),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            FondeIcons.ellipsis,
            size: 16,
            color: appColorScheme.appSpecific.metadata.propertyValue,
          ),
          tooltip: 'Actions',
          onSelected: (value) {
            switch (value) {
              case 'delete':
                _showDeleteConfirmation(context, label, labelActions);
                break;
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    'Delete',
                    style: TextStyle(color: appColorScheme.status.error),
                  ),
                ),
              ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),
    );
  }

  /// Gets a text color with good contrast against the background color.
  Color _getContrastColor(Color backgroundColor) {
    // Calculate luminance to determine white or black.
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Displays a delete confirmation dialog.
  void _showDeleteConfirmation(
    BuildContext context,
    LabelMetadata label,
    dynamic labelActions,
  ) {
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Label'),
            content: Text(
              'Delete label "${label.name}"?\nThis operation cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement delete label with proper provider
                  // labelActions.deleteLabel(label.name);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  /// Builds the empty state.
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FondeIcons.mousePointerClick, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Select a label to view details',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
