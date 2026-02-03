import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:core_stack_flutter/core_stack.dart' hide Stack;
import 'package:features_archive/features_archive.dart';

/// Navigation tab content widget
/// Provides bookmark and history features
class NavigationTabContent extends ConsumerWidget {
  const NavigationTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedEntitiesAsync = ref.watch(archivedEntitiesProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Navigation List ---
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigation items (no section title)
                  DatasetItem(
                    icon: AppIcons.database,
                    name: 'All',
                    nodeCount: 0,
                    linkCount: 0,
                    isSelected: true,
                    onTap: () {
                      // TODO: Implement all entity display functionality
                    },
                  ),
                  DatasetItem(
                    icon: AppIcons.star,
                    name: 'Starred',
                    nodeCount: 0,
                    linkCount: 0,
                    isSelected: false,
                    onTap: () {
                      // TODO: Implement starred item display functionality
                    },
                  ),
                  DatasetItem(
                    icon: AppIcons.circle,
                    name: 'All Nodes',
                    nodeCount: 0,
                    linkCount: 0,
                    isSelected: false,
                    onTap: () {
                      // TODO: Implement all node display functionality
                    },
                  ),
                  DatasetItem(
                    icon: AppIcons.arrowRight,
                    name: 'All Links',
                    nodeCount: 0,
                    linkCount: 0,
                    isSelected: false,
                    onTap: () {
                      // TODO: Implement all link display functionality
                    },
                  ),
                  DatasetItem(
                    icon: AppIcons.timeline,
                    name: 'Recently Modified Items',
                    nodeCount: 0,
                    linkCount: 0,
                    isSelected: false,
                    onTap: () {
                      // TODO: Implement recently modified items display functionality
                    },
                  ),
                  DatasetItem(
                    icon: AppIcons.plus,
                    name: 'Recently Added Items',
                    nodeCount: 0,
                    linkCount: 0,
                    isSelected: false,
                    onTap: () {
                      // TODO: Implement recently added items display functionality
                    },
                  ),

                  // Separator
                  const SizedBox(height: 8),
                  const AppDivider(),
                  const SizedBox(height: 8),

                  // Archived items
                  archivedEntitiesAsync.when(
                    data: (archivedEntities) {
                      final nodeCount =
                          archivedEntities
                              .where((e) => e.type == 'node')
                              .length;
                      final linkCount =
                          archivedEntities
                              .where((e) => e.type == 'link')
                              .length;

                      return DatasetItem(
                        icon: AppIcons.archiveOutlined,
                        name: 'Archived',
                        nodeCount: nodeCount,
                        linkCount: linkCount,
                        isSelected: false,
                        onTap: () {
                          _showArchivedEntitiesDialog(
                            context,
                            archivedEntities,
                          );
                        },
                      );
                    },
                    loading:
                        () => DatasetItem(
                          icon: AppIcons.archiveOutlined,
                          name: 'Archived',
                          nodeCount: 0,
                          linkCount: 0,
                          isSelected: false,
                          onTap: () {},
                        ),
                    error:
                        (error, stack) => DatasetItem(
                          icon: AppIcons.archiveOutlined,
                          name: 'Archived',
                          nodeCount: 0,
                          linkCount: 0,
                          isSelected: false,
                          onTap: () {},
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Displays the archived entities dialog
  void _showArchivedEntitiesDialog(
    BuildContext context,
    List<ArchivedEntity> archivedEntities,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: const SizedBox(
              width: 800,
              height: 600,
              child: ArchivedEntityList(),
            ),
          ),
    );
  }
}

/// Alias for backward compatibility
/// To be deleted in the future
@Deprecated('Use NavigationTabContent instead')
class DatasetTabContent extends NavigationTabContent {
  const DatasetTabContent({super.key});
}

/// Dataset section
class DatasetSection extends ConsumerWidget {
  final String title;
  final IconData icon;
  final List<DatasetItem> datasets;

  const DatasetSection({
    required this.title,
    required this.icon,
    required this.datasets,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Flexible(
                child: AppText(
                  title,
                  variant: AppTextVariant.captionText,
                  color: colorScheme.onSurfaceVariant,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Dataset list
        ...datasets,
      ],
    );
  }
}

/// Dataset item
class DatasetItem extends ConsumerWidget {
  final IconData icon;
  final String name;
  final int nodeCount;
  final int linkCount;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DatasetItem({
    required this.icon,
    required this.name,
    required this.nodeCount,
    required this.linkCount,
    required this.isSelected,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? colorScheme.surfaceContainerHighest
                : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: isSelected ? Border.all(color: colorScheme.primary) : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Icon(
                icon,
                size: 14,
                color:
                    isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      name,
                      variant: AppTextVariant.bodyText,
                      color:
                          isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (nodeCount > 0 || linkCount > 0)
                      AppText(
                        '${nodeCount}N/${linkCount}L',
                        variant: AppTextVariant.captionText,
                        color: colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: Icon(AppIcons.ellipsis, size: 14),
                  iconSize: 14,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  itemBuilder:
                      (context) => [
                        if (onEdit != null)
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(AppIcons.settings, size: 14),
                                const SizedBox(width: 8),
                                const Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(AppIcons.x, size: 14),
                                const SizedBox(width: 8),
                                const Text('Delete'),
                              ],
                            ),
                          ),
                      ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dataset section (async)
class DatasetSectionAsync extends ConsumerWidget {
  final String title;
  final IconData icon;
  final Future<List<Dataset>> datasetsFuture;
  final void Function(Dataset) onItemTap;

  const DatasetSectionAsync({
    required this.title,
    required this.icon,
    required this.datasetsFuture,
    required this.onItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Flexible(
                child: AppText(
                  title,
                  variant: AppTextVariant.captionText,
                  color: colorScheme.onSurfaceVariant,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Dataset list (async)
        FutureBuilder<List<Dataset>>(
          future: datasetsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppText(
                  'Error: ${snapshot.error}',
                  variant: AppTextVariant.captionText,
                  color: colorScheme.error,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppText(
                  'No datasets available',
                  variant: AppTextVariant.captionText,
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            } else {
              final datasets = snapshot.data!;
              return Column(
                children:
                    datasets
                        .map(
                          (dataset) => DatasetItemFromDataset(
                            dataset: dataset,
                            isSelected: false, // TODO: Manage selection state
                            onTap: () => onItemTap(dataset),
                            onEdit:
                                dataset.type == DatasetType.saved
                                    ? () {
                                      // TODO: Edit dataset
                                    }
                                    : null,
                            onDelete:
                                dataset.type != DatasetType.preset
                                    ? () {
                                      // TODO: Delete dataset
                                    }
                                    : null,
                          ),
                        )
                        .toList(),
              );
            }
          },
        ),
      ],
    );
  }
}

/// Dataset item created from a Dataset object
class DatasetItemFromDataset extends StatelessWidget {
  final Dataset dataset;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DatasetItemFromDataset({
    required this.dataset,
    required this.isSelected,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  IconData _getDatasetIcon(DatasetType type) {
    switch (type) {
      case DatasetType.preset:
        final presetType = dataset.metadata['preset_type'] as String?;
        switch (presetType) {
          case 'all':
            return AppIcons.database;
          case 'recent':
            return AppIcons.timeline;
          case 'bookmarks':
            return AppIcons.star;
          default:
            return AppIcons.database;
        }
      case DatasetType.saved:
        return AppIcons.save;
      case DatasetType.temporary:
        return AppIcons.timeline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodeCount = dataset.metadata['node_count'] as int? ?? 0;
    final linkCount = dataset.metadata['link_count'] as int? ?? 0;

    return DatasetItem(
      icon: _getDatasetIcon(dataset.type),
      name: dataset.name,
      nodeCount: nodeCount,
      linkCount: linkCount,
      isSelected: isSelected,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
