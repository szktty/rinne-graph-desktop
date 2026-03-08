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

import '../widgets/metadata_tab_navigation.dart';
import '../widgets/simple_label_management_tab.dart';
import '../widgets/property_type_management_tab.dart';
import '../providers/metadata_providers.dart';

/// Metadata editor screen
class MetadataEditorScreen extends ConsumerWidget {
  /// Constructor
  const MetadataEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabId = ref.watch(metadataTabStateProvider);

    return Scaffold(
      body: MainShellLayout(
        toolbar: const SizedBox.shrink(), // Empty toolbar
        content: _buildMainContent(context, ref),
        primarySidebar: const MetadataTabNavigation(),
        showPrimarySidebar: true,
      ),
    );
  }

  /// Builds the main content (with segmented button)
  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final selectedTabId = ref.watch(metadataTabStateProvider);
    final selectedSegment = ref.watch(metadataSegmentStateProvider);

    debugPrint(
      '[MetadataEditorScreen] Building main content for tab: $selectedTabId, segment: $selectedSegment',
    );

    switch (selectedTabId) {
      case 'labels':
        return _buildMetadataManagementContent(ref);
      default:
        return const Center(
          child: Text('Please select a tab', style: TextStyle(fontSize: 16)),
        );
    }
  }

  /// Metadata management content (with segmented button)
  Widget _buildMetadataManagementContent(WidgetRef ref) {
    final selectedSegment = ref.watch(metadataSegmentStateProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          const AppText(
            'Metadata Management',
            variant: AppTextVariant.pageTitleLarge,
          ),
          const SizedBox(height: 8),
          const AppText(
            'Manage label and property type settings',
            variant: AppTextVariant.bodyText,
          ),
          const SizedBox(height: 32),

          // Segmented button
          FondeSegmentedButton<int>(
            segments: const [
              ButtonSegment<int>(value: 0, label: Text('Labels')),
              ButtonSegment<int>(value: 1, label: Text('Property Types')),
            ],
            selected: {selectedSegment},
            onSelectionChanged: (Set<int> newSelection) {
              ref
                  .read(metadataSegmentStateProvider.notifier)
                  .selectSegment(newSelection.first);
            },
          ),
          const SizedBox(height: 24),

          // Content area
          Expanded(
            child:
                selectedSegment == 0
                    ? const SimpleLabelManagementTab()
                    : const PropertyTypeManagementTab(),
          ),
        ],
      ),
    );
  }
}
