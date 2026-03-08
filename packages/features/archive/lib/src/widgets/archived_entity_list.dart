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
import '../providers/archive_providers.dart';

/// Widget that displays a list of archived entities.
class ArchivedEntityList extends ConsumerWidget {
  const ArchivedEntityList({this.onEntitySelected, super.key});

  /// Callback when an entity is selected.
  final void Function(ArchivedEntity entity)? onEntitySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedEntitiesAsync = ref.watch(archivedEntitiesProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return archivedEntitiesAsync.when(
      data:
          (entities) =>
              _buildEntityList(context, ref, entities, appColorScheme),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FondeIcon(
                  FondeIcons.clear,
                  customSize: 48,
                  customColor: appColorScheme.status.error,
                ),
                const SizedBox(height: 16),
                AppText(
                  'An error occurred',
                  variant: AppTextVariant.bodyText,
                  color: appColorScheme.status.error,
                ),
                const SizedBox(height: 8),
                AppText(
                  error.toString(),
                  variant: AppTextVariant.captionText,
                  color: appColorScheme.base.foreground.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildEntityList(
    BuildContext context,
    WidgetRef ref,
    List<ArchivedEntity> entities,
    AppColorScheme colorScheme,
  ) {
    if (entities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FondeIcon(
              FondeIcons.archiveOutlined,
              customSize: 64,
              customColor: colorScheme.base.foreground.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            AppText(
              'No archived entities',
              variant: AppTextVariant.bodyText,
              color: colorScheme.base.foreground.withValues(alpha: 0.7),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        return _ArchivedEntityListItem(
          entity: entity,
          onTap: () => onEntitySelected?.call(entity),
        );
      },
    );
  }
}

/// List item for an archived entity.
class _ArchivedEntityListItem extends ConsumerWidget {
  const _ArchivedEntityListItem({required this.entity, this.onTap});

  final ArchivedEntity entity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: appColorScheme.base.border, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Entity type icon
            FondeIcon(
              entity.isNode ? FondeIcons.circle : FondeIcons.link,
              customSize: 20,
              customColor: appColorScheme.base.foreground.withValues(
                alpha: 0.7,
              ),
            ),
            const SizedBox(width: 12),

            // Entity information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    entity.name,
                    variant: AppTextVariant.bodyText,
                    color: appColorScheme.base.foreground,
                  ),
                  if (entity.description != null) ...[
                    const SizedBox(height: 4),
                    AppText(
                      entity.description!,
                      variant: AppTextVariant.captionText,
                      color: appColorScheme.base.foreground.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  AppText(
                    'Archived at: ${_formatDateTime(entity.archivedAt)}',
                    variant: AppTextVariant.captionText,
                    color: appColorScheme.base.foreground.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Entity type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
