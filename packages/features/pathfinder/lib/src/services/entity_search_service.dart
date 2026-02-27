/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../models/pathfinder_item.dart';

/// エンティティ検索サービス
///
/// グラフデータからエンティティを検索するためのサービスクラスです。
class EntitySearchService {
  /// コンストラクタ
  EntitySearchService();

  /// グラフからエンティティを検索
  ///
  /// [graph] 検索対象のグラフ
  /// [query] 検索クエリ
  /// [limit] 検索結果の最大数
  /// [includeNodes] ノードを検索結果に含めるかどうか
  /// [includeLinks] リンクを検索結果に含めるかどうか
  List<PathfinderItem> searchEntities(
    core_graph.Graph? graph,
    String query, {
    int limit = 20,
    bool includeNodes = true,
    bool includeLinks = true,
  }) {
    if (graph == null || query.isEmpty) {
      return [];
    }

    final results = <PathfinderItem>[];
    final lowerQuery = query.toLowerCase();

    // ノードを検索
    if (includeNodes) {
      final matchedNodes = graph.nodes.values
          .where((node) {
            // タイプで検索
            if (node.description.type.toLowerCase().contains(lowerQuery)) {
              return true;
            }

            // プロパティで検索
            for (final key in node.properties.keys) {
              final value = node.properties.getValue(key);
              if (value is String && value.toLowerCase().contains(lowerQuery)) {
                return true;
              }
            }

            // IDで検索
            if (node.id.toString().toLowerCase().contains(lowerQuery)) {
              return true;
            }

            return false;
          })
          .take(limit);

      // 検索結果をPathfinderItemに変換
      for (final node in matchedNodes) {
        // タイトルとして使用するプロパティを探す
        String title = node.description.type;
        String? description;

        // 'name' または 'title' プロパティがあれば、それをタイトルとして使用
        if (node.hasProperty('name')) {
          final nameValue = node.getPropertyValue('name');
          if (nameValue is String) {
            title = nameValue;
          }
        } else if (node.hasProperty('title')) {
          final titleValue = node.getPropertyValue('title');
          if (titleValue is String) {
            title = titleValue;
          }
        }

        // 'description' プロパティがあれば、それを説明として使用
        if (node.hasProperty('description')) {
          final descValue = node.getPropertyValue('description');
          if (descValue is String) {
            description = descValue;
          }
        }

        results.add(
          PathfinderItem(
            id: node.id.toString(),
            title: title,
            description: description,
            type: PathfinderItemType.node,
            metadata: {'entityId': node.id.toString(), 'entityType': 'node'},
          ),
        );
      }
    }

    // リンクを検索
    if (includeLinks && results.length < limit) {
      final remainingLimit = limit - results.length;
      final matchedLinks = graph.links.values
          .where((link) {
            // タイプで検索
            if (link.description.type.toLowerCase().contains(lowerQuery)) {
              return true;
            }

            // リンクタイプで検索
            if (link.type.toLowerCase().contains(lowerQuery)) {
              return true;
            }

            // プロパティで検索
            for (final key in link.properties.keys) {
              final value = link.properties.getValue(key);
              if (value is String && value.toLowerCase().contains(lowerQuery)) {
                return true;
              }
            }

            // IDで検索
            if (link.id.toString().toLowerCase().contains(lowerQuery)) {
              return true;
            }

            return false;
          })
          .take(remainingLimit);

      // 検索結果をPathfinderItemに変換
      for (final link in matchedLinks) {
        // ソースノードとターゲットノードを取得
        final sourceNode = graph.nodes[link.sourceId];
        final targetNode = graph.nodes[link.targetId];

        // ソースノードとターゲットノードの名前を取得
        String sourceName = sourceNode?.description.type ?? '不明なノード';
        String targetName = targetNode?.description.type ?? '不明なノード';

        // ソースノードに 'name' または 'title' プロパティがあれば、それを名前として使用
        if (sourceNode != null) {
          if (sourceNode.hasProperty('name')) {
            final nameValue = sourceNode.getPropertyValue('name');
            if (nameValue is String) {
              sourceName = nameValue;
            }
          } else if (sourceNode.hasProperty('title')) {
            final titleValue = sourceNode.getPropertyValue('title');
            if (titleValue is String) {
              sourceName = titleValue;
            }
          }
        }

        // ターゲットノードに 'name' または 'title' プロパティがあれば、それを名前として使用
        if (targetNode != null) {
          if (targetNode.hasProperty('name')) {
            final nameValue = targetNode.getPropertyValue('name');
            if (nameValue is String) {
              targetName = nameValue;
            }
          } else if (targetNode.hasProperty('title')) {
            final titleValue = targetNode.getPropertyValue('title');
            if (titleValue is String) {
              targetName = titleValue;
            }
          }
        }

        // タイトルとして使用するプロパティを探す
        String title = '$sourceName → $targetName';
        String description = 'タイプ: ${link.type}';

        // 'name' または 'title' プロパティがあれば、それをタイトルとして使用
        if (link.hasProperty('name')) {
          final nameValue = link.getPropertyValue('name');
          if (nameValue is String && nameValue.isNotEmpty) {
            title = nameValue;
          }
        } else if (link.hasProperty('title')) {
          final titleValue = link.getPropertyValue('title');
          if (titleValue is String && titleValue.isNotEmpty) {
            title = titleValue;
          }
        }

        // 'description' プロパティがあれば、それを説明として使用
        if (link.hasProperty('description')) {
          final descValue = link.getPropertyValue('description');
          if (descValue is String && descValue.isNotEmpty) {
            description = descValue;
          }
        }

        results.add(
          PathfinderItem(
            id: link.id.toString(),
            title: title,
            description: description,
            type: PathfinderItemType.link,
            metadata: {
              'entityId': link.id.toString(),
              'entityType': 'link',
              'sourceId': link.sourceId.toString(),
              'targetId': link.targetId.toString(),
              'linkType': link.type,
            },
          ),
        );
      }
    }

    return results;
  }
}
