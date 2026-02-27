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

import '../providers/record_editor_providers.dart';
import 'custom_reorderable_list.dart';
import 'property_editor.dart';

/// Record editor inspector
class RecordEditor extends ConsumerWidget {
  /// Constructor
  const RecordEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(activeEntityProvider);
    final isLocked = ref.watch(entityLockProvider);
    final autoSave = ref.watch(autoSaveProvider);
    final propertyOrder = ref.watch(propertyOrderProvider);
    final recordEditorActions = ref.read(recordEditorActionsProvider.notifier);

    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final theme = Theme.of(context); // Keep for textTheme access
    final isNode = entity.kind == EntityKind.node;

    // Define reusable Divider
    const divider = AppDivider();

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: appColorScheme.interactive.input.border,
            width: 1.0,
          ),
        ),
        color: appColorScheme.base.background,
      ),
      // Use SizedBox to match height to parent container
      child: SizedBox(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                // Content positioned at top
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeaderSection(
                      context,
                      entity: entity,
                      isLocked: isLocked,
                      onLockToggle:
                          (locked) => ref
                              .read(entityLockProvider.notifier)
                              .setLocked(locked),
                      onEntityTypeSwitch:
                          (kind) => recordEditorActions.switchEntityType(kind),
                    ),
                    divider,

                    // Property section
                    _buildPropertySection(
                      context,
                      entity: entity,
                      propertyOrder: propertyOrder,
                      isLocked: isLocked,
                      autoSave: autoSave,
                      onAutoSaveToggle:
                          (enabled) => ref
                              .read(autoSaveProvider.notifier)
                              .setEnabled(enabled),
                      onReorder:
                          (oldIndex, newIndex) => recordEditorActions
                              .reorderProperty(oldIndex, newIndex),
                      onAddProperty:
                          ({
                            required String name,
                            required PropertyType type,
                          }) => recordEditorActions.addProperty(
                            name: name,
                            type: type,
                          ),
                      onRemoveProperty:
                          (propertyName) =>
                              recordEditorActions.removeProperty(propertyName),
                      onUpdateProperty:
                          (propertyName, value) => recordEditorActions
                              .updateProperty(propertyName, value),
                    ),

                    // Node-specific information
                    if (isNode) ...[
                      divider,
                      _buildConnectionsSection(context, entity as Node),
                    ],

                    // Link-specific information
                    if (!isNode && entity is Link) ...[
                      divider,
                      _buildLinkInfoSection(context, entity),
                    ],

                    divider,
                    _buildActionsSection(context, entity),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header section
  Widget _buildHeaderSection(
    BuildContext context, {
    required Entity entity,
    required bool isLocked,
    required ValueChanged<bool> onLockToggle,
    required void Function(EntityKind) onEntityTypeSwitch,
  }) {
    final theme = Theme.of(context);
    final isNode = entity.kind == EntityKind.node;
    final entityTypeName = isNode ? 'Node' : 'Link';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$entityTypeName Details', style: theme.textTheme.titleLarge),
            Row(
              children: [
                // Entity type switch button
                IconButton(
                  icon: Icon(isNode ? Icons.link : Icons.circle, size: 20),
                  tooltip: isNode ? 'Switch to Link' : 'Switch to Node',
                  onPressed:
                      () => onEntityTypeSwitch(
                        isNode ? EntityKind.link : EntityKind.node,
                      ),
                ),
                // Lock/Unlock button
                IconButton(
                  icon: Icon(isLocked ? Icons.lock : Icons.lock_open, size: 20),
                  tooltip: isLocked ? 'Unlock' : 'Lock',
                  onPressed: () => onLockToggle(!isLocked),
                ),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: 'Close',
                  onPressed: () {
                    // TODO: Close processing
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDetailRow(context, 'ID', entity.id.value, selectable: true),
      ],
    );
  }

  // Property section
  Widget _buildPropertySection(
    BuildContext context, {
    required Entity entity,
    required List<String> propertyOrder,
    required bool isLocked,
    required bool autoSave,
    required ValueChanged<bool> onAutoSaveToggle,
    required void Function(int, int) onReorder,
    required void Function({required String name, required PropertyType type})
    onAddProperty,
    required void Function(String) onRemoveProperty,
    required void Function(String, dynamic) onUpdateProperty,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Function to build property list
    Widget buildPropertyList() {
      return StatefulBuilder(
        builder: (context, setState) {
          // Build property list
          final List<Widget> propertyWidgets = [];

          for (int index = 0; index < propertyOrder.length; index++) {
            final propertyName = propertyOrder[index];
            final property = entity.getProperty(propertyName);
            if (property == null) continue;

            final propertyType = entity.description.propertyTypes[propertyName];
            final value = entity.getPropertyValue(propertyName);

            // Build each property widget
            propertyWidgets.add(
              PropertyEditor(
                key: ValueKey(propertyName),
                propertyName: propertyName,
                propertyType: propertyType,
                value: value,
                isLocked: isLocked,
                onRemove: () => onRemoveProperty(propertyName),
                onUpdate:
                    (newValue) => onUpdateProperty(propertyName, newValue),
                index: index, // Pass index
              ),
            );
          }

          // Use custom ReorderableList
          return CustomReorderableList(
            shrinkWrap: true,
            buildDefaultDragHandles: false,
            physics: const NeverScrollableScrollPhysics(),
            // Add callback to get property name
            getPropertyName: (child) {
              // Get property name from PropertyEditor widget
              if (child is PropertyEditor) {
                return child.propertyName;
              }
              // Get property name from Key (fallback)
              if (child.key is ValueKey) {
                final keyValue = (child.key as ValueKey).value;
                if (keyValue is String) {
                  return keyValue;
                }
              }
              return "Property";
            },
            proxyDecorator: (child, index, animation) {
              // Design Principle #6: Animation Prohibition - Apply static style without animation
              return Material(
                elevation: 6,
                color: Colors.transparent,
                shadowColor: colorScheme.shadow,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.primary, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: child,
                ),
              );
            },
            onReorderStart: (index) {
              debugPrint('onReorderStart: $index');
              // Processing when drag starts
              setState(() {
                // Update state as needed
              });
            },
            onReorderEnd: (index) {
              debugPrint('onReorderEnd: $index');
              // Processing when drag ends
              setState(() {
                // Update state as needed
              });
            },
            onReorder: (oldIndex, newIndex) {
              debugPrint('onReorder: $oldIndex -> $newIndex');
              if (!isLocked) {
                onReorder(oldIndex, newIndex);
              }
            },
            children: propertyWidgets,
          );
        },
      );
    }

    // Property section header
    Widget headerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Properties', style: theme.textTheme.titleMedium),
        Row(
          children: [
            // Auto-save toggle
            Row(
              children: [
                Text('Auto-save', style: theme.textTheme.bodySmall),
                Switch(
                  value: autoSave,
                  onChanged: isLocked ? null : onAutoSaveToggle,
                ),
              ],
            ),
            // Add property button
            IconButton(
              icon: const Icon(AppIcons.plus),
              tooltip: 'Add property',
              onPressed:
                  isLocked
                      ? null
                      : () => _showAddPropertyDialog(
                        context,
                        onAddProperty: onAddProperty,
                      ),
            ),
          ],
        ),
      ],
    );

    // Create collapsible section using AppExpansionTile
    return AppExpansionTile(
      title: headerRow,
      initiallyExpanded: true, // Initially expanded
      childrenPadding: const EdgeInsets.only(top: 8.0),
      tilePadding: EdgeInsets.zero, // Use custom padding
      children: [buildPropertyList()],
    );
  }

  // Connections section (for nodes)
  Widget _buildConnectionsSection(BuildContext context, Node node) {
    final theme = Theme.of(context);

    // Function to build connections list
    Widget buildConnectionsList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Incoming links
          Text('Incoming Links (2)', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          _buildLinkItem(
            context,
            linkType: 'Dependency',
            nodeLabel: 'Task B',
            isIncoming: true,
          ),
          _buildLinkItem(
            context,
            linkType: 'Reference',
            nodeLabel: 'Document C',
            isIncoming: true,
          ),
          const SizedBox(height: 8),
          // Outgoing links
          Text('Outgoing Links (1)', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          _buildLinkItem(
            context,
            linkType: 'Owns',
            nodeLabel: 'User D',
            isIncoming: false,
          ),
        ],
      );
    }

    // Connections section header
    Widget headerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Connections', style: theme.textTheme.titleMedium),
        IconButton(
          icon: const Icon(AppIcons.plus),
          tooltip: 'Add connection',
          onPressed: () {
            // TODO: Add connection dialog
          },
        ),
      ],
    );

    // Create collapsible section using AppExpansionTile
    return AppExpansionTile(
      title: headerRow,
      initiallyExpanded: true, // Initially expanded
      childrenPadding: const EdgeInsets.only(top: 8.0),
      tilePadding: EdgeInsets.zero, // Use custom padding
      children: [buildConnectionsList()],
    );
  }

  // Link info section (for links)
  Widget _buildLinkInfoSection(BuildContext context, Link link) {
    final theme = Theme.of(context);

    // Function to build link info list
    Widget buildLinkInfoList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(context, 'Type', link.type),
          _buildDetailRow(
            context,
            'Source Node',
            link.sourceId.value,
            selectable: true,
          ),
          _buildDetailRow(
            context,
            'Target Node',
            link.targetId.value,
            selectable: true,
          ),
        ],
      );
    }

    // Link info section header
    Widget headerRow = Text('Link Info', style: theme.textTheme.titleMedium);

    // Create collapsible section using AppExpansionTile
    return AppExpansionTile(
      title: headerRow,
      initiallyExpanded: true, // Initially expanded
      childrenPadding: const EdgeInsets.only(top: 8.0),
      tilePadding: EdgeInsets.zero, // Use custom padding
      children: [buildLinkInfoList()],
    );
  }

  // Actions section
  Widget _buildActionsSection(BuildContext context, Entity entity) {
    final theme = Theme.of(context);

    // Determine if entity is archived
    final isArchived = entity.getPropertyValue('app_archived') == true;

    // Function to build actions list
    Widget buildActionsList() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (isArchived) ...[
            // Show restore button if archived
            ElevatedButton.icon(
              icon: const Icon(AppIcons.archiveOutlined),
              label: const Text('Restore'),
              onPressed: () {
                // TODO: Restore processing
              },
            ),
          ] else ...[
            // Show normal actions if not archived
            ElevatedButton.icon(
              icon: const Icon(AppIcons.archiveOutlined),
              label: const Text('Archive'),
              onPressed: () {
                // TODO: Archive processing
              },
            ),
          ],
          ElevatedButton.icon(
            icon: const Icon(AppIcons.copy),
            label: const Text('Duplicate'),
            onPressed: () {
              // TODO: Duplicate processing
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(AppIcons.timeline),
            label: const Text('History'),
            onPressed: () {
              // TODO: Show history
            },
          ),
        ],
      );
    }

    // Actions section header
    Widget headerRow = Text('Actions', style: theme.textTheme.titleMedium);

    // Create collapsible section using AppExpansionTile
    return AppExpansionTile(
      title: headerRow,
      initiallyExpanded: true, // Initially expanded
      childrenPadding: const EdgeInsets.only(top: 8.0),
      tilePadding: EdgeInsets.zero, // Use custom padding
      children: [buildActionsList()],
    );
  }

  // Helper to build detail row
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool selectable = false,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Make value selectable (for IDs, etc.)
    final valueWidget =
        selectable
            ? SelectableText(value, style: textTheme.bodyMedium)
            : Text(value, style: textTheme.bodyMedium);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }

  // Helper to build link item
  Widget _buildLinkItem(
    BuildContext context, {
    required String linkType,
    required String nodeLabel,
    required bool isIncoming,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        children: [
          Text(
            isIncoming ? '├─ ' : '└─ ',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            '$linkType ${isIncoming ? '←' : '→'} $nodeLabel',
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(AppIcons.edit, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Edit',
            onPressed: () {
              // TODO: Edit link
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(AppIcons.deleteOutline, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Delete',
            onPressed: () {
              // TODO: Delete link
            },
          ),
        ],
      ),
    );
  }

  // Show add property dialog
  void _showAddPropertyDialog(
    BuildContext context, {
    required void Function({required String name, required PropertyType type})
    onAddProperty,
  }) {
    final nameController = TextEditingController();
    PropertyType selectedType = const TextPropertyType();
    bool isMultiline = false;
    bool isRequired = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Property'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Property Name',
                        hintText: 'e.g. title, age, email, etc.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Property Type',
                      ),
                      initialValue: 'text',
                      items: const [
                        DropdownMenuItem(value: 'text', child: Text('Text')),
                        DropdownMenuItem(
                          value: 'integer',
                          child: Text('Integer'),
                        ),
                        DropdownMenuItem(
                          value: 'boolean',
                          child: Text('Boolean'),
                        ),
                        DropdownMenuItem(value: 'date', child: Text('Date')),
                        DropdownMenuItem(
                          value: 'email',
                          child: Text('Email Address'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          switch (value) {
                            case 'text':
                              selectedType = const TextPropertyType();
                              break;
                            case 'integer':
                              selectedType = const IntegerPropertyType();
                              break;
                            case 'boolean':
                              selectedType = const BooleanPropertyType();
                              break;
                            case 'date':
                              selectedType = const DatePropertyType();
                              break;
                            case 'email':
                              selectedType = const EmailPropertyType();
                              break;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Type-specific settings:'),
                    if (selectedType is TextPropertyType) ...[
                      CheckboxListTile(
                        title: const Text('Multi-line text'),
                        value: isMultiline,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            isMultiline = value ?? false;
                          });
                        },
                      ),
                    ],
                    CheckboxListTile(
                      title: const Text('Required field'),
                      value: isRequired,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          isRequired = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    // Create PropertyType based on type
                    PropertyType finalType;
                    if (selectedType is TextPropertyType) {
                      finalType = TextPropertyType(isRequired: isRequired);
                    } else if (selectedType is IntegerPropertyType) {
                      finalType = IntegerPropertyType(isRequired: isRequired);
                    } else if (selectedType is BooleanPropertyType) {
                      finalType = BooleanPropertyType(isRequired: isRequired);
                    } else if (selectedType is DatePropertyType) {
                      finalType = DatePropertyType(isRequired: isRequired);
                    } else if (selectedType is EmailPropertyType) {
                      finalType = EmailPropertyType(isRequired: isRequired);
                    } else {
                      finalType = const AnyPropertyType();
                    }

                    onAddProperty(name: name, type: finalType);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
