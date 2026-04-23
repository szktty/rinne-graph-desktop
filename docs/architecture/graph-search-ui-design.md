# Graph Search UI Design

## Overview

The graph search feature provides two complementary search modes in the sidebar's Search tab:

1. **Keyword Search** — the primary mode; fast full-text search across all nodes and links
2. **Path Search** — a secondary mode; pattern-based subgraph query (Node→Link→Node chains)

Search results are displayed as a **filtered view** of the current graph: only matching nodes and links remain visible, with highlights. Results can also be exported as a new subgraph view.

---

## Search Tab Structure

```
Search タブ（サイドバー内）
├── モード切り替えトグル: [Keyword | Path Search]
│
│ ── Keyword モード（デフォルト） ──
├── 検索フィールド（テキスト入力 + Enter で実行）
│     placeholder: "Search nodes and links..."
├── フィルターチップ行（横スクロール可能）
│     [All] [Person] [Company] [→works_for] ...   ← グラフ実データから動的取得
├── ── 実行前の空状態 ──
│     "Enter a keyword to search"
├── ── 実行中 ──
│     static indicator + "Searching..."
├── ── 結果リスト（スクロール） ──
│   セクション "Nodes (12)"
│   ├── [○] Node Name          [Label]   ← シングルタップ: ハイライト
│   │                                      ダブルタップ: スクロール＆フォーカス
│   セクション "Links (5)"
│   └── [→] link_type    from → to       ← 同上
├── 結果フッター: "12 nodes, 5 links  (23ms)"
└── [Open as Subgraph View]               ← 結果がある場合のみ表示
│
│ ── Path Search モード ──
├── パターン定義エリア（サイドバー内スクロール）
│   ┌────────────────────────┐
│   │ [○] Node A             │ ← ノードタイル（展開で keyword 入力）
│   │   Label: Person        │
│   │   Keyword: John*       │
│   └────────────────────────┘
│        [↓↑↔▼] WORKS_FOR   ← リンクタイル（展開で type/keyword）
│   ┌────────────────────────┐
│   │ [○] Node B             │
│   │   Label: Company       │
│   └────────────────────────┘
│   [+ Add Node]
├── [Exploration Options ▼]（折りたたみ）
│     Depth: [2▼]   Max Results: [100▼]
│     Algorithm: [BreadthFirst▼]
├── [Execute Search] ボタン
├── ── 結果サマリー ──
│     "12 nodes, 5 links  (23ms)"
│     [Open as Subgraph View]
└── エラー表示
```

---

## State Design

### SearchMode

```dart
enum SearchMode { keyword, pathSearch }
```

`searchModeProvider` (StateProvider<SearchMode>) でタブ全体のモードを管理する。

### Keyword Search State

既存の `searchExecutionServiceProvider` の `executeKeywordSearch()` を使用。

新規追加が必要なプロバイダー:

| Provider | Type | Role |
|---|---|---|
| `keywordSearchQueryProvider` | `StateProvider<String>` | 入力テキスト |
| `keywordSearchFiltersProvider` | `StateProvider<KeywordSearchFilters>` | ラベル/タイプのフィルターチップ選択状態 |
| `keywordSearchResultProvider` | `StateProvider<SearchResult?>` | 検索結果 |
| `keywordSearchExecutingProvider` | `StateProvider<bool>` | 実行中フラグ |
| `availableNodeLabelsProvider` | `FutureProvider<List<String>>` | グラフ実データから動的取得 |
| `availableLinkTypesProvider` | `FutureProvider<List<String>>` | グラフ実データから動的取得 |

`KeywordSearchFilters`:
```dart
class KeywordSearchFilters {
  final Set<String> nodeLabels;   // 空 = すべて
  final Set<String> linkTypes;    // 空 = すべて
}
```

既存の `filterStateProvider` (filter_providers.dart) は現在サンプルデータで動作しているため、
`availableNodeLabelsProvider` / `availableLinkTypesProvider` に置き換えて実データを使う。

### Path Search State

既存のプロバイダーを維持・整理:

| Provider | 変更 |
|---|---|
| `searchPatternStateProvider` | 維持 |
| `explorationOptionsStateProvider` | 維持 |
| `searchResultStateProvider` | キーワード検索と共用 → Path Search 専用に分離 |
| `searchExecutingProvider` | 同上 |
| `searchErrorProvider` | 同上 |

### Graph View Integration State

新規追加:

| Provider | Type | Role |
|---|---|---|
| `searchHighlightProvider` | `StateProvider<SearchHighlight?>` | ハイライト対象の entityId セット |
| `searchFocusTargetProvider` | `StateProvider<EntityId?>` | ダブルタップでフォーカスするエンティティ |

```dart
class SearchHighlight {
  final Set<EntityId> nodeIds;
  final Set<EntityId> linkIds;
  final bool isFilterMode;   // true: 非ヒットを非表示, false: 薄くする
}
```

---

## Graph View Integration

### ハイライト表示

`searchHighlightProvider` を `AppGraphView` / `AppNodeRenderer` が watch し、
ヒットしたノード/リンクを強調、非ヒットを dim（透明度を下げる）表示にする。

実装ポイント:
- `AppNodeRenderer` にハイライト状態を渡すパラメータを追加
- Plough の link/node スタイリングに透明度を反映
- `isFilterMode = true` の場合は非ヒットノードをグラフから除外して再描画

### スクロール＆フォーカス（ダブルタップ）

`searchFocusTargetProvider` に EntityId をセットすると、
`AppGraphView` の `TransformationController` がそのノードの座標へアニメーション移動する。

既存の `selectionStateProvider` と連携し、フォーカス対象を選択状態にする。

### サブグラフとして開く

「Open as Subgraph View」ボタンは:
1. 検索結果の node/link セットを `SubgraphDataset` として作成
2. Navigation タブの `DatasetItem` に追加（`DatasetType.temporary` として）
3. Navigation タブに切り替え、作成したエントリを選択状態にする
4. グラフビューをそのサブグラフで再描画

---

## UI Component Breakdown

### 新規作成が必要なウィジェット

| Widget | 場所 | 役割 |
|---|---|---|
| `_KeywordModeContent` | graph_navigator_sidebar.dart 内 | キーワードモードのUI全体 |
| `_SearchFilterChips` | graph_navigator_sidebar.dart 内 | ラベル/タイプのフィルターチップ行 |
| `_SearchResultList` | graph_navigator_sidebar.dart 内 | 結果リスト（Node/Linkセクション） |
| `_SearchResultNodeItem` | graph_navigator_sidebar.dart 内 | ノード結果の1行 |
| `_SearchResultLinkItem` | graph_navigator_sidebar.dart 内 | リンク結果の1行 |
| `_SearchResultFooter` | graph_navigator_sidebar.dart 内 | 件数・実行時間・サブグラフボタン |

### 既存ウィジェットの変更

| Widget | 変更内容 |
|---|---|
| `_SearchTabContent` | モード切り替えトグル追加、Keyword/PathSearch を切り替え |
| `AppNodeRenderer` | `searchHighlightProvider` を watch してハイライト/dim |
| `AppGraphView` | `searchFocusTargetProvider` を watch してスクロール制御 |
| `NavigationTabContent` | サブグラフ `DatasetItem` の追加表示 |

---

## Implementation Order

複数パッケージにまたがるため、下位レイヤーから実装する。

### Phase 1: State Layer（providers）
1. `searchModeProvider` 追加
2. `keywordSearchQueryProvider`, `keywordSearchFiltersProvider` 等の追加
3. `availableNodeLabelsProvider` / `availableLinkTypesProvider` を実データで実装
4. `searchHighlightProvider`, `searchFocusTargetProvider` 追加
5. Keyword/PathSearch の result/executing/error を分離

### Phase 2: Keyword Search UI
6. `_SearchFilterChips` 実装（動的ラベル取得）
7. `_SearchResultNodeItem` / `_SearchResultLinkItem` 実装
8. `_SearchResultList` 実装（セクション分け）
9. `_SearchResultFooter` 実装
10. `_KeywordModeContent` に組み合わせ
11. キーワード検索の実行ロジック接続（`executeKeywordSearch` → result 反映）

### Phase 3: Graph View Integration
12. `AppNodeRenderer` にハイライト/dim ロジック追加
13. `AppGraphView` にフォーカススクロールロジック追加

### Phase 4: Path Search UI Cleanup
14. `_SearchTabContent` にモード切り替えトグル追加
15. 既存の Path Search UIを整理（不要な Keyword Search フィールドを削除）
16. Exploration Options の Max Results をドロップダウン化
17. Path Search 用 result/executing/error を分離したプロバイダーに接続

### Phase 5: Subgraph View
18. `SubgraphDataset` モデル追加
19. Navigation タブへのサブグラフエントリ追加・切り替えロジック
20. `DatasetItem` からのグラフビュー切り替え

---

## Open Questions / Decisions Needed

- **フィルターチップの数が多い場合**: 横スクロールで対応する（折りたたみは不要）
- **検索結果の上限**: キーワード検索は最大 200 件（ノード+リンクで合計）を暫定値とする
- **ハイライト vs フィルター**: デフォルトはハイライト（非ヒットを dim）。フィルターモード（非ヒットを非表示）はサブグラフ作成時に用いる
- **サブグラフの永続化**: `DatasetType.temporary` として扱い、アプリ再起動で消える（将来的に `DatasetType.saved` で保存可能にする）
- **Path Search の「Add Property Condition」**: 現在 TODO。Phase 4 では削除してシンプル化する（将来の機能として保留）
