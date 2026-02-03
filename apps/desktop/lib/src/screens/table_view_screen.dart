import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../providers/view_toolbar_providers.dart';

/// Screen to display table view
class TableViewScreen extends ConsumerWidget {
  const TableViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme settings (via core_themes)
    final colorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );
    final themeData = ref.watch(core_themes.effectiveThemeDataProvider);

    // Get active graph
    final activeGraph = ref.watch(core_graph.activeGraphProvider);

    // Use toolbar state
    final viewType = ref.watch(viewToolbarStateProvider);

    if (activeGraph == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Table View'),
          backgroundColor: colorScheme.surface,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.table,
                size: 64,
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text('No graph data', style: themeData.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Please open a stack from the home screen',
                style: themeData.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    // Get list of nodes from graph
    final nodes = activeGraph.nodes.values.toList();

    // Row selection state management is simply managed as local state
    // In actual implementation, more appropriate state management should be used

    // Column definition
    final columns = <AppTableColumn<core_graph.Node>>[
      AppTableColumn<core_graph.Node>(
        id: 'id',
        title: 'ID',
        width: 80.0,
        cellBuilder:
            (node, isSelected) => Text(
              node.id.value,
              style: TextStyle(
                color: isSelected ? Colors.white : colorScheme.onSurface,
              ),
            ),
        sortable: true,
      ),
    ];

    // Get node property keys and dynamically add columns
    if (nodes.isNotEmpty) {
      // Collect property keys from all nodes
      final propertyKeys = <String>{};
      for (final node in nodes) {
        propertyKeys.addAll(node.properties.keys);
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
                style: TextStyle(
                  color: isSelected ? Colors.white : colorScheme.onSurface,
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
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
        sortable: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Table View'),
        backgroundColor: colorScheme.surface,
      ),
      body: Column(
        children: [
          // Switch display based on view type
          if (viewType == 'table')
            Expanded(
              child: AppTableView<core_graph.Node>(
                columns: columns,
                data: nodes,
                keyExtractor: (node) => node.id.value,
                onRowsSelected:
                    (nodes) {}, // TODO: Implement proper state management
              ),
            )
          else if (viewType == 'network')
            Expanded(
              child: _PlaceholderView(
                title: 'Graph View',
                description:
                    'Graph database network visualization will be displayed here',
                icon: AppIcons.share2,
              ),
            )
          else
            Expanded(
              child: _PlaceholderView(
                title: '$viewType View',
                description: '$viewType View is not yet implemented',
                icon: _getIconForViewType(viewType),
              ),
            ),
        ],
      ),
    );
  }

  // Returns icon according to view type
  IconData _getIconForViewType(String viewType) {
    switch (viewType) {
      case 'table':
        return AppIcons.table;
      case 'network':
        return AppIcons.graphNavigation;
      case 'card':
        return AppIcons.table;
      case 'calendar':
        return AppIcons.calendar;
      case 'gantt':
        return Icons.bar_chart;
      default:
        return Icons.help_outline;
    }
  }
}

/// プレースホルダービュー
class _PlaceholderView extends ConsumerWidget {
  final String title;
  final String description;
  final IconData icon;

  const _PlaceholderView({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );
    final themeData = ref.watch(core_themes.effectiveThemeDataProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(title, style: themeData.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(description, style: themeData.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
