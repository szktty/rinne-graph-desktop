# TabView コンポーネント

タブ付きインターフェースを構築するための汎用タブビューコンポーネント。
アイコンのみ、テキストのみ、またはアイコンとテキストの組み合わせに対応しており、選択状態のハイライトスタイルも設定可能です。

## 基本的な使い方

```dart
TabView(
  tabs: [
    TabItem.iconOnly(
      id: 'info',
      icon: Icons.info,
      content: const InfoContentView(),
      tooltip: '情報',
    ),
    TabItem.textOnly(
      id: 'filter',
      text: 'フィルター',
      content: const FilterContentView(),
    ),
    TabItem.withIconAndText(
      id: 'settings',
      icon: Icons.settings,
      text: '設定',
      content: const SettingsContentView(),
    ),
  ],
  highlightStyle: TabHighlightStyle.underline,
  tabBarBackgroundColor: Colors.grey[100],
)
```

## Riverpod との統合

タブビュー状態をRiverpodで管理するには、提供されているプロバイダーを使用します：

```dart
class MyTabView extends ConsumerWidget {
  const MyTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabState = ref.watch(tabViewStateProvider);
    
    final tabs = [
      TabItem.iconOnly(
        id: 'info',
        icon: Icons.info,
        content: const InfoContentView(),
        tooltip: '情報',
      ),
      TabItem.textOnly(
        id: 'filter',
        text: 'フィルター',
        content: const FilterContentView(),
      ),
      TabItem.withIconAndText(
        id: 'settings',
        icon: Icons.settings,
        text: '設定',
        content: const SettingsContentView(),
      ),
    ];
    
    return TabView(
      tabs: tabs,
      initialSelectedTabId: tabState,
      onTabSelected: (tabId) => ref.read(tabViewStateProvider.notifier).selectTab(tabId),
      highlightStyle: TabHighlightStyle.underline,
    );
  }
}
```

## ハイライトスタイル

TabViewは2種類のハイライトスタイルをサポートしています：

1. `TabHighlightStyle.underline` - 選択タブの下部に下線を表示します。Material Designスタイルのタブに適しています。
2. `TabHighlightStyle.background` - 選択タブの背景色を変更します。タブバーが主要なナビゲーション要素である場合に有効です。

```dart
TabView(
  tabs: tabs,
  highlightStyle: TabHighlightStyle.background,
  highlightColor: Theme.of(context).colorScheme.primary,
  inactiveTabBackgroundColor: Colors.grey[200],
)
```

## タブのカスタマイズ

各タブは独自のスタイルをサポートしています：

```dart
TabItem(
  id: 'custom',
  icon: Icons.star,
  text: 'カスタム',
  content: const CustomView(),
  activeIconColor: Colors.amber,
  inactiveIconColor: Colors.grey,
  activeTextStyle: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
  inactiveTextStyle: TextStyle(color: Colors.grey),
  tooltip: 'カスタムタブ',
)
```

## 右サイドバーでの使用例

右サイドバーでタブビューコンポーネントを使用する場合のサンプルコード：

```dart
class RightSidebar extends ConsumerWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabState = ref.watch(tabViewStateProvider);
    final theme = Theme.of(context);
    
    final tabs = [
      TabItem.iconOnly(
        id: 'info',
        icon: Icons.info_outline,
        tooltip: '情報',
        activeIconColor: theme.colorScheme.primary,
        content: const ChartInfoPanel(),
      ),
      TabItem.iconOnly(
        id: 'filter',
        icon: Icons.filter_list,
        tooltip: 'フィルター',
        activeIconColor: theme.colorScheme.primary,
        content: const FilterPanel(),
      ),
      TabItem.iconOnly(
        id: 'settings',
        icon: Icons.settings_outlined,
        tooltip: '設定',
        activeIconColor: theme.colorScheme.primary,
        content: const SettingsPanel(),
      ),
    ];
    
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: TabView(
        tabs: tabs,
        initialSelectedTabId: tabState,
        onTabSelected: (tabId) => ref.read(tabViewStateProvider.notifier).selectTab(tabId),
        highlightStyle: TabHighlightStyle.underline,
        highlightColor: theme.colorScheme.primary,
        tabBarBackgroundColor: const Color(0xFFF5F5F7),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
```
