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
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:presentation_components/presentation_components.dart';

/// Improved label editor
class ImprovedLabelEditor extends ConsumerWidget {
  /// Constructor
  const ImprovedLabelEditor({
    required this.label,
    required this.isEditMode,
    super.key,
  });

  /// Label to be edited
  final LabelMetadata label;

  /// Edit mode
  final bool isEditMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement edit mode and label actions providers
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(
            context,
            theme: theme,
            isEditMode: isEditMode,
            onEdit: () {
              // TODO: Implement edit mode with proper provider
            },
            onCancel: () {
              // TODO: Implement cancel edit with proper provider
            },
            onSave: () {
              // TODO: Implement save with proper provider
            },
            onDelete:
                () => _showDeleteDialog(context, (labelName) {
                  // TODO: Implement delete with proper provider
                }),
          ),

          const SizedBox(height: 24),

          // Edit form
          Expanded(
            child: SingleChildScrollView(child: _buildEditForm(context, theme)),
          ),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildHeader(
    BuildContext context, {
    required ThemeData theme,
    required bool isEditMode,
    required VoidCallback onEdit,
    required VoidCallback onCancel,
    required VoidCallback onSave,
    required VoidCallback onDelete,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Label Details', style: theme.textTheme.headlineSmall),

        // 削除ボタンのみ
        IconButton(
          onPressed: onDelete,
          icon: const Icon(LucideIcons.trash2),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  /// Builds the edit form
  Widget _buildEditForm(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic information section
        _buildSection(
          title: '基本情報',
          child: Column(
            children: [
              // Label name
              _buildFormRow(
                label: 'ラベル名',
                child: AppTextField(
                  controller: TextEditingController(text: label.name),
                  onChanged: (value) {
                    // TODO: Value update processing
                  },
                  enabled: false,
                  hintText: 'Enter label name',
                ),
              ),

              const SizedBox(height: 16),

              // Description
              _buildFormRow(
                label: '説明',
                child: AppTextField(
                  controller: TextEditingController(
                    text: label.description ?? '',
                  ),
                  onChanged: (value) {
                    // TODO: Value update processing
                  },
                  enabled: false,
                  hintText: 'Enter label description',
                  maxLines: 3,
                ),
              ),
            ],
          ),
          theme: theme,
        ),

        const SizedBox(height: 24),

        // Statistics section
        _buildSection(
          title: '統計情報',
          child: _buildStatistics(theme),
          theme: theme,
        ),
      ],
    );
  }

  /// Builds a section
  Widget _buildSection({
    required String title,
    required Widget child,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /// Builds a form row (2-column layout)
  Widget _buildFormRow({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item name (1st row)
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 6),

        // Value (2nd row)
        child,
      ],
    );
  }

  /// Builds statistics information
  Widget _buildStatistics(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Expanded(
              child: Text(
                'Node Count',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Link Count',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // Value row
        Row(
          children: [
            Expanded(
              child: Text(
                '5', // TODO: Actual number
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '3', // TODO: Actual number
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Displays the delete confirmation dialog
  void _showDeleteDialog(BuildContext context, void Function(String) onDelete) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Label'),
            content: Text(
              'Are you sure you want to delete "${label.name}"?\nThis operation cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete(label.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
