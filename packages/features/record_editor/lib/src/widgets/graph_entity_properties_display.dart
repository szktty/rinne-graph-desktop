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

import '../providers/entity_properties_providers.dart';

/// A widget that displays the properties of a selected entity in the graph view
///
/// Dynamically retrieves and displays properties as key-value pairs.
/// Property names are not hardcoded.
class GraphEntityPropertiesDisplay extends ConsumerWidget {
  /// Constructor
  const GraphEntityPropertiesDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final labels = ref.watch(selectedEntityLabelsProvider);
    // Monitor properties being edited
    final editingProperties = ref.watch(editingEntityPropertiesProvider);
    final editingPropertyKeys = editingProperties.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with Save/Cancel buttons
        _buildHeader(appColorScheme),
        // Scrollable content
        Expanded(
          child: AppScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Labels section
                  _buildLabelsSection(
                    labels: labels,
                    colorScheme: appColorScheme,
                  ),
                  const SizedBox(height: 24),

                  // Properties section
                  _buildPropertiesSection(
                    properties: editingProperties,
                    propertyKeys: editingPropertyKeys,
                    colorScheme: appColorScheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the editor header with Save/Cancel icon buttons
  Widget _buildHeader(AppColorScheme colorScheme) {
    return Consumer(
      builder: (context, ref, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.base.divider, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(AppIcons.save),
                iconSize: 18.0,
                tooltip: 'Save',
                onPressed: () => _saveProperties(context, ref),
                color: colorScheme.base.foreground,
              ),
              const SizedBox(width: 4.0),
              IconButton(
                icon: const Icon(AppIcons.rotateCcw),
                iconSize: 18.0,
                tooltip: 'Cancel',
                onPressed: () => _cancelEditing(ref),
                color: colorScheme.base.foreground,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the labels section
  Widget _buildLabelsSection({
    required List<String> labels,
    required AppColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Labels', variant: AppTextVariant.sectionTitlePrimary),
        const SizedBox(height: 12),
        if (labels.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AppText(
              'No labels',
              variant: AppTextVariant.bodyText,
              color: colorScheme.base.foreground.withAlpha(128),
            ),
          )
        else
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                labels.map((label) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.base.background.withAlpha(200),
                      border: Border.all(
                        color: colorScheme.base.divider,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: AppText(label, variant: AppTextVariant.bodyText),
                  );
                }).toList(),
          ),
      ],
    );
  }

  /// Builds the properties section
  Widget _buildPropertiesSection({
    required Map<String, dynamic> properties,
    required List<String> propertyKeys,
    required AppColorScheme colorScheme,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        // Monitor properties being edited and update UI when property name changes
        final currentEditingProperties = ref.watch(
          editingEntityPropertiesProvider,
        );
        final currentPropertyKeys = currentEditingProperties.keys.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Properties', variant: AppTextVariant.sectionTitlePrimary),
            const SizedBox(height: 12),
            if (currentPropertyKeys.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AppText(
                  'No properties',
                  variant: AppTextVariant.bodyText,
                  color: colorScheme.base.foreground.withAlpha(128),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    currentPropertyKeys.map((key) {
                      final value = currentEditingProperties[key];
                      return _buildEditablePropertyItem(
                        key: key,
                        value: value,
                        colorScheme: colorScheme,
                        onChanged: (newValue) {
                          ref
                              .read(editingEntityPropertiesProvider.notifier)
                              .updateProperty(key, newValue);
                        },
                      );
                    }).toList(),
              ),
          ],
        );
      },
    );
  }

  /// Builds an editable property item
  Widget _buildEditablePropertyItem({
    required String key,
    required dynamic value,
    required AppColorScheme colorScheme,
    required ValueChanged<String> onChanged,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final editingNames = ref.watch(editingPropertyNamesProvider);
        final isEditingName = editingNames.containsKey(key);
        final editingName = editingNames[key] ?? key;

        // Create the controller within the Consumer, so a new controller is not created on rebuild
        final controller = TextEditingController(text: _formatValue(value));

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property name (editable)
              _buildEditablePropertyName(
                key: key,
                isEditing: isEditingName,
                editingName: editingName,
                colorScheme: colorScheme,
                ref: ref,
              ),
              const SizedBox(height: 4),
              // Property value
              AppTextField(
                controller: controller,
                onChanged: onChanged,
                hintText: 'Enter value',
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// Builds an editable property name
  Widget _buildEditablePropertyName({
    required String key,
    required bool isEditing,
    required String editingName,
    required AppColorScheme colorScheme,
    required WidgetRef ref,
  }) {
    if (isEditing) {
      return _buildPropertyNameEditor(
        key: key,
        editingName: editingName,
        colorScheme: colorScheme,
        ref: ref,
      );
    } else {
      return GestureDetector(
        onTap: () {
          ref
              .read(editingPropertyNamesProvider.notifier)
              .startEditing(key, key);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AppText(
            key,
            variant: AppTextVariant.captionText,
            color: colorScheme.base.foreground.withAlpha(180),
          ),
        ),
      );
    }
  }

  /// Builds the property name editor
  Widget _buildPropertyNameEditor({
    required String key,
    required String editingName,
    required AppColorScheme colorScheme,
    required WidgetRef ref,
  }) {
    return _PropertyNameEditorWidget(
      key: ValueKey('property_name_editor_$key'),
      propertyKey: key,
      editingName: editingName,
      colorScheme: colorScheme,
      onFinish: (newName) {
        _finishEditingPropertyName(key, newName, ref);
      },
    );
  }

  /// Finishes editing the property name
  void _finishEditingPropertyName(
    String oldKey,
    String newName,
    WidgetRef ref,
  ) {
    print('[PropertyNameEdit] ===== Property name editing finished =====');
    print('[PropertyNameEdit] Old key: $oldKey');
    print('[PropertyNameEdit] New name: $newName');

    final trimmedName = newName.trim();

    if (trimmedName.isEmpty || trimmedName == oldKey) {
      // If there are no changes, finish editing
      print('[PropertyNameEdit] No changes, finishing editing');
      ref.read(editingPropertyNamesProvider.notifier).stopEditing(oldKey);
      return;
    }

    // Record property name change
    print(
      '[PropertyNameEdit] Recording property name change: $oldKey -> $trimmedName',
    );
    ref
        .read(editingPropertyNameChangesProvider.notifier)
        .renameProperty(oldKey, trimmedName);

    // Update property value being edited (change key)
    final editingProperties = ref.read(editingEntityPropertiesProvider);
    print(
      '[PropertyNameEdit] Current properties being edited: $editingProperties',
    );
    final value = editingProperties[oldKey];
    print('[PropertyNameEdit] Value of old key: $value');

    if (value != null) {
      print(
        '[PropertyNameEdit] Updating property with new key: $trimmedName = $value',
      );
      ref
          .read(editingEntityPropertiesProvider.notifier)
          .updateProperty(trimmedName, value);

      // Delete old key
      final newProperties = Map<String, dynamic>.from(editingProperties);
      newProperties.remove(oldKey);
      print('[PropertyNameEdit] Deleting old key: $oldKey');
      print('[PropertyNameEdit] Updated properties: $newProperties');
      ref
          .read(editingEntityPropertiesProvider.notifier)
          .setProperties(newProperties);
    } else {
      print('[PropertyNameEdit] Warning: Value for old key not found');
    }

    // Finish editing
    print('[PropertyNameEdit] Finishing editing');
    ref.read(editingPropertyNamesProvider.notifier).stopEditing(oldKey);
    print('[PropertyNameEdit] ===== Editing finished =====');
  }

  /// Saves properties
  Future<void> _saveProperties(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(saveEntityActionProvider.notifier).saveEntity();
      // After successful save, reset editing state (already reset by SaveEntityAction)
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Properties saved')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
  }

  /// Cancels editing
  void _cancelEditing(WidgetRef ref) {
    ref.read(editingEntityPropertiesProvider.notifier).reset();
    ref.read(editingPropertyNameChangesProvider.notifier).reset();
    ref.read(editingPropertyNamesProvider.notifier).reset();
  }

  /// Formats the value
  String _formatValue(dynamic value) {
    if (value == null) {
      return 'null';
    }
    if (value is List) {
      return '[${value.join(', ')}]';
    }
    if (value is Map) {
      return '{...}';
    }
    return value.toString();
  }
}

/// Property name editor widget
class _PropertyNameEditorWidget extends StatefulWidget {
  const _PropertyNameEditorWidget({
    super.key,
    required this.propertyKey,
    required this.editingName,
    required this.colorScheme,
    required this.onFinish,
  });

  final String propertyKey;
  final String editingName;
  final AppColorScheme colorScheme;
  final ValueChanged<String> onFinish;

  @override
  State<_PropertyNameEditorWidget> createState() =>
      _PropertyNameEditorWidgetState();
}

class _PropertyNameEditorWidgetState extends State<_PropertyNameEditorWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    print('[PropertyNameEditor] initState: ${widget.propertyKey}');
    _controller = TextEditingController(text: widget.editingName);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    print('[PropertyNameEditor] dispose: ${widget.propertyKey}');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[PropertyNameEditor] build: ${widget.propertyKey}');
    return Focus(
      focusNode: _focusNode,
      onFocusChange: (hasFocus) {
        print(
          '[PropertyNameEditor] onFocusChange: ${widget.propertyKey}, hasFocus=$hasFocus',
        );
        if (!hasFocus) {
          print(
            '[PropertyNameEditor] Focus lost: ${widget.propertyKey}, text=${_controller.text}',
          );
          widget.onFinish(_controller.text);
        }
      },
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: (newName) {
          print(
            '[PropertyNameEditor] Enter pressed: ${widget.propertyKey}, newName=$newName',
          );
          widget.onFinish(newName);
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: widget.colorScheme.base.divider,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: widget.colorScheme.base.selection,
              width: 1.5,
            ),
          ),
        ),
        style: TextStyle(
          color: widget.colorScheme.base.foreground,
          fontSize: 12.0,
        ),
        autofocus: true,
      ),
    );
  }
}
