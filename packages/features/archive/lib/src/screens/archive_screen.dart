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
import 'package:core_themes/core_themes.dart';
import '../models/archived_entity.dart';
import '../widgets/archived_entity_list.dart';

/// Archive Screen.
class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  ArchivedEntity? _selectedEntity;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Row(
      children: [
        // Left side: Archived entity list
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: appColorScheme.base.background,
              border: Border(
                right: BorderSide(color: appColorScheme.base.border, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColorScheme.base.background,
                    border: Border(
                      bottom: BorderSide(
                        color: appColorScheme.base.border,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.archiveOutlined,
                        size: 20,
                        color: appColorScheme.base.foreground,
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        'Archive',
                        variant: AppTextVariant.sectionTitlePrimary,
                        color: appColorScheme.base.foreground,
                      ),
                    ],
                  ),
                ),

                // Entity list
                Expanded(
                  child: ArchivedEntityList(
                    onEntitySelected: (entity) {
                      setState(() {
                        _selectedEntity = entity;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right side: Entity details / Editor pane
        Expanded(
          flex: 2,
          child:
              _selectedEntity != null
                  ? _ArchiveEntityEditor(entity: _selectedEntity!)
                  : _buildEmptyState(appColorScheme),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppColorScheme colorScheme) {
    return Container(
      color: colorScheme.base.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.archiveOutlined,
              size: 64,
              color: colorScheme.base.foreground.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            AppText(
              'Please select an entity',
              variant: AppTextVariant.bodyText,
              color: colorScheme.base.foreground.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

/// Editor pane for archived entities.
class _ArchiveEntityEditor extends ConsumerWidget {
  const _ArchiveEntityEditor({required this.entity});

  final ArchivedEntity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Container(
      color: appColorScheme.base.background,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColorScheme.base.background,
              border: Border(
                bottom: BorderSide(color: appColorScheme.base.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  entity.isNode ? AppIcons.circle : AppIcons.link,
                  size: 20,
                  color: appColorScheme.base.foreground,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    entity.name,
                    variant: AppTextVariant.itemTitle,
                    color: appColorScheme.base.foreground,
                  ),
                ),
                // Entity type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        entity.isNode
                            ? appColorScheme.theme.primaryColor.withValues(
                              alpha: 0.1,
                            )
                            : appColorScheme.theme.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    entity.isNode ? 'Node' : 'Link',
                    variant: AppTextVariant.captionText,
                    color:
                        entity.isNode
                            ? appColorScheme.theme.primaryColor
                            : appColorScheme.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  _buildInfoSection('Basic Information', [
                    _buildInfoRow('ID', entity.id.value),
                    _buildInfoRow('Type', entity.isNode ? 'Node' : 'Link'),
                    _buildInfoRow('Name', entity.name),
                    if (entity.description != null)
                      _buildInfoRow('Description', entity.description!),
                    _buildInfoRow(
                      'Archived Date',
                      _formatDateTime(entity.archivedAt),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Properties
                  if (entity.properties.isNotEmpty) ...[
                    _buildInfoSection('Properties', [
                      for (final entry in entity.properties.entries)
                        _buildInfoRow(entry.key, entry.value.toString()),
                    ]),
                    const SizedBox(height: 24),
                  ],

                  // Actions
                  _buildActionsSection(ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, variant: AppTextVariant.sectionTitlePrimary),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: AppText(label, variant: AppTextVariant.captionText),
          ),
          Expanded(child: AppText(value, variant: AppTextVariant.bodyText)),
        ],
      ),
    );
  }

  Widget _buildActionsSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Actions', variant: AppTextVariant.itemTitle),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppButton.primary(
              label: 'Restore',
              onPressed: () {
                // TODO: Implement restore process
              },
            ),
            AppButton.destructive(
              label: 'Delete Permanently',
              onPressed: () {
                // TODO: Implement permanent delete process
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
