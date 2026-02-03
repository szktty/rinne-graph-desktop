# Core Undo Package

A comprehensive undo/redo system for App's graph database operations, built with Riverpod state management integration.

## Features

- **Complete Undo/Redo Support**: Full support for all graph operations (nodes, links, properties)
- **Command Pattern**: Clean, extensible command-based architecture
- **Memory Management**: Configurable memory limits with automatic history pruning
- **Command Merging**: Intelligent merging of similar operations to optimize history
- **Riverpod Integration**: Seamless integration with Riverpod providers and state management
- **UI Components**: Ready-to-use widgets for undo/redo functionality
- **Transaction Support**: Full compatibility with RinneGraph transactions
- **Event Streaming**: Real-time notifications of undo/redo operations

## Basic Usage

### Setting up the Undo System

```dart
import 'package:core_undo/undo.dart';
import 'package:riverpod/riverpod.dart';

// The undo system is automatically available through Riverpod providers
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef use) {
    final undoActions = use(undoActionsProvider);
    final executeCommand = use(executeCommandProvider);
    
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.undo),
          onPressed: undoActions.canUndo ? undoActions.undo : null,
        ),
        IconButton(
          icon: Icon(Icons.redo),
          onPressed: undoActions.canRedo ? undoActions.redo : null,
        ),
      ],
    );
  }
}
```

### Executing Undoable Commands

```dart
// Create a node with undo support
final command = CreateNodeCommand(
  nodeId: EntityId.generate(),
  labels: {'Person'},
  properties: {'name': 'Alice', 'age': 30},
);

await executeCommand(command);
```

### Using Built-in UI Components

```dart
import 'package:core_undo/undo.dart';

// Wrap your app with undo shortcuts
UndoShortcuts(
  child: MyApp(),
)

// Add undo/redo buttons
Row(
  children: [
    UndoButton(),
    RedoButton(),
    UndoHistoryIndicator(showDetails: true),
  ],
)
```

## Advanced Usage

### Creating Custom Commands

```dart
class MyCustomCommand extends NonMergeableCommand {
  @override
  String get id => 'my_custom_command';
  
  @override
  String get description => 'My custom operation';
  
  @override
  DateTime get timestamp => DateTime.now();
  
  @override
  Future<void> execute(GraphContext context) async {
    // Perform your operation
  }
  
  @override
  Future<void> undo(GraphContext context) async {
    // Reverse your operation
  }
  
  @override
  int get estimatedMemoryUsage => 1024; // bytes
}
```

### Mergeable Commands

```dart
class UpdatePropertyCommand extends MergeableCommand {
  final EntityId entityId;
  final String propertyName;
  final dynamic oldValue;
  final dynamic newValue;
  
  // ... constructor and basic methods ...
  
  @override
  bool canMergeWithSpecific(UndoableCommand other) {
    return other is UpdatePropertyCommand && 
           other.entityId == entityId &&
           other.propertyName == propertyName;
  }
  
  @override
  UndoableCommand? mergeWith(UndoableCommand other) {
    if (!canMergeWith(other) || other is! UpdatePropertyCommand) {
      return null;
    }
    
    return UpdatePropertyCommand(
      entityId: entityId,
      propertyName: propertyName,
      oldValue: oldValue, // Keep original old value
      newValue: other.newValue, // Use latest new value
      timestamp: other.timestamp,
    );
  }
}
```

### Bulk Operations

```dart
// Delete multiple entities atomically
final command = await BulkDeleteCommand.create(
  context,
  nodeIds: [node1.id, node2.id],
  linkIds: [link1.id],
);

await executeCommand(command);
```

### Configuration

```dart
// Configure undo system limits
UndoManager undoManager = UndoManager(
  graphContext: graphContext,
  maxHistorySize: 200,           // Maximum commands in history
  maxMemoryUsage: 100 * 1024 * 1024, // 100MB memory limit
);
```

## Available Commands

### Node Operations
- `CreateNodeCommand` - Create new nodes
- `UpdateNodeCommand` - Update node properties (mergeable)
- `DeleteNodeCommand` - Delete nodes with automatic link cleanup
- `AddNodeLabelCommand` - Add labels to nodes
- `RemoveNodeLabelCommand` - Remove labels from nodes

### Link Operations
- `CreateLinkCommand` - Create new links
- `UpdateLinkCommand` - Update link properties (mergeable)
- `DeleteLinkCommand` - Delete links
- `ChangeLinkTypeCommand` - Change link types

### Bulk Operations
- `BulkDeleteCommand` - Delete multiple entities atomically
- `BulkCreateCommand` - Create multiple entities atomically

## Riverpod Providers

### Core Providers
- `undoManagerProvider` - Provides the UndoManager instance
- `undoActionsProvider` - Provides undo/redo actions for UI
- `executeCommandProvider` - Function to execute undoable commands
- `undoHistoryProvider` - Current history state for UI display

### Utility Providers
- `undoHistoryChangesProvider` - Stream of history change events
- `undoExecutionStateProvider` - Whether an operation is currently executing
- `undoSettingsProvider` - Configuration settings

## UI Components

### Widgets
- `UndoShortcuts` - Adds keyboard shortcuts (Cmd/Ctrl+Z, Cmd/Ctrl+Shift+Z)
- `UndoButton` - Undo button with automatic state management
- `RedoButton` - Redo button with automatic state management  
- `UndoHistoryIndicator` - Shows current undo/redo state
- `UndoMenuIntegration` - Helper for menu bar integration

### Keyboard Shortcuts
- **Undo**: `Cmd+Z` (macOS) / `Ctrl+Z` (Windows/Linux)
- **Redo**: `Cmd+Shift+Z` or `Cmd+Y` (macOS) / `Ctrl+Shift+Z` or `Ctrl+Y` (Windows/Linux)

## Error Handling

The undo system provides comprehensive error handling:

```dart
try {
  await executeCommand(myCommand);
} on CommandExecutionException catch (e) {
  print('Command execution failed: ${e.message}');
  print('Failed command: ${e.command?.description}');
} on UndoExecutionException catch (e) {
  print('Undo operation failed: ${e.message}');
} on UndoLimitException catch (e) {
  print('Undo limit exceeded: ${e.limitType}');
}
```

## Memory Management

The undo system automatically manages memory usage:

- **Command Merging**: Similar commands executed within a time window are merged
- **History Pruning**: Old commands are automatically removed when limits are exceeded
- **Memory Estimation**: Commands provide memory usage estimates for accurate tracking
- **Configurable Limits**: Both history size and memory usage limits are configurable

## Testing

The package includes comprehensive test utilities:

```dart
import 'package:core_undo/undo.dart';

test('my undo test', () async {
  final undoManager = UndoManager(
    graphContext: mockContext,
    maxHistorySize: 10,
  );
  
  final command = MockCommand('test', 'Test command');
  
  await undoManager.execute(command);
  expect(undoManager.canUndo, isTrue);
  
  await undoManager.undo();
  expect(undoManager.canRedo, isTrue);
});
```

## Integration Notes

### With Graph Context
The undo system integrates seamlessly with RinneGraph's `GraphContext`:

```dart
// Commands automatically use the active graph context
final graphContext = use(graphContextProvider);
final executeCommand = use(executeCommandProvider);

// All operations go through the same graph context
await executeCommand(MyCommand());
```

### With Transactions
Commands can be wrapped in transactions for atomic operations:

```dart
class TransactionalCommand extends UndoableCommand {
  @override
  Future<void> execute(GraphContext context) async {
    await context.transaction((txContext) async {
      // Multiple operations in a single transaction
      await txContext.createNode(/* ... */);
      await txContext.createLink(/* ... */);
    });
  }
}
```

## Performance Considerations

- **Command Merging**: Enable for frequently updated properties (like position during drag)
- **Memory Limits**: Set appropriate limits based on your application's memory constraints
- **Bulk Operations**: Use bulk commands for operations on multiple entities
- **History Pruning**: The system automatically prunes old commands to stay within limits

## Future Enhancements

- History persistence across application sessions
- Selective undo (undo specific commands from history)
- Collaborative undo for multi-user scenarios
- Visual history timeline
- Undo branching for non-linear history