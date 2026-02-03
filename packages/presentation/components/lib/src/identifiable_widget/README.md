# IDつきウィジェットモジュール

このモジュールは、`core_foundation`パッケージの`EntityId`を活用して、一意のIDを持つウィジェットコンポーネントを作成・管理するための機能を提供します。

## 主な機能

- `IdentifiableWidget`: IDを持つウィジェットの基底クラス
- `IdentifiableEntityWidget`: IDを持つエンティティを表示するウィジェットの基底クラス
- `widgetIdManagerProvider`: ウィジェットIDを管理するためのプロバイダー
- `widgetSelectionManagerProvider`: 選択可能なウィジェットの選択状態を管理するプロバイダー

## 使用例

### IDつきウィジェットの実装

```dart
// エンティティクラスの定義
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

// IDつきウィジェットの実装
class TodoItem extends IdentifiableEntityWidget<Todo> {
  const TodoItem({
    required super.entity,
    super.key,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(entity.title),
      leading: Checkbox(
        value: entity.completed,
        onChanged: (value) {
          // 状態更新ロジック
        },
      ),
    );
  }
}

// 使用例
class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosListProvider);
  
    return ListView(
      children: [
        for (final todo in todos)
          TodoItem(entity: todo),
      ],
    );
  }
}
```

### 選択可能なウィジェット

```dart
class SelectableTodoItem extends IdentifiableEntityWidget<Todo> {
  const SelectableTodoItem({
    required super.entity,
    super.key,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 選択管理プロバイダーからデータを取得
    final selectionManager = ref.watch(widgetSelectionManagerProvider);
    final isSelected = selectionManager.isSelected(id);
    
    return ListTile(
      title: Text(entity.title),
      selected: isSelected,
      onTap: () => ref.read(widgetSelectionManagerProvider.notifier).toggleSelection(id),
      leading: Checkbox(
        value: entity.completed,
        onChanged: (value) {
          // 状態更新ロジック
        },
      ),
    );
  }
}
```

### ウィジェットIDの管理

```dart
class WidgetContainer extends ConsumerWidget {
  const WidgetContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ウィジェットID管理プロバイダーからデータを取得
    final manager = ref.watch(widgetIdManagerProvider);
  
    // 新しいエンティティを作成してIDを追加
    void addNewItem() {
      final newTodo = Todo.create(title: 'New Task');
      ref.read(widgetIdManagerProvider.notifier).add(newTodo.id);
    }
  
    return Column(
      children: [
        ElevatedButton(
          onPressed: addNewItem,
          child: const Text('Add New Item'),
        ),
        for (final id in manager.ids)
          // IDに対応するエンティティを取得して表示
          ItemWidget(key: ValueKey(id.value), id: id),
      ],
    );
  }
}
```

## ベストプラクティス

1. **ウィジェット識別の一貫性**: `IdentifiableWidget`を使用して、ウィジェットに一意のIDを持たせることで、リストやグリッド内の要素を一貫して識別できます。

2. **パフォーマンス最適化**: `ValueKey`を使用して、IDに基づいたウィジェットの最適なリビルドを実現します。

3. **選択状態の分離**: 表示と選択状態を分離するため、`widgetSelectionManagerProvider`を使用します。

4. **コンポーネントの再利用**: IDをベースにした汎用コンポーネントを設計することで、異なるデータ型間でも一貫したUIを提供できます。

5. **リスト操作の効率化**: `widgetIdManagerProvider`を使用して、リストの並べ替え、フィルタリング、ページングを効率的に実装します。
