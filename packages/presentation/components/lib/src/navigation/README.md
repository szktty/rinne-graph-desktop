# App ナビゲーションコンポーネント

このモジュールは、RinneGraphのナビゲーションシステムを実装するためのコンポーネント群を提供します。

## 主要コンポーネント

- `NavigationContainer`: ナビゲーション項目を含むコンテナで、スクロール可能な領域を管理します
- `NavigationItem`: 単一のナビゲーション項目を表示するウィジェット
- `NavigationGroup`: 折りたたみ可能なナビゲーション項目のグループ
- `NavigationGroupHeader`: セクションを表すヘッダー要素
- `NavigationDivider`: ナビゲーション項目間の区切り線
- `NavigationBadge`: ナビゲーション項目に表示するバッジ要素
- `NavigationSearchField`: ナビゲーション項目を検索するためのフィールド

## 基本的な使用例

```dart
import 'package:flutter/material.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:presentation_components/presentation_components.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // 通常のウィジェットとして使用する例
    return NavigationContainer(
      children: [
        NavigationGroupHeader(
          id: IdGenerator.uuidV7(),
          title: 'メインメニュー',
        ),
        NavigationItem(
          id: IdGenerator.uuidV7(),
          title: 'ホーム',
          leading: const Icon(Icons.home),
          onTap: () => print('ホームがタップされました'),
        ),
        NavigationItem(
          id: IdGenerator.uuidV7(),
          title: 'プロジェクト',
          leading: const Icon(Icons.folder),
          trailing: NavigationBadge(text: '5'),
        ),
        NavigationDivider(),
        NavigationGroup(
          id: IdGenerator.uuidV7(),
          title: 'コンテンツ',
          initiallyExpanded: true,
          children: [
            NavigationItem(
              id: IdGenerator.uuidV7(),
              title: 'ドキュメント',
              leading: const Icon(Icons.description),
            ),
            NavigationItem(
              id: IdGenerator.uuidV7(),
              title: '画像',
              leading: const Icon(Icons.image),
              trailing: NavigationBadge(text: '新規'),
            ),
          ],
        ),
      ],
    );
  }
}
```

## Riverpodとの統合

Riverpodを使用してナビゲーション状態を管理する例：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:presentation_components/presentation_components.dart';

class SidebarWithRiverpod extends ConsumerWidget {
  const SidebarWithRiverpod({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // navigationStateProviderを使用して状態を管理
    final navigationState = ref.watch(navigationStateProvider);
    
    // 実際のナビゲーション項目
    return Column(
      children: [
        NavigationSearchField(
          hintText: 'スタックを検索...',
          onChanged: (query) {
            // 検索処理
          },
        ),
        Expanded(
          child: NavigationContainer(
            selectedItemId: navigationState.selectedItemId,
            expandedGroupIds: navigationState.expandedGroupIds,
            onItemSelected: (itemId) => ref.read(navigationStateProvider.notifier).selectItem(itemId),
            onGroupToggled: (groupId) => ref.read(navigationStateProvider.notifier).toggleGroup(groupId),
            children: [
              NavigationGroupHeader(
                id: IdGenerator.uuidV7(),
                title: 'プロジェクト',
              ),
              NavigationItem(
                id: IdGenerator.uuidV7(),
                title: 'すべてのスタック',
                leading: const Icon(Icons.layers),
              ),
              NavigationDivider(),
              NavigationGroup(
                id: IdGenerator.uuidV7(),
                title: '最近使用したスタック',
                icon: const Icon(Icons.history),
                children: [
                  NavigationItem(
                    id: IdGenerator.uuidV7(),
                    title: 'プロジェクト計画',
                  ),
                  NavigationItem(
                    id: IdGenerator.uuidV7(),
                    title: 'アイデアマップ',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

## ナビゲーション項目の動的生成

```dart
// Riverpodのプロバイダーを使用して、動的にナビゲーション項目を生成する例
final sidebarItemsProvider = Provider<List<Widget>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  final recentStacks = ref.watch(recentStacksProvider);
  
  final items = <Widget>[];
  
  // メインセクション
  items.add(NavigationGroupHeader(
    id: IdGenerator.uuidV7(),
    title: 'メイン',
  ));
  
  items.add(NavigationItem(
    id: IdGenerator.uuidV7(),
    title: 'ホーム',
    leading: const Icon(Icons.home),
  ));
  
  items.add(NavigationDivider());
  
  // お気に入りセクション（存在する場合）
  if (favorites.isNotEmpty) {
    items.add(NavigationGroupHeader(
      id: IdGenerator.uuidV7(),
      title: 'お気に入り',
    ));
    
    for (final fav in favorites) {
      items.add(NavigationItem(
        id: IdGenerator.fromString('fav_${fav.id}'),
        title: fav.name,
        leading: const Icon(Icons.star),
      ));
    }
    
    items.add(NavigationDivider());
  }
  
  // 最近使用したスタック
  if (recentStacks.isNotEmpty) {
    items.add(NavigationGroup(
      id: IdGenerator.uuidV7(),
      title: '最近使用したスタック',
      children: recentStacks.map((stack) => 
        NavigationItem(
          id: IdGenerator.fromString('stack_${stack.id}'),
          title: stack.name,
          trailing: Text(stack.lastModified),
        )
      ).toList(),
    ));
  }
  
  return items;
});
```

## デザイン考慮事項

1. **テーマとの統合**:
   - 各コンポーネントはFlutterのThemeと統合されており、カラーパレット、タイポグラフィ、スペーシングはテーマから継承します
   - ダークモード/ライトモードの切り替えに自動対応します

2. **アクセシビリティ**:
   - 十分なコントラスト比を確保
   - 適切なフォントサイズとパディングを使用
   - スクリーンリーダー対応のためのセマンティクスが考慮されています

3. **レスポンシブデザイン**:
   - 異なる画面サイズでの表示に対応
   - 折りたたみ可能な領域をサポート

## 制約事項

1. 再帰的なグループはサポートしていません。つまり、NavigationGroupの中にNavigationGroupを入れ子にすることはできません。

2. 大量の項目がある場合、パフォーマンスの問題が発生する可能性があります。その場合は、遅延ロードや仮想化スクロールの実装を検討してください。
