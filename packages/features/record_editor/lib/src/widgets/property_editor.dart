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

import 'custom_reorderable_list.dart';

/// Property editor component
class PropertyEditor extends ConsumerStatefulWidget {
  /// Constructor
  const PropertyEditor({
    required this.propertyName,
    required this.propertyType,
    required this.value,
    required this.isLocked,
    required this.onRemove,
    required this.onUpdate,
    required this.index,
    super.key,
  });

  /// Property name
  final String propertyName;

  /// Property type
  final PropertyType? propertyType;

  /// Property value
  final dynamic value;

  /// Edit lock state
  final bool isLocked;

  /// Callback when property is removed
  final VoidCallback onRemove;

  /// Callback when property is updated
  final ValueChanged<dynamic> onUpdate;

  /// Index in list
  final int index;

  @override
  ConsumerState<PropertyEditor> createState() => _PropertyEditorState();
}

class _PropertyEditorState extends ConsumerState<PropertyEditor> {
  bool _isEditing = false;
  late dynamic _editValue;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _editValue = widget.value;
  }

  @override
  void didUpdateWidget(PropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _editValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine if dragging (get from parent widget)
    final isDragging = _isDraggingInProgress(context);

    // Get display name for property type
    // TODO: Integration with global property type definition (after Riverpod generation file creation)
    final String typeDisplayName = _getDisplayNameForPropertyType(
      widget.propertyType,
    );

    // Drag handle widget
    final dragHandleWidget =
        _isHovered && !isDragging
            ? Icon(
              AppIcons.gripVertical,
              size: 16,
              color:
                  widget.isLocked
                      ? colorScheme.onSurface.withValues(
                        alpha: 77,
                      ) // 0.3 equivalent
                      : colorScheme.onSurfaceVariant,
            )
            : const SizedBox(
              width: 16,
              height: 16,
            ); // Reserve same space when hidden

    return MouseRegion(
      // Disable hover effect while dragging
      onEnter: isDragging ? null : (_) => setState(() => _isHovered = true),
      onExit: isDragging ? null : (_) => setState(() => _isHovered = false),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ReorderableDragStartListener(
          index: widget.index, // Index passed from ReorderableListView.builder
          child: AppContainer(
            leadingWidget: dragHandleWidget,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property name
                Row(
                  children: [
                    // Type icon removed
                    // Disable tooltip while dragging
                    isDragging
                        ? AppText(
                          widget.propertyName,
                          variant: AppTextVariant.bodyText,
                        )
                        : Tooltip(
                          message: typeDisplayName,
                          child: AppText(
                            widget.propertyName,
                            variant: AppTextVariant.bodyText,
                          ),
                        ),
                    if (widget.propertyType?.isRequired == true) ...[
                      const SizedBox(width: 4),
                      AppText(
                        '*',
                        variant: AppTextVariant.captionText,
                        color: colorScheme.error,
                      ),
                    ],
                    const Spacer(),
                    // Delete button
                    if (!widget.isLocked)
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip:
                            isDragging
                                ? null
                                : 'Delete', // Disable tooltip while dragging
                        onPressed: widget.onRemove,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Property value editor
                if (_isEditing)
                  _buildPropertyEditor(
                    context,
                    value: _editValue,
                    onChanged: (value) => setState(() => _editValue = value),
                    onSave: () {
                      widget.onUpdate(_editValue);
                      setState(() => _isEditing = false);
                    },
                    onCancel: () {
                      setState(() {
                        _editValue = widget.value;
                        _isEditing = false;
                      });
                    },
                  )
                else
                  GestureDetector(
                    onTap:
                        widget.isLocked
                            ? null
                            : () => setState(() => _isEditing = true),
                    child: AppTextField(
                      readOnly: true,
                      enabled:
                          true, // Set enabled to true to make text color normal
                      controller: TextEditingController(
                        text: _getDisplayTextForValue(widget.value),
                      ),
                      style:
                          theme
                              .textTheme
                              .bodyMedium, // Explicitly specify text style
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Get display text for property value
  String _getDisplayTextForValue(dynamic value) {
    if (value == null) {
      return '(None)';
    }

    if (widget.propertyType is BooleanPropertyType) {
      return value == true ? 'Yes' : 'No';
    }

    if (widget.propertyType is DatePropertyType && value is DateTime) {
      return '${value.year}/${value.month}/${value.day}';
    }

    return value.toString();
  }

  /// Get appropriate display name based on property type
  String _getDisplayNameForPropertyType(PropertyType? type) {
    if (type == null) return 'Unknown type';

    if (type is TextPropertyType) {
      return 'Text';
    } else if (type is IntegerPropertyType) {
      return 'Integer';
    } else if (type is BooleanPropertyType) {
      return 'Boolean';
    } else if (type is DatePropertyType) {
      return 'Date';
    } else if (type is EmailPropertyType) {
      return 'Email address';
    } else {
      return 'Unknown type';
    }
  }

  /// Determine if dragging from parent widget
  bool _isDraggingInProgress(BuildContext context) {
    // Use static method of CustomReorderableList
    return CustomReorderableList.isDragging(context);
  }

  // Property value display (deprecated - use _getDisplayTextForValue)
  // Deleted because unused
  // Widget _buildPropertyValueDisplay(BuildContext context, dynamic value) {
  //   final theme = Theme.of(context);
  //   final colorScheme = theme.colorScheme;
  //
  //   if (value == null) {
  //     return Text(
  //       '(None)',
  //       style: theme.textTheme.bodyMedium?.copyWith(
  //         color: colorScheme.onSurfaceVariant.withValues(alpha: 179), // 0.7 equivalent
  //         fontStyle: FontStyle.italic,
  //       ),
  //     );
  //   }
  //
  //   if (propertyType is BooleanPropertyType) {
  //     return Row(
  //       children: [
  //         Icon(
  //           value == true ? Icons.check_box : Icons.check_box_outline_blank,
  //           size: 18,
  //           color: value == true ? colorScheme.primary : null,
  //         ),
  //         const SizedBox(width: 8),
  //         Text(value == true ? 'Yes' : 'No', style: theme.textTheme.bodyMedium),
  //       ],
  //     );
  //   }
  //
  //   if (propertyType is DatePropertyType && value is DateTime) {
  //     return Text(
  //       '${value.year}/${value.month}/${value.day}',
  //       style: theme.textTheme.bodyMedium,
  //     );
  //   }
  //
  //   return Text(value.toString(), style: theme.textTheme.bodyMedium);
  // }

  // Property value editor
  Widget _buildPropertyEditor(
    BuildContext context, {
    required dynamic value,
    required ValueChanged<dynamic> onChanged,
    required VoidCallback onSave,
    required VoidCallback onCancel,
  }) {
    final theme = Theme.of(context);

    // Display editor based on property type
    Widget editor;

    if (widget.propertyType is BooleanPropertyType) {
      // Boolean type
      editor = Row(
        children: [
          AppCheckbox(
            value: value == true,
            onChanged: (newValue) {
              onChanged(newValue);
              onSave();
            },
          ),
          const SizedBox(width: 8),
          AppText(
            value == true ? 'Yes' : 'No',
            variant: AppTextVariant.bodyText,
          ),
        ],
      );
    } else if (widget.propertyType is DatePropertyType) {
      // Date type
      final dateValue = value is DateTime ? value : DateTime.now();
      editor = Row(
        children: [
          Text(
            '${dateValue.year}/${dateValue.month}/${dateValue.day}',
            style: theme.textTheme.bodyMedium,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 18),
            onPressed: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: dateValue,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (newDate != null) {
                onChanged(newDate);
                onSave();
              }
            },
          ),
        ],
      );
    } else if (widget.propertyType is IntegerPropertyType) {
      // Integer type
      editor = Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            onSave();
          }
        },
        child: AppTextField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: value?.toString() ?? ''),
          onChanged: (text) {
            final intValue = int.tryParse(text);
            if (intValue != null) {
              onChanged(intValue);
            }
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      );
    } else if (widget.propertyType is TextPropertyType) {
      // Text type
      // Long text is displayed on multiple lines
      final isLongText = value != null && value.toString().length > 50;
      editor = Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            onSave();
          }
        },
        child: AppTextField(
          controller: TextEditingController(text: value?.toString() ?? ''),
          onChanged: onChanged,
          maxLines: isLongText ? 5 : 1,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      );
    } else if (widget.propertyType is EmailPropertyType) {
      // Email address type
      editor = Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            onSave();
          }
        },
        child: AppTextField(
          controller: TextEditingController(text: value?.toString() ?? ''),
          onChanged: onChanged,
          keyboardType: TextInputType.emailAddress,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      );
    } else {
      // Other types
      editor = Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            onSave();
          }
        },
        child: AppTextField(
          controller: TextEditingController(text: value?.toString() ?? ''),
          onChanged: onChanged,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      );
    }

    return editor;
  }
}
