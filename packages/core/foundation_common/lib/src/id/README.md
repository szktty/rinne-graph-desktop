# ID管理モジュール

このモジュールは、アプリケーション全体で一貫したID管理を提供します。
エンティティIDの生成、管理をサポートします。

## 主な機能

- 型安全なEntityIdクラス
- 複数のID生成方法（タイムスタンプベース、UUID、UUIDv7）
- Riverpodプロバイダーとの統合
- ID管理ユーティリティ

## 使用例

### 基本的なID生成

```dart
// タイムスタンプベースのID
final timestampId = IdGenerator.generateTimestampId();

// UUIDv7（時間順ソート可能）
final uuidV7 = IdGenerator.generateUuidV7();

// 型安全なEntityId
final entityId = EntityId('my-custom-id');
// または生成メソッド経由で
final generatedId = IdGenerator.uuidV7();
```

### Riverpodプロバイダーでの使用

```dart
// 基本的なID生成プロバイダー
final generateIdProvider = Provider<String>((ref) {
  return IdGenerator.generateTimestampId();
});

// UUIDv7生成プロバイダー
final generateUuidV7Provider = Provider<String>((ref) {
  return IdGenerator.generateUuidV7();
});

// IDファクトリプロバイダー
final entityIdFactoryProvider = Provider<EntityId Function()>((ref) {
  return () => IdGenerator.uuidV7();
});

// ID管理プロバイダー
final idCollectionManagerProvider = StateNotifierProvider<IdCollectionManager, Set<EntityId>>(
  (ref) => IdCollectionManager(),
);

class IdCollectionManager extends StateNotifier<Set<EntityId>> {
  IdCollectionManager() : super(<EntityId>{});
  
  void add(EntityId id) {
    state = {...state, id};
  }
  
  bool contains(EntityId id) {
    return state.contains(id);
  }
  
  void remove(EntityId id) {
    state = Set.from(state)..remove(id);
  }
}

// 使用例
class ExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(idCollectionManagerProvider.notifier);
    final ids = ref.watch(idCollectionManagerProvider);
    
    // IDの追加
    manager.add(EntityId('id1'));
    
    // IDの確認
    final hasId = manager.contains(EntityId('id1'));
    
    // IDの削除
    manager.remove(EntityId('id1'));
    
    return Container();
  }
}
```

### Identifiableインターフェースの実装

```dart
class Todo implements Identifiable {
  @override
  final EntityId id;
  final String title;
  final bool completed;
  
  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });
  
  // ファクトリメソッド
  factory Todo.create({
    required String title,
    bool completed = false,
  }) {
    return Todo(
      id: IdGenerator.uuidV7(),
      title: title,
      completed: completed,
    );
  }
}
```

## ベストプラクティス

1. **一貫したID生成方法を使用する**: アプリケーション全体で一貫したID生成方法を使用することで、デバッグやトラブルシューティングが容易になります。

2. **型安全性を活用する**: 文字列や整数の代わりに`EntityId`を使用し、型安全性を確保します。

3. **IDの用途に適した生成方法を選択する**:
   - 時間順にソートが必要な場合: `UUIDv7`
   - 単純な一意性が必要な場合: `UUID`（v4）
   - 人間が読みやすい形式が必要な場合: タイムスタンプベース

4. **Identifiableインターフェースを活用する**: エンティティクラスに`Identifiable`を実装することで、ID管理の一貫性を確保します。

## 関連モジュール

- IDつきウィジェットの実装は `presentation_components` パッケージの `identifiable_widget` モジュールを参照してください。
