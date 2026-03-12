/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

import '../providers/label_list_providers.dart';
import '../models/label_item.dart';

/// Secondary sidebar for label editing.
class LabelEditorSidebar extends ConsumerStatefulWidget {
  const LabelEditorSidebar({super.key});

  @override
  ConsumerState<LabelEditorSidebar> createState() => _LabelEditorSidebarState();
}

class _LabelEditorSidebarState extends ConsumerState<LabelEditorSidebar> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = ref.watch(selectedLabelForEditProvider);

    // Update form when selected label changes
    if (selectedLabel != null) {
      _updateFormFromLabel(selectedLabel);
    }

    if (selectedLabel == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Edit form
        Expanded(
          child: FondeScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name (display only)
                  _buildDisplayField(label: '名前', value: _nameController.text),

                  const SizedBox(height: 24),

                  // Statistics
                  _buildStatistics(selectedLabel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, variant: AppTextVariant.captionText),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: AppText(value, variant: AppTextVariant.bodyText),
        ),
      ],
    );
  }

  Widget _buildStatistics(LabelItem label) {
    return FondeContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Statistics', variant: AppTextVariant.captionText),
          const SizedBox(height: 8),
          _buildStatItem('Usage Count', '${label.usageCount}'),
          _buildStatItem('Created', _formatDate(label.createdAt)),
          _buildStatItem('Last Modified', _formatDate(label.modifiedAt)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(label, variant: AppTextVariant.bodyText),
          AppText(value, variant: AppTextVariant.bodyText),
        ],
      ),
    );
  }

  void _updateFormFromLabel(LabelItem label) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nameController.text = label.name;
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
