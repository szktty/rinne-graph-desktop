import 'package:core_graph_flutter/core_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

import '../providers/record_editor_providers.dart';
import '../providers/tab_view_providers.dart';

/// Tab-based record editor
class TabbedRecordEditor extends ConsumerWidget {
  /// Constructor
  const TabbedRecordEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(activeEntityProvider);
    final tabState = ref.watch(tabViewStateProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Define tabs for use in AppTabView
    final tabs = [
      AppTab(
        id: 'info',
        icon: AppIcons.id,
        tooltip: 'Information',
        closeable: false,
      ),
      AppTab(
        id: 'properties',
        icon: AppIcons.properties,
        tooltip: 'Properties',
        closeable: false,
      ),
      AppTab(
        id: 'links',
        icon: AppIcons.connections,
        tooltip: 'Links',
        closeable: false,
      ),
      AppTab(
        id: 'display',
        icon: AppIcons.display,
        tooltip: 'Display',
        closeable: false,
      ),
    ];

    // Define content for use in AppTabView
    final contents = [
      AppTabContent(id: 'info', content: EntityInfoTab(entity: entity)),
      AppTabContent(
        id: 'properties',
        content: EntityPropertiesTab(entity: entity),
      ),
      AppTabContent(id: 'links', content: EntityLinksTab(entity: entity)),
      AppTabContent(id: 'display', content: EntityDisplayTab(entity: entity)),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: appColorScheme.base.divider, width: 1.0),
        ),
        color: appColorScheme.base.background,
      ),
      child: AppTabView(
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
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: 'Sample memo text');
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNode = widget.entity.kind == EntityKind.node;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic information section
          FormList(
            title: 'Basic Information',
            children: [
              FormItemColumn(
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
            FormList(
              title: 'Labels',
              children: [
                FormItemColumn(
                  label: 'Label List',
                  child: AppTagsField(
                    initialTags: (widget.entity as Node).labels.toList(),
                    hintText: 'Enter label...',
                    validator: (tag) {
                      if (tag.isEmpty) {
                        return 'Cannot add empty label';
                      }
                      if (tag.length > 30) {
                        return 'Label must be 30 characters or less';
                      }
                      return null;
                    },
                    onTagsChanged: (tags) {
                      // In actual implementation, update entity labels here
                      // Example: updateEntityLabels(tags);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Link information (for links)
          if (!isNode && widget.entity is Link) ...[
            FormList(
              title: 'Link Information',
              children: [
                FormItemColumn(
                  label: 'Type',
                  child: SelectableText((widget.entity as Link).type),
                ),
                FormItemColumn(
                  label: 'Source Node',
                  child: SelectableText(
                    (widget.entity as Link).sourceId.value,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                FormItemColumn(
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

          // Memo section
          FormList(
            title: 'Memo',
            children: [
              FormItemColumn(
                label: 'Memo Content',
                child: AppTextField(
                  controller: _memoController,
                  maxLines: 5,
                  hintText: 'Enter memo...',
                  onChanged: (value) {
                    // Memo update processing
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date information section
          FormList(
            title: 'Date Information',
            children: [
              FormItemColumn(
                label: 'Created Date',
                child: const SelectableText('2023-06-15 10:30:00'),
              ),
              FormItemColumn(
                label: 'Updated Date',
                child: const SelectableText('2023-06-20 15:45:22'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Delete button
          FormList(
            title: 'Actions',
            children: [
              FormItemColumn(
                label: 'Delete Entity',
                child: AppButton(
                  label: 'Delete',
                  leadingIcon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete processing (show dialog, etc.)
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
          FormList(
            title: 'Property Management',
            children: [
              FormItemColumn(
                label: 'New Property',
                child: AppButton(
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
            FormList(
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
            FormList(
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

  // Helper to build property item as FormItemColumn
  Widget _buildPropertyFormItem(
    BuildContext context,
    String name,
    dynamic value,
    PropertyType? type,
  ) {
    final displayValue = value?.toString() ?? '(none)';

    return FormItemColumn(
      label: name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            readOnly: true,
            controller: TextEditingController(text: displayValue),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Edit',
                  leadingIcon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    // Edit processing
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
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
          FormList(
            title: 'Link Management',
            children: [
              FormItemColumn(
                label: 'New Link',
                child: AppButton(
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
            FormList(
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
            FormList(
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
            FormList(
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

  // Helper to build link item as FormItemColumn
  Widget _buildLinkFormItem(
    BuildContext context,
    String linkType,
    String nodeLabel, {
    required bool isIncoming,
  }) {
    final direction = isIncoming ? '←' : '→';
    final linkDescription = '$linkType $direction $nodeLabel';

    return FormItemColumn(
      label: linkType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(linkDescription, variant: AppTextVariant.bodyText),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Edit',
                  leadingIcon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    // Link edit processing
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
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
          FormItemColumn(
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
