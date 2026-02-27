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
import '../models/advanced_search_models.dart';

class AdvancedPropertyFilterPanel extends ConsumerWidget {
  final String nodeId;
  final Map<String, PropertyFilter> filters;
  final ValueChanged<Map<String, PropertyFilter>> onFiltersChanged;

  const AdvancedPropertyFilterPanel({
    super.key,
    required this.nodeId,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColorScheme.uiAreas.sideBar.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 20,
                  color: appColorScheme.uiAreas.sideBar.activeItemText,
                ),
                const SizedBox(width: 8),
                AppText(
                  'Property Filter',
                  variant: AppTextVariant.itemTitle,
                  color: appColorScheme.uiAreas.sideBar.activeItemText,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 18,
                    color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                  ),
                  onPressed: () => _showAddFilterDialog(context, ref),
                  tooltip: 'Add filter',
                ),
              ],
            ),
          ),

          // Filter list
          if (filters.isEmpty)
            _buildEmptyState(context, ref)
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final entry = filters.entries.elementAt(index);
                  return _buildFilterTile(context, ref, entry.key, entry.value);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list,
            size: 48,
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText(
            'No filters',
            variant: AppTextVariant.bodyText,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          AppText(
            'Add filter with + button',
            variant: AppTextVariant.captionText,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTile(
    BuildContext context,
    WidgetRef ref,
    String filterId,
    PropertyFilter filter,
  ) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter header
            Row(
              children: [
                Switch(
                  value: filter.isActive,
                  onChanged:
                      (value) => _updateFilter(
                        filterId,
                        filter.copyWith(isActive: value),
                      ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Icon(
                  _getPropertyTypeIcon(filter.propertyType),
                  size: 16,
                  color:
                      filter.isActive
                          ? colorScheme.primary
                          : colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    filter.property,
                    variant: AppTextVariant.bodyText,
                    color:
                        filter.isActive
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: AppText(
                            'Edit',
                            variant: AppTextVariant.bodyText,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: AppText(
                            'Duplicate',
                            variant: AppTextVariant.bodyText,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: AppText(
                            'Delete',
                            variant: AppTextVariant.bodyText,
                          ),
                        ),
                      ],
                  onSelected:
                      (action) => _handleFilterAction(
                        context,
                        ref,
                        filterId,
                        filter,
                        action,
                      ),
                ),
              ],
            ),

            if (filter.isActive) ...[
              const SizedBox(height: 12),
              // Operator and value configuration
              _buildFilterCondition(context, ref, filterId, filter),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCondition(
    BuildContext context,
    WidgetRef ref,
    String filterId,
    PropertyFilter filter,
  ) {
    final colorScheme = ref.watch(effectiveFlutterColorSchemeProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Operator selection
          Row(
            children: [
              const SizedBox(
                width: 80,
                child: AppText(
                  'Operator:',
                  variant: AppTextVariant.captionText,
                ),
              ),
              Expanded(
                child: AppDropdownMenu<FilterOperator>(
                  initialSelection: filter.operator,
                  onSelected: (operator) {
                    if (operator != null) {
                      _updateFilter(
                        filterId,
                        filter.copyWith(operator: operator),
                      );
                    }
                  },
                  dropdownMenuEntries:
                      FilterOperator.values
                          .where(
                            (op) => _isOperatorValidForType(
                              op,
                              filter.propertyType,
                            ),
                          )
                          .map(
                            (op) => DropdownMenuEntry<FilterOperator>(
                              value: op,
                              label: _getOperatorDisplayName(op),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Value input
          if (_operatorRequiresValue(filter.operator))
            _buildValueInput(context, ref, filterId, filter),
        ],
      ),
    );
  }

  Widget _buildValueInput(
    BuildContext context,
    WidgetRef ref,
    String filterId,
    PropertyFilter filter,
  ) {
    switch (filter.propertyType) {
      case PropertyType.string:
        return _buildStringInput(filterId, filter);
      case PropertyType.number:
        return _buildNumberInput(filterId, filter);
      case PropertyType.boolean:
        return _buildBooleanInput(filterId, filter);
      case PropertyType.date:
        return _buildDateInput(context, filterId, filter);
      case PropertyType.array:
        return _buildArrayInput(filterId, filter);
      case PropertyType.object:
        return _buildObjectInput(filterId, filter);
    }
  }

  Widget _buildStringInput(String filterId, PropertyFilter filter) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Value',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      controller: TextEditingController(text: filter.value?.toString() ?? ''),
      onChanged:
          (value) => _updateFilter(filterId, filter.copyWith(value: value)),
    );
  }

  Widget _buildNumberInput(String filterId, PropertyFilter filter) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Number',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(text: filter.value?.toString() ?? ''),
      onChanged: (value) {
        final numValue = double.tryParse(value);
        _updateFilter(filterId, filter.copyWith(value: numValue));
      },
    );
  }

  Widget _buildBooleanInput(String filterId, PropertyFilter filter) {
    return Row(
      children: [
        const AppText('Value:', variant: AppTextVariant.captionText),
        const SizedBox(width: 12),
        Switch(
          value: filter.value == true,
          onChanged:
              (value) => _updateFilter(filterId, filter.copyWith(value: value)),
        ),
        const SizedBox(width: 8),
        AppText(
          filter.value == true ? 'true' : 'false',
          variant: AppTextVariant.bodyText,
        ),
      ],
    );
  }

  Widget _buildDateInput(
    BuildContext context,
    String filterId,
    PropertyFilter filter,
  ) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: filter.value is DateTime ? filter.value : DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          _updateFilter(filterId, filter.copyWith(value: selectedDate));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            AppText(
              filter.value is DateTime
                  ? _formatDate(filter.value)
                  : 'Select date',
              variant: AppTextVariant.bodyText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrayInput(String filterId, PropertyFilter filter) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Array values (comma-separated)',
        border: OutlineInputBorder(),
        isDense: true,
        hintText: 'value1, value2, value3',
      ),
      controller: TextEditingController(
        text:
            filter.value is List
                ? (filter.value as List).join(', ')
                : filter.value?.toString() ?? '',
      ),
      onChanged: (value) {
        final arrayValue = value.split(',').map((s) => s.trim()).toList();
        _updateFilter(filterId, filter.copyWith(value: arrayValue));
      },
    );
  }

  Widget _buildObjectInput(String filterId, PropertyFilter filter) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'JSON value',
        border: OutlineInputBorder(),
        isDense: true,
        hintText: '{"key": "value"}',
      ),
      maxLines: 3,
      controller: TextEditingController(text: filter.value?.toString() ?? ''),
      onChanged:
          (value) => _updateFilter(filterId, filter.copyWith(value: value)),
    );
  }

  void _updateFilter(String filterId, PropertyFilter updatedFilter) {
    final newFilters = Map<String, PropertyFilter>.from(filters);
    newFilters[filterId] = updatedFilter;
    onFiltersChanged(newFilters);
  }

  void _showAddFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AddFilterDialog(
            onFilterAdded: (filter) {
              final newFilters = Map<String, PropertyFilter>.from(filters);
              final filterId =
                  'filter_${DateTime.now().millisecondsSinceEpoch}';
              newFilters[filterId] = filter;
              onFiltersChanged(newFilters);
            },
          ),
    );
  }

  void _handleFilterAction(
    BuildContext context,
    WidgetRef ref,
    String filterId,
    PropertyFilter filter,
    String action,
  ) {
    switch (action) {
      case 'edit':
        _showEditFilterDialog(context, filterId, filter);
        break;
      case 'duplicate':
        _duplicateFilter(filterId, filter);
        break;
      case 'delete':
        _deleteFilter(filterId);
        break;
    }
  }

  void _showEditFilterDialog(
    BuildContext context,
    String filterId,
    PropertyFilter filter,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => EditFilterDialog(
            filter: filter,
            onFilterUpdated:
                (updatedFilter) => _updateFilter(filterId, updatedFilter),
          ),
    );
  }

  void _duplicateFilter(String filterId, PropertyFilter filter) {
    final newFilters = Map<String, PropertyFilter>.from(filters);
    final newFilterId = 'filter_${DateTime.now().millisecondsSinceEpoch}';
    newFilters[newFilterId] = filter.copyWith(
      property: '${filter.property}_copy',
    );
    onFiltersChanged(newFilters);
  }

  void _deleteFilter(String filterId) {
    final newFilters = Map<String, PropertyFilter>.from(filters);
    newFilters.remove(filterId);
    onFiltersChanged(newFilters);
  }

  IconData _getPropertyTypeIcon(PropertyType type) {
    switch (type) {
      case PropertyType.string:
        return Icons.text_fields;
      case PropertyType.number:
        return Icons.tag;
      case PropertyType.boolean:
        return Icons.toggle_off;
      case PropertyType.date:
        return Icons.calendar_today;
      case PropertyType.array:
        return Icons.list;
      case PropertyType.object:
        return Icons.code;
    }
  }

  String _getOperatorDisplayName(FilterOperator operator) {
    switch (operator) {
      case FilterOperator.equals:
        return 'Equals';
      case FilterOperator.notEquals:
        return 'Not Equals';
      case FilterOperator.contains:
        return 'Contains';
      case FilterOperator.notContains:
        return 'Not Contains';
      case FilterOperator.startsWith:
        return 'Starts With';
      case FilterOperator.endsWith:
        return 'Ends With';
      case FilterOperator.greaterThan:
        return 'Greater Than';
      case FilterOperator.lessThan:
        return 'Less Than';
      case FilterOperator.greaterOrEqual:
        return 'Greater Or Equal';
      case FilterOperator.lessOrEqual:
        return 'Less Or Equal';
      case FilterOperator.between:
        return 'Between';
      case FilterOperator.regex:
        return 'Regex';
      case FilterOperator.in_:
        return 'In';
      case FilterOperator.notIn:
        return 'Not In';
      case FilterOperator.exists:
        return 'Exists';
      case FilterOperator.notExists:
        return 'Not Exists';
    }
  }

  bool _isOperatorValidForType(FilterOperator operator, PropertyType type) {
    switch (type) {
      case PropertyType.string:
        return true; // すべての演算子が使用可能
      case PropertyType.number:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.greaterThan,
          FilterOperator.lessThan,
          FilterOperator.greaterOrEqual,
          FilterOperator.lessOrEqual,
          FilterOperator.between,
          FilterOperator.exists,
          FilterOperator.notExists,
        ].contains(operator);
      case PropertyType.boolean:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.exists,
          FilterOperator.notExists,
        ].contains(operator);
      case PropertyType.date:
        return [
          FilterOperator.equals,
          FilterOperator.notEquals,
          FilterOperator.greaterThan,
          FilterOperator.lessThan,
          FilterOperator.greaterOrEqual,
          FilterOperator.lessOrEqual,
          FilterOperator.between,
          FilterOperator.exists,
          FilterOperator.notExists,
        ].contains(operator);
      case PropertyType.array:
        return [
          FilterOperator.contains,
          FilterOperator.notContains,
          FilterOperator.in_,
          FilterOperator.notIn,
          FilterOperator.exists,
          FilterOperator.notExists,
        ].contains(operator);
      case PropertyType.object:
        return [
          FilterOperator.exists,
          FilterOperator.notExists,
          FilterOperator.contains,
          FilterOperator.notContains,
        ].contains(operator);
    }
  }

  bool _operatorRequiresValue(FilterOperator operator) {
    return ![
      FilterOperator.exists,
      FilterOperator.notExists,
    ].contains(operator);
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

// フィルタ追加ダイアログ
class AddFilterDialog extends StatefulWidget {
  final ValueChanged<PropertyFilter> onFilterAdded;

  const AddFilterDialog({super.key, required this.onFilterAdded});

  @override
  State<AddFilterDialog> createState() => _AddFilterDialogState();
}

class _AddFilterDialogState extends State<AddFilterDialog> {
  String _property = '';
  PropertyType _propertyType = PropertyType.string;
  FilterOperator _operator = FilterOperator.equals;
  dynamic _value;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const AppText('Add Filter', variant: AppTextVariant.itemTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Property name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _property = value),
            ),
            const SizedBox(height: 16),
            AppDropdownMenu<PropertyType>(
              initialSelection: _propertyType,
              onSelected: (type) {
                if (type != null) {
                  setState(() {
                    _propertyType = type;
                    // Reset to appropriate operator when property type changes
                    _operator = FilterOperator.equals;
                  });
                }
              },
              dropdownMenuEntries:
                  PropertyType.values.map((type) {
                    return DropdownMenuEntry<PropertyType>(
                      value: type,
                      label: _getPropertyTypeDisplayName(type),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const AppText('Cancel', variant: AppTextVariant.bodyText),
        ),
        ElevatedButton(
          onPressed:
              _property.isNotEmpty
                  ? () {
                    final filter = PropertyFilter(
                      property: _property,
                      operator: _operator,
                      value: _value,
                      propertyType: _propertyType,
                    );
                    widget.onFilterAdded(filter);
                    Navigator.pop(context);
                  }
                  : null,
          child: const AppText('Add', variant: AppTextVariant.bodyText),
        ),
      ],
    );
  }

  String _getPropertyTypeDisplayName(PropertyType type) {
    switch (type) {
      case PropertyType.string:
        return 'String';
      case PropertyType.number:
        return 'Number';
      case PropertyType.boolean:
        return 'Boolean';
      case PropertyType.date:
        return 'Date';
      case PropertyType.array:
        return 'Array';
      case PropertyType.object:
        return 'Object';
    }
  }
}

// Filter edit dialog
class EditFilterDialog extends StatefulWidget {
  final PropertyFilter filter;
  final ValueChanged<PropertyFilter> onFilterUpdated;

  const EditFilterDialog({
    super.key,
    required this.filter,
    required this.onFilterUpdated,
  });

  @override
  State<EditFilterDialog> createState() => _EditFilterDialogState();
}

class _EditFilterDialogState extends State<EditFilterDialog> {
  late String _property;
  late PropertyType _propertyType;
  // TODO: Implement filter operator and value functionality
  // late FilterOperator _operator;
  // late dynamic _value;

  @override
  void initState() {
    super.initState();
    _property = widget.filter.property;
    _propertyType = widget.filter.propertyType;
    // TODO: Initialize operator and value when implemented
    // _operator = widget.filter.operator;
    // _value = widget.filter.value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const AppText('Edit Filter', variant: AppTextVariant.itemTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Property name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: _property),
              onChanged: (value) => setState(() => _property = value),
            ),
            const SizedBox(height: 16),
            // Property type cannot be changed during edit
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const AppText('Type: ', variant: AppTextVariant.bodyText),
                  AppText(
                    _getPropertyTypeDisplayName(_propertyType),
                    variant: AppTextVariant.bodyText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const AppText('Cancel', variant: AppTextVariant.bodyText),
        ),
        ElevatedButton(
          onPressed:
              _property.isNotEmpty
                  ? () {
                    final updatedFilter = widget.filter.copyWith(
                      property: _property,
                    );
                    widget.onFilterUpdated(updatedFilter);
                    Navigator.pop(context);
                  }
                  : null,
          child: const AppText('Update', variant: AppTextVariant.bodyText),
        ),
      ],
    );
  }

  String _getPropertyTypeDisplayName(PropertyType type) {
    switch (type) {
      case PropertyType.string:
        return 'String';
      case PropertyType.number:
        return 'Number';
      case PropertyType.boolean:
        return 'Boolean';
      case PropertyType.date:
        return 'Date';
      case PropertyType.array:
        return 'Array';
      case PropertyType.object:
        return 'Object';
    }
  }
}
