import 'dart:collection';

import 'pathfinder_item.dart';

/// 最近使ったエンティティを管理するクラス
class RecentItemsManager {
  /// コンストラクタ
  RecentItemsManager({this.maxItems = 10});

  /// 保持する最大アイテム数
  final int maxItems;

  /// 最近使ったアイテムのリスト
  final LinkedHashMap<String, PathfinderItem> _recentItems =
      LinkedHashMap<String, PathfinderItem>();

  /// 最近使ったアイテムのリストを取得
  List<PathfinderItem> get items => _recentItems.values.toList();

  /// アイテムを追加
  void addItem(PathfinderItem item) {
    // 既存のアイテムを削除（位置を更新するため）
    _recentItems.remove(item.id);

    // 新しいアイテムを先頭に追加
    _recentItems[item.id] = item;

    // 最大数を超えた場合、最も古いアイテムを削除
    if (_recentItems.length > maxItems) {
      final oldestKey = _recentItems.keys.last;
      _recentItems.remove(oldestKey);
    }
  }

  /// アイテムを削除
  void removeItem(String itemId) {
    _recentItems.remove(itemId);
  }

  /// リストをクリア
  void clear() {
    _recentItems.clear();
  }
}

/// モックデータを生成
List<PathfinderItem> generateMockRecentItems() {
  return [
    const PathfinderItem(
      id: '1',
      title: 'プロジェクトA',
      description: 'スタック: メインデータベース',
      type: PathfinderItemType.stack,
    ),
    const PathfinderItem(
      id: '2',
      title: '山田太郎',
      description: 'ノード: 人物',
      type: PathfinderItemType.node,
    ),
    const PathfinderItem(
      id: '3',
      title: '株式会社ABC',
      description: 'ノード: 組織',
      type: PathfinderItemType.node,
    ),
    const PathfinderItem(
      id: '4',
      title: '所属',
      description: 'リンク: 山田太郎 → 株式会社ABC',
      type: PathfinderItemType.link,
    ),
    const PathfinderItem(
      id: '5',
      title: '2023年度プロジェクト',
      description: 'ノード: プロジェクト',
      type: PathfinderItemType.node,
    ),
  ];
}
