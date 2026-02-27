/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/entity.dart';
import 'package:core_graph_common/src/query/predicate.dart';
import 'package:core_graph_common/src/query/sort_descriptor.dart';
import 'package:core_graph_common/src/storage/graph_storage.dart';

/// クエリ結果を表すクラス
class QueryResult<T> {
  /// 新しいクエリ結果を作成
  const QueryResult({
    required this.items,
    required this.totalCount,
    this.hasMore = false,
  });

  /// 結果アイテムのリスト
  final List<T> items;

  /// 合計件数
  final int totalCount;

  /// さらに結果があるかどうか
  final bool hasMore;
}

/// グラフデータに対するクエリを表現する主要クラス
class GraphQuery<T extends Entity> {
  GraphQuery({
    required this.entityType,
    List<Predicate>? predicates,
    List<SortDescriptor>? sortDescriptors,
    this.limit,
    this.offset,
    this.groupBy,
  }) : predicates = predicates ?? [],
       sortDescriptors = sortDescriptors ?? [];

  /// エンティティタイプ (Node または Link)
  final Type entityType;

  /// フィルタリング条件
  final List<Predicate> predicates;

  /// ソート条件
  final List<SortDescriptor> sortDescriptors;

  /// ページネーション
  final int? limit;
  final int? offset;

  /// グループ化（オプション）
  final List<String>? groupBy;

  /// 新しい条件を追加
  GraphQuery<T> where(Predicate predicate) {
    return GraphQuery<T>(
      entityType: entityType,
      predicates: [predicate],
      sortDescriptors: sortDescriptors,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
  }

  /// AND条件を追加
  GraphQuery<T> andWhere(Predicate predicate) {
    return GraphQuery<T>(
      entityType: entityType,
      predicates: [...predicates, predicate],
      sortDescriptors: sortDescriptors,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
  }

  /// OR条件を追加
  GraphQuery<T> orWhere(Predicate predicate) {
    if (predicates.isEmpty) {
      return where(predicate);
    }
    return GraphQuery<T>(
      entityType: entityType,
      predicates: [
        CompoundPredicate(CompoundOperator.or, [...predicates, predicate]),
      ],
      sortDescriptors: sortDescriptors,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
  }

  /// ソート条件を追加
  GraphQuery<T> sortBy(String property, {bool ascending = true}) {
    return GraphQuery<T>(
      entityType: entityType,
      predicates: predicates,
      sortDescriptors: [
        ...sortDescriptors,
        SortDescriptor(property, ascending: ascending),
      ],
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
  }

  /// 取得件数を制限
  GraphQuery<T> limitTo(int limit) {
    return GraphQuery<T>(
      entityType: entityType,
      predicates: predicates,
      sortDescriptors: sortDescriptors,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
  }

  /// オフセットを設定
  GraphQuery<T> offsetBy(int offset) {
    return GraphQuery<T>(
      entityType: entityType,
      predicates: predicates,
      sortDescriptors: sortDescriptors,
      limit: limit,
      offset: offset,
      groupBy: groupBy,
    );
  }

  /// クエリを実行
  Future<List<T>> execute(GraphStorage storage) async {
    return storage.executeQuery<T>(this);
  }
}
