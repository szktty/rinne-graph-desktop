import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

import '../providers/label_list_providers.dart';
import '../models/label_item.dart';

/// Table view for the label list.
class LabelTableView extends ConsumerWidget {
  const LabelTableView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(filteredAndSortedLabelsProvider);
    final selectedLabel = ref.watch(selectedLabelForEditProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    if (labels.isEmpty) {
      return _buildEmptyState(appColorScheme);
    }

    // Prepare data for the table
    final tableData =
        labels
            .map(
              (label) => _LabelTableRow(
                label: label,
                isSelected: selectedLabel?.id == label.id,
              ),
            )
            .toList();

    return Container(
      color: appColorScheme.base.background,
      child: AppTableView<_LabelTableRow>(
        data: tableData,
        keyExtractor: (row) => row.label.id,
        columns: [
          // Tag column (name + color)
          AppTableColumn<_LabelTableRow>(
            id: 'tag',
            title: 'Name',
            width: 500, // より大きな幅を設定してエリア横幅いっぱいに
            cellBuilder:
                (row, isSelected) => Align(
                  alignment: Alignment.centerLeft,
                  child: TagView(
                    label: row.label.name,
                    color: row.label.color,
                    isSelected: isSelected,
                  ),
                ),
          ),
          // Usage count column
          AppTableColumn<_LabelTableRow>(
            id: 'usageCount',
            title: 'Usage Count',
            width: 100,
            cellBuilder:
                (row, isSelected) => Align(
                  alignment: Alignment.centerRight,
                  child: AppText(
                    '${row.label.usageCount}',
                    variant: AppTextVariant.bodyText,
                  ),
                ),
          ),
        ],
        onRowsSelected: (rows) {
          if (rows.isNotEmpty) {
            ref.read(selectedLabelForEditProvider.notifier).state =
                rows.first.label;
          } else {
            ref.read(selectedLabelForEditProvider.notifier).state = null;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            AppIcons.tag,
            size: AppIconSize.xlarge,
            customColor: colorScheme.base.foreground.withAlpha(128),
          ),
          const SizedBox(height: 16),
          AppText(
            'No labels found',
            variant: AppTextVariant.itemTitle,
            color: colorScheme.base.foreground.withAlpha(128),
          ),
          const SizedBox(height: 8),
          AppText(
            'Change search criteria or add a new label',
            variant: AppTextVariant.bodyText,
            color: colorScheme.base.foreground.withAlpha(128),
          ),
        ],
      ),
    );
  }
}

/// Data class for a table row.
class _LabelTableRow {
  const _LabelTableRow({required this.label, required this.isSelected});

  final LabelItem label;
  final bool isSelected;
}
