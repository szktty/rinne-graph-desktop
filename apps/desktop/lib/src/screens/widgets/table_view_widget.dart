import 'package:flutter/material.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart' as core_themes;

import '../../events/selection_events.dart';

/// Table view widget
class TableViewWidget extends ConsumerWidget {
  const TableViewWidget({
    required this.activeGraph,
    required this.graphActions,
    super.key,
  });

  final core_graph.Graph activeGraph;
  final dynamic graphActions; // GraphActions type dynamic

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get list of nodes from graph
    final nodes = activeGraph.nodes.values.toList();

    // Get theme (via core_themes)
    final themeData = ref.watch(core_themes.effectiveThemeDataProvider);
    final colorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );

    // Build table view column definition
    final columns = _buildTableColumns(nodes, themeData, colorScheme);

    return AppTableView<core_graph.Node>(
      columns: columns,
      data: nodes,
      keyExtractor: (node) => node.id.value,
      allowMultiSelect: false,
      onRowsSelected: (selectedItems) {
        // Update selection status
        if (selectedItems.isEmpty) {
          debugPrint('[TableView] Clearing selection');
          graphActions.clearSelection(source: SelectionSource.ui);
        } else {
          debugPrint('[TableView] Selecting entity: ${selectedItems.first.id}');
          graphActions.selectEntity(
            selectedItems.first.id,
            source: SelectionSource.ui,
          );
        }
      },
    );
  }

  /// Builds table view column definition
  List<AppTableColumn<core_graph.Node>> _buildTableColumns(
    List<core_graph.Node> nodes,
    ThemeData themeData,
    ColorScheme colorScheme,
  ) {
    // Theme is supplied by caller

    final columns = <AppTableColumn<core_graph.Node>>[
      AppTableColumn<core_graph.Node>(
        id: 'id',
        title: 'ID',
        width: 80.0,
        cellBuilder:
            (node, isSelected) => Text(
              node.id.value,
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : colorScheme.onSurface,
              ),
            ),
        sortable: true,
      ),
    ];

    // Get node property keys and dynamically add columns
    if (nodes.isNotEmpty) {
      // Collect property keys from all nodes (excluding internal app_ properties)
      final propertyKeys = <String>{};
      for (final node in nodes) {
        propertyKeys.addAll(
          node.properties.keys.where((key) => !key.startsWith('app_')),
        );
      }

      // Add columns for each property key
      for (final key in propertyKeys) {
        columns.add(
          AppTableColumn<core_graph.Node>(
            id: key,
            title: key,
            width: 120.0,
            cellBuilder: (node, isSelected) {
              final property = node.properties.getProperty(key);
              final value = property?.value ?? '';
              return Text(
                value.toString(),
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                ),
              );
            },
            sortable: true,
          ),
        );
      }
    }

    // Add label column
    columns.add(
      AppTableColumn<core_graph.Node>(
        id: 'labels',
        title: 'Labels',
        width: 120.0,
        cellBuilder:
            (node, isSelected) => Wrap(
              spacing: 4,
              children:
                  node.labels
                      .map(
                        (label) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.white24
                                    : colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            label,
                            style: themeData.textTheme.labelSmall?.copyWith(
                              color:
                                  isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
        sortable: true,
      ),
    );

    return columns;
  }
}
