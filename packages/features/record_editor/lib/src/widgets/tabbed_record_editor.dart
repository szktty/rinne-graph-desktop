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
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

import '../providers/record_editor_providers.dart';
import '../providers/tab_view_providers.dart';
import 'graph_entity_properties_display.dart';

/// Tab-based record editor
class TabbedRecordEditor extends ConsumerWidget {
  /// Constructor
  const TabbedRecordEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(activeEntityProvider);
    final tabState = ref.watch(tabViewStateProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Define tabs for use in FondeTabView
    final tabs = [
      FondeTab(
        id: 'info',
        icon: FondeIcons.id,
        tooltip: 'Information',
        closeable: false,
      ),
      FondeTab(
        id: 'properties',
        icon: FondeIcons.properties,
        tooltip: 'Properties',
        closeable: false,
      ),
      FondeTab(
        id: 'links',
        icon: FondeIcons.connections,
        tooltip: 'Links',
        closeable: false,
      ),
      FondeTab(
        id: 'display',
        icon: FondeIcons.display,
        tooltip: 'Display',
        closeable: false,
      ),
    ];

    // Define content for use in FondeTabView
    final contents = [
      FondeTabContent(id: 'info', content: EntityInfoTab(entity: entity)),
      // The properties tab shows the real thing: GraphEntityPropertiesDisplay
      // reads the entity's properties, edits them through
      // editingEntityPropertiesProvider, and saves via saveEntityActionProvider.
      // EntityPropertiesTab below is the read-only mock it replaced.
      const FondeTabContent(
        id: 'properties',
        content: GraphEntityPropertiesDisplay(),
      ),
      FondeTabContent(id: 'links', content: EntityLinksTab(entity: entity)),
      FondeTabContent(id: 'display', content: EntityDisplayTab(entity: entity)),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: appColorScheme.base.divider, width: 1.0),
        ),
        color: appColorScheme.base.background,
      ),
      child: FondeTabView(
        tabs: tabs,
        contents: contents,
        initialSelectedTabId: tabState ?? 'info',
        onTabSelected: (tabId) {
          ref.read(tabViewStateProvider.notifier).selectTab(tabId);
        },
        tabBarHeight: 48.0,
        tabBarBackgroundColor: appColorScheme.base.background,
        contentBackgroundColor: appColorScheme.base.background,
        showDivider: true,
        dividerColor: appColorScheme.base.divider,
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }
}

/// Entity information tab
class EntityInfoTab extends ConsumerStatefulWidget {
  /// Constructor
  const EntityInfoTab({required this.entity, super.key});

  /// Entity to display
  final Entity entity;

  @override
  ConsumerState<EntityInfoTab> createState() => _EntityInfoTabState();
}

class _EntityInfoTabState extends ConsumerState<EntityInfoTab> {
  /// Formats a timestamp as local `YYYY-MM-DD HH:MM:SS`.
  ///
  /// Written out rather than pulled from intl: the package is not a dependency
  /// here, and this is the only place that needs a formatted date.
  static String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final isNode = widget.entity.kind == EntityKind.node;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic information section
          FondeFormList(
            title: 'Basic Information',
            children: [
              FondeFormItemColumn(
                label: 'ID',
                child: SelectableText(
                  widget.entity.id.value,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Label information (for nodes)
          if (isNode) ...[
            FondeFormList(
              title: 'Labels',
              children: [
                FondeFormItemColumn(
                  label: 'Label List',
                  // Read-only for now. This was a FondeTagsField whose
                  // onTagsChanged did nothing, so labels could be added and
                  // removed on screen and none of it reached the entity.
                  // Editing labels needs a save path of its own; until then,
                  // show them rather than pretend they are editable.
                  child: _LabelList(labels: (widget.entity as Node).labels),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Link information (for links)
          if (!isNode && widget.entity is Link) ...[
            FondeFormList(
              title: 'Link Information',
              children: [
                FondeFormItemColumn(
                  label: 'Type',
                  child: SelectableText((widget.entity as Link).type),
                ),
                FondeFormItemColumn(
                  label: 'Source Node',
                  child: SelectableText(
                    (widget.entity as Link).sourceId.value,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                FondeFormItemColumn(
                  label: 'Target Node',
                  child: SelectableText(
                    (widget.entity as Link).targetId.value,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // A Memo section used to sit here, backed by nothing but the string
          // 'Sample memo text'. Entities have no memo field, so it is left out
          // until the concept is specified rather than shown as an input that
          // silently discards what is typed into it.

          // Date information section
          FondeFormList(
            title: 'Date Information',
            children: [
              FondeFormItemColumn(
                label: 'Created Date',
                child: SelectableText(_formatDateTime(widget.entity.createdAt)),
              ),
              FondeFormItemColumn(
                label: 'Updated Date',
                child: SelectableText(_formatDateTime(widget.entity.updatedAt)),
              ),
            ],
          ),

          // An Actions section with a Delete button used to sit here, wired to
          // an empty callback — it looked destructive and did nothing. Deleting
          // an entity needs a confirmation dialog, link cleanup and a graph
          // refresh, so the button stays out until that exists.
        ],
      ),
    );
  }
}

/// Read-only list of an entity's labels, rendered as chips.
class _LabelList extends ConsumerWidget {
  const _LabelList({required this.labels});

  final Set<String> labels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    if (labels.isEmpty) {
      return AppText(
        'No labels',
        variant: AppTextVariant.bodyText,
        color: colorScheme.base.foreground.withAlpha(128),
      );
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final label in labels)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.base.background.withAlpha(200),
              border: Border.all(color: colorScheme.base.divider, width: 1.0),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: AppText(label, variant: AppTextVariant.bodyText),
          ),
      ],
    );
  }
}

/// Entity properties tab
class EntityPropertiesTab extends ConsumerWidget {
  /// Constructor
  const EntityPropertiesTab({required this.entity, super.key});

  /// Entity to display
  final Entity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = entity.properties.toMap();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property management section
          FondeFormList(
            title: 'Property Management',
            children: [
              FondeFormItemColumn(
                label: 'New Property',
                child: FondeButton(
                  label: 'Add Property',
                  leadingIcon: const Icon(Icons.add),
                  onPressed: () {
                    // Show property add dialog
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Property list
          if (properties.isEmpty)
            FondeFormList(
              title: 'Property List',
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AppText(
                    'No properties',
                    variant: AppTextVariant.bodyText,
                  ),
                ),
              ),
            )
          else
            FondeFormList(
              title: 'Property List',
              collapsible: true,
              initiallyExpanded: true,
              children:
                  properties.entries.map((entry) {
                    final key = entry.key;
                    final value = entry.value;
                    final propertyType = entity.description.propertyTypes[key];

                    return _buildPropertyFormItem(
                      context,
                      key,
                      value,
                      propertyType,
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  // Helper to build property item as FondeFormItemColumn
  Widget _buildPropertyFormItem(
    BuildContext context,
    String name,
    dynamic value,
    PropertyType? type,
  ) {
    final displayValue = value?.toString() ?? '(none)';

    return FondeFormItemColumn(
      label: name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FondeTextField(
            readOnly: true,
            controller: TextEditingController(text: displayValue),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FondeButton(
                  label: 'Edit',
                  leadingIcon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    // Edit processing
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FondeButton(
                  label: 'Delete',
                  leadingIcon: const Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Delete processing
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Entity links tab
class EntityLinksTab extends ConsumerWidget {
  /// Constructor
  const EntityLinksTab({required this.entity, super.key});

  /// Entity to display
  final Entity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNode = entity.kind == EntityKind.node;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Link management section
          FondeFormList(
            title: 'Link Management',
            children: [
              FondeFormItemColumn(
                label: 'New Link',
                child: FondeButton(
                  label: 'Add Link',
                  leadingIcon: const Icon(Icons.add),
                  onPressed: () {
                    // Show link add dialog
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (isNode) ...[
            // Incoming links section
            FondeFormList(
              title: 'Incoming Links',
              collapsible: true,
              initiallyExpanded: true,
              children: [
                _buildLinkFormItem(
                  context,
                  'Dependency',
                  'Task B',
                  isIncoming: true,
                ),
                _buildLinkFormItem(
                  context,
                  'Reference',
                  'Document C',
                  isIncoming: true,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Outgoing links section
            FondeFormList(
              title: 'Outgoing Links',
              collapsible: true,
              initiallyExpanded: true,
              children: [
                _buildLinkFormItem(
                  context,
                  'Owns',
                  'User D',
                  isIncoming: false,
                ),
              ],
            ),
          ] else
            FondeFormList(
              title: 'Link Information',
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AppText(
                    'Link entities have no link information',
                    variant: AppTextVariant.bodyText,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper to build link item as FondeFormItemColumn
  Widget _buildLinkFormItem(
    BuildContext context,
    String linkType,
    String nodeLabel, {
    required bool isIncoming,
  }) {
    final direction = isIncoming ? '←' : '→';
    final linkDescription = '$linkType $direction $nodeLabel';

    return FondeFormItemColumn(
      label: linkType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(linkDescription, variant: AppTextVariant.bodyText),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FondeButton(
                  label: 'Edit',
                  leadingIcon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    // Link edit processing
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FondeButton(
                  label: 'Delete',
                  leadingIcon: const Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Link delete processing
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Entity display tab
class EntityDisplayTab extends ConsumerStatefulWidget {
  /// Constructor
  const EntityDisplayTab({required this.entity, super.key});

  /// Entity to display
  final Entity entity;

  @override
  ConsumerState<EntityDisplayTab> createState() => _EntityDisplayTabState();
}

class _EntityDisplayTabState extends ConsumerState<EntityDisplayTab> {
  ThemeColorType? _selectedColor;

  /// Determine check icon color (select white or black based on color)
  Color _getCheckIconColor(ThemeColorType colorType, Color backgroundColor) {
    // Light colors (yellow, orange, pink) get black check
    // Dark colors (blue, indigo, violet, red, green, graphite) get white check
    switch (colorType) {
      case ThemeColorType.yellow:
      case ThemeColorType.orange:
        return Colors.black;
      case ThemeColorType.blue:
      case ThemeColorType.indigo:
      case ThemeColorType.violet:
      case ThemeColorType.pink:
      case ThemeColorType.red:
      case ThemeColorType.green:
      case ThemeColorType.graphite:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final themeColorScheme = ref.watch(themeColorSchemeProvider);
    final currentThemeColor = ref.watch(themeColorTypeProvider);

    // Set initial value to current theme color
    _selectedColor ??= currentThemeColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color settings section
          FondeFormItemColumn(
            label: 'Color',
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  ThemeColorType.values.map((colorType) {
                    final colorDefinition = themeColorScheme.colors[colorType]!;
                    final color =
                        appColorScheme.brightness == Brightness.dark
                            ? colorDefinition.darkColor
                            : colorDefinition.lightColor;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorType;
                        });
                        // Theme color change processing
                        ref
                            .read(themeColorTypeProvider.notifier)
                            .setThemeColor(colorType);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(
                            color:
                                _selectedColor == colorType
                                    ? appColorScheme.base.foreground
                                    : appColorScheme.base.border,
                            width: _selectedColor == colorType ? 3 : 1,
                          ),
                        ),
                        child:
                            _selectedColor == colorType
                                ? Icon(
                                  Icons.check,
                                  color: _getCheckIconColor(colorType, color),
                                  size: 20,
                                )
                                : null,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
