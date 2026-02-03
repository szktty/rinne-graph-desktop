# core_stack パッケージ仕様書

## 1. 概要

core_stackは、RinneGraphにおけるスタック（個人データベース）の管理を担当するコアパッケージです。スタックの検出・作成・管理、メタデータ処理、データセット（サブグラフ）管理、Riverpodプロバイダーベースの状態管理を提供します。

**詳細なスタック仕様については、[スタック仕様書](../../../docs/specifications/stack/stack_specification.md)を参照してください。**

## 2. パッケージアーキテクチャ

### 2.1 ディレクトリ構造

```
lib/
├── src/
│   ├── model/           # データモデル（Stack, StackInfo, StackSettings, Dataset）
│   ├── provider/        # Riverpodプロバイダー（状態管理）
│   ├── service/         # ビジネスロジック（検索、メタデータ管理）
│   ├── api/             # 高レベルAPI（DatasetApi）
│   ├── initialization/ # パッケージ初期化
│   └── widgets/         # UI関連（将来拡張用）
└── core_stack.dart      # メインエクスポートファイル
```

### 2.2 主要コンポーネント

#### データモデル
- **Stack**: スタック全体を表現するイミュータブルクラス
- **StackInfo**: 基本情報（名前、説明、作成者、日時、タグ）
- **StackSettings**: スタック固有設定（デフォルトビュー、バックアップ設定）
- **Dataset**: データセット（サブグラフ）とフィルター条件

#### サービス層
- **StackService**: スタック検索の統括管理
- **StackLocatorService**: ファイルシステムでのスタック検出
- **StackMetadataService**: メタデータファイルの読み書き
- **DatasetService**: データセット管理

#### API層
- **DatasetApi**: データセット操作の高レベルAPI

## 3. 使用方法

### 3.1 基本的な使用例

#### パッケージ初期化
```dart
import 'package:core_stack/core_stack.dart';

// アプリケーション初期化時
final initialization = coreStackInitialization;
```

#### スタックリストの取得
```dart
// プロバイダーを使用してスタックリストを取得
final stacksAsync = ref.watch(availableStacksProvider);

switch (stacksAsync) {
  case AsyncData(:final data):
    // data は List<Stack>
    for (final stack in data) {
      print('Stack: ${stack.info.name}');
      print('Description: ${stack.info.description}');
      print('Is Scratch: ${stack.isScratch}');
    }
  case AsyncLoading():
    // ローディング中
    showLoadingIndicator();
  case AsyncError(:final error):
    // エラー処理
    showErrorMessage('Failed to load stacks: $error');
}
```

### 3.2 スタック作成と操作

```dart
// アクションプロバイダーからスタック管理機能を取得
final actions = ref.watch(stackActionsProvider);

// 新しいスタック作成
final newStack = await actions.createCustomStack(
  name: 'My Project',
  description: 'プロジェクト管理用データベース',
  isScratch: false,
  tags: ['project', 'work'],
);

if (newStack != null) {
  // 成功時の処理
  print('Stack created: ${newStack.info.name}');

  // スタックリストを更新
  actions.triggerRefresh();
}

// スクラッチスタック（一時作業用）作成
final scratchStack = await actions.createScratchStack();

// サンプルスタック作成
final sampleCreated = await actions.createSampleStack();
```

### 3.3 データセット操作

```dart
// DatasetApiを使用してデータセット管理
final datasetApi = DatasetApi();

// データセット一覧取得
final listResult = await datasetApi.listDatasets(stack);
if (listResult.success) {
  final datasets = listResult.data!;
  print('Found ${datasets.length} datasets');

  for (final dataset in datasets) {
    print('Dataset: ${dataset.name}');
    print('Active: ${dataset.isActive}');
  }
}

// 新しいデータセット作成
final createResult = await datasetApi.createDataset(
  stack,
  name: 'Important Documents',
  description: '重要なドキュメントの集合',
  filter: DatasetFilter(
    entityLabels: ['Document'],
    properties: {
      'priority': ['high', 'urgent'],
      'status': ['active'],
    },
  ),
  color: '#FF5722',
  tags: ['important', 'documents'],
);

if (createResult.success) {
  final dataset = createResult.data!;
  print('Dataset created: ${dataset.id}');
}
```

## 4. API参照

### 4.1 主要なプロバイダー

#### スタック取得プロバイダー
- `availableStacksProvider`: `AsyncValue<List<Stack>>` - ユーザースタック一覧
- `allAvailableStacksProvider`: `AsyncValue<List<Stack>>` - 全スタック一覧（アセットスタック含む）
- `assetStackTemplatesProvider`: `AsyncValue<List<Stack>>` - アセットスタックテンプレート一覧

#### アクションプロバイダー
- `stackActionsProvider`: スタック操作アクション
  - `createCustomStack(...)`: カスタムスタック作成
  - `createScratchStack()`: スクラッチスタック作成
  - `createSampleStack()`: スタックテンプレートからスタック作成
  - `triggerRefresh()`: スタックリスト更新

#### 更新トリガー
- `refreshStacksTriggerProvider`: スタックリスト更新トリガー

### 4.2 主要なモデル

#### Stack
```dart
class Stack {
  final Directory directory;
  final StackInfo info;
  final StackSettings settings;
  final bool isScratch;
  final bool isAssetBased;

  bool get isPinned;           // ピン止め状態
  bool get isFavorite;         // お気に入り状態
  Stack copyWith(...);         // イミュータブル更新
}
```

#### StackInfo
```dart
class StackInfo {
  final String name;
  final String? description;
  final String? author;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final String version;
  final List<String> tags;
}
```

#### Dataset
```dart
class Dataset {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final bool isActive;
  final List<String> tags;
  final DatasetFilter? filter;
  final DatasetStatistics? statistics;
}
```

### 4.3 主要なサービス

#### DatasetApi
- `listDatasets(Stack stack)`: データセット一覧取得
- `createDataset(Stack stack, ...)`: データセット作成
- `updateDataset(Stack stack, String datasetId, ...)`: データセット更新
- `deleteDataset(Stack stack, String datasetId)`: データセット削除
- `searchDatasets(Stack stack, ...)`: データセット検索

#### StackService
- `listAvailableStacks(Directory rootDirectory, {int? maxDepth})`: スタック検索
- `listAvailableAssetStacks(List<AssetStackManifest> stackManifest)`: アセットスタック取得

## 5. ベストプラクティス

### 5.1 スタック管理
- **適切な命名**: スタック名は目的を明確に表現する
- **メタデータ活用**: タグと説明を適切に設定してスタックを分類
- **定期的な整理**: 不要なスクラッチスタックは定期的に削除

### 5.2 データセット活用
- **論理的分割**: 大きなグラフは適切なデータセットに分割
- **自動管理**: 可能な限りフィルター条件による自動管理を活用
- **命名規則**: データセット名は内容を明確に表現

### 5.3 Riverpod統合
- **プロバイダー使用**: 直接サービスを呼ばず、プロバイダー経由でアクセス
- **非同期処理**: AsyncValueパターンでローディング・エラー状態を適切に処理
- **更新通知**: データ変更時は適切にトリガーを発火

### 5.4 パフォーマンス
- **遅延読み込み**: 大量のスタックがある場合は遅延読み込みを検討
- **キャッシュ活用**: 頻繁にアクセスするメタデータはキャッシュを活用
- **バッチ処理**: 複数のデータセット操作はまとめて実行

### 5.5 サムネイル画像の制限
- **ローカルファイル限定**: スタック内の`meta/`ディレクトリ内のローカルファイルのみをサポート
- **ネットワークURL禁止**: セキュリティとデータの完結性のため、ネットワークURLは使用不可
- **ファイル存在チェック**: 同期的なファイル存在確認でUI応答性を維持

## 6. 関連ドキュメント

- [スタック仕様書](../../../docs/specifications/stack/stack_specification.md) - スタックの詳細な技術仕様
- [スタック交換フォーマット仕様](../../../docs/specifications/stack/stack_exchange_format_specification.md) - インポート・エクスポート形式
- [core_graph パッケージ](../graph/README.md) - グラフデータベース管理
- [core_foundation パッケージ](../foundation/README.md) - 基盤機能

## 7. 依存関係

### 7.1 外部パッケージ
- `flutter_riverpod`: Riverpod状態管理フレームワーク
- `path`: ファイルパス操作
- `email_validator`: メールアドレス検証
- `freezed_annotation`, `json_annotation`: コード生成

### 7.2 内部パッケージ
- `core_foundation`: 基本ユーティリティ（FileSystemService, UniqueId等）
- `core_graph`: グラフデータベース（RinneGraph）連携
- `core_events`: イベント処理
