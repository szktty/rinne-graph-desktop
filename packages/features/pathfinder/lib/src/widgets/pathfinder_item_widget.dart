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

import '../models/pathfinder_item.dart';

/// パスファインダー項目ウィジェット
class PathfinderItemWidget extends ConsumerWidget {
  /// コンストラクタ
  const PathfinderItemWidget({
    required this.item,
    this.isSelected = false,
    this.onTap,
    this.onHover,
    super.key,
  });

  /// 表示する項目
  final PathfinderItem item;

  /// 選択されているかどうか
  final bool isSelected;

  /// タップされたときのコールバック
  final VoidCallback? onTap;

  /// ホバーされたときのコールバック
  final VoidCallback? onHover;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final theme = Theme.of(context);

    // 項目の種類に応じたアイコンを取得
    final IconData itemIcon = item.icon ?? _getIconForItemType(item.type);

    return InkWell(
      onTap: onTap,
      onHover: (isHovering) {
        if (isHovering && onHover != null) {
          onHover!();
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? appColorScheme.interactive.quickInput.selectedItemBackground
                  : appColorScheme.interactive.quickInput.hoverBackground,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              itemIcon,
              size: 20,
              color:
                  isSelected
                      ? appColorScheme.interactive.quickInput.selectedItemText
                      : appColorScheme.interactive.quickInput.itemText,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isSelected
                              ? appColorScheme
                                  .interactive
                                  .quickInput
                                  .selectedItemText
                              : appColorScheme.interactive.quickInput.itemText,
                    ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isSelected
                                ? appColorScheme
                                    .interactive
                                    .quickInput
                                    .selectedItemText
                                    .withAlpha(204) // 0.8相当
                                : appColorScheme
                                    .interactive
                                    .quickInput
                                    .itemDescriptionText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // 項目の種類に応じたバッジを表示
            _buildItemTypeBadge(context, item.type, appColorScheme),
          ],
        ),
      ),
    );
  }

  /// 項目の種類に応じたアイコンを取得
  IconData _getIconForItemType(PathfinderItemType type) {
    switch (type) {
      case PathfinderItemType.stack:
        return AppIcons.layers;
      case PathfinderItemType.node:
        return AppIcons.circle;
      case PathfinderItemType.link:
        return AppIcons.link;
      case PathfinderItemType.command:
        return AppIcons.terminal;
      case PathfinderItemType.searchResult:
        return AppIcons.search;
    }
  }

  /// 項目の種類に応じたバッジを構築
  Widget _buildItemTypeBadge(
    BuildContext context,
    PathfinderItemType type,
    AppColorScheme appColorScheme,
  ) {
    final theme = Theme.of(context);

    String label;

    switch (type) {
      case PathfinderItemType.stack:
        label = 'スタック';
        break;
      case PathfinderItemType.node:
        label = 'ノード';
        break;
      case PathfinderItemType.link:
        label = 'リンク';
        break;
      case PathfinderItemType.command:
        label = 'コマンド';
        break;
      case PathfinderItemType.searchResult:
        label = '検索結果';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            isSelected
                ? appColorScheme.interactive.quickInput.selectedItemBackground
                    .withAlpha(51) // 0.2相当
                : appColorScheme.interactive.quickInput.hoverBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color:
              isSelected
                  ? appColorScheme.interactive.quickInput.selectedItemText
                  : appColorScheme.interactive.quickInput.itemText,
        ),
      ),
    );
  }
}
