import 'package:flutter/material.dart';

/// パスファインダーで表示する項目の種類
enum PathfinderItemType {
  /// スタック
  stack,

  /// ノード
  node,

  /// リンク
  link,

  /// コマンド
  command,

  /// 検索結果
  searchResult,
}

/// パスファインダーで表示する項目
class PathfinderItem {
  /// コンストラクタ
  const PathfinderItem({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.icon,
    this.metadata,
  });

  /// 項目のID
  final String id;

  /// 項目のタイトル
  final String title;

  /// 項目の説明
  final String? description;

  /// 項目の種類
  final PathfinderItemType type;

  /// 項目のアイコン
  final IconData? icon;

  /// 項目のメタデータ
  final Map<String, dynamic>? metadata;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathfinderItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
