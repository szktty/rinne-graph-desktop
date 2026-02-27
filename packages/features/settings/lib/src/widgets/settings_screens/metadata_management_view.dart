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

/// Metadata Management Settings Screen
class MetadataManagementView extends ConsumerStatefulWidget {
  const MetadataManagementView({super.key});

  @override
  ConsumerState<MetadataManagementView> createState() =>
      _MetadataManagementViewState();
}

class _MetadataManagementViewState
    extends ConsumerState<MetadataManagementView> {
  int _selectedSegment = 0; // 0: Label, 1: Property Type

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(24.0),
      borderSide: BorderSide.none,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Metadata Management',
            variant: AppTextVariant.pageTitleSmall,
            color: appColorScheme.base.foreground,
          ),
          const SizedBox(height: 8),
          const AppText(
            'Manage settings for labels and property types.',
            variant: AppTextVariant.captionText,
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segment Button
          AppSegmentedButton<int>(
            segments: const [
              ButtonSegment<int>(value: 0, label: Text('Labels')),
              ButtonSegment<int>(value: 1, label: Text('Property Types')),
            ],
            selected: {_selectedSegment},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _selectedSegment = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 24),

          // Content Area
          Expanded(
            child:
                _selectedSegment == 0
                    ? _buildLabelManagement()
                    : _buildPropertyTypeManagement(),
          ),
        ],
      ),
    );
  }

  /// Label Management UI
  Widget _buildLabelManagement() {
    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Label Management',
            variant: AppTextVariant.sectionTitlePrimary,
          ),
          const SizedBox(height: 16),
          const AppText(
            'Manage labels assigned to entities.',
            variant: AppTextVariant.bodyText,
          ),
          const SizedBox(height: 24),

          // Mock Label List
          _buildLabelList(),
        ],
      ),
    );
  }

  /// Property Type Management UI
  Widget _buildPropertyTypeManagement() {
    return AppContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Property Type Management',
            variant: AppTextVariant.sectionTitlePrimary,
          ),
          const SizedBox(height: 16),
          const AppText(
            'Manage property types for entities.',
            variant: AppTextVariant.bodyText,
          ),
          const SizedBox(height: 24),

          // Property Type Management UI
          _buildPropertyTypeList(),
        ],
      ),
    );
  }

  /// Label List (Mock)
  Widget _buildLabelList() {
    final mockLabels = [
      'person',
      'organization',
      'project',
      'document',
      'meeting',
      'task',
    ];

    return Column(
      children: [
        // Header
        Row(
          children: [
            const Expanded(
              child: AppText('Label Name', variant: AppTextVariant.captionText),
            ),
            const SizedBox(
              width: 100,
              child: AppText('Actions', variant: AppTextVariant.captionText),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const AppDivider(),
        const SizedBox(height: 8),

        // Label List
        ...mockLabels.map(
          (label) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: AppText(label, variant: AppTextVariant.bodyText),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      AppIconButton(
                        icon: AppIcons.edit,
                        onPressed: () {
                          // Edit action
                        },
                      ),
                      const SizedBox(width: 8),
                      AppIconButton(
                        icon: AppIcons.x,
                        onPressed: () {
                          // Delete action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Add Button
        Row(
          children: [
            AppButton.primary(
              label: 'Add Label',
              onPressed: () {
                // Add action
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Property Type List
  Widget _buildPropertyTypeList() {
    final mockPropertyTypes = [
      ('name', 'text', 'Name'),
      ('description', 'text', 'Description'),
      ('created_at', 'date', 'Created At'),
      ('is_active', 'boolean', 'Active'),
    ];

    return Column(
      children: [
        // Header
        Row(
          children: [
            const Expanded(
              flex: 2,
              child: AppText(
                'Property Name',
                variant: AppTextVariant.captionText,
              ),
            ),
            const Expanded(
              child: AppText('Type', variant: AppTextVariant.captionText),
            ),
            const Expanded(
              flex: 2,
              child: AppText(
                'Display Name',
                variant: AppTextVariant.captionText,
              ),
            ),
            const SizedBox(
              width: 100,
              child: AppText('Actions', variant: AppTextVariant.captionText),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const AppDivider(),
        const SizedBox(height: 8),

        // Property Type List
        ...mockPropertyTypes.map(
          (propertyType) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppText(
                    propertyType.$1,
                    variant: AppTextVariant.bodyText,
                  ),
                ),
                Expanded(
                  child: AppText(
                    propertyType.$2,
                    variant: AppTextVariant.bodyText,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    propertyType.$3,
                    variant: AppTextVariant.bodyText,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      AppIconButton(
                        icon: AppIcons.edit,
                        onPressed: () {
                          // Edit action
                        },
                      ),
                      const SizedBox(width: 8),
                      AppIconButton(
                        icon: AppIcons.x,
                        onPressed: () {
                          // Delete action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Add Button
        Row(
          children: [
            AppButton.primary(
              label: 'Add Property Type',
              onPressed: () {
                // Add action
              },
            ),
          ],
        ),
      ],
    );
  }
}
