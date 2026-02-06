# Stack API Architecture and Usage Guide

## 1. Overview

This document provides a comprehensive guide to the architecture of the Stack-related APIs in the RinneGraph project. As of the current implementation, the APIs for managing Stacks are distributed across several packages. Understanding the role of each package is crucial for performing stack-related operations correctly.

## 2. Core Packages and Their Responsibilities

The functionality for managing stacks is primarily divided into three core packages:

-   `packages/core/graph_common`
-   `packages/core/stack_common`
-   `packages/core/stack_flutter`

### 2.1 `packages/core/graph_common`

-   **Responsibility**: Manages the lifecycle and operations of the graph database itself (`graph.db`).
-   **Key APIs**:
    -   `DatabaseCreator`: Used to create a new, empty `graph.db` file.
    -   `GraphContext`: The main interface for interacting with an opened graph database (e.g., adding nodes, querying).
    -   `RinneGraphStorage`: The storage backend that connects to the SQLite-based `graph.db` file.
-   **Usage Context**: Use this package when you need to perform CRUD operations on the graph data *within* a stack.

### 2.2 `packages/core/stack_common`

-   **Responsibility**: Manages the directory structure and metadata of a stack (`info.json`, `settings.json`). It acts as the high-level service for stack lifecycle events like creation and discovery.
-   **Key APIs**:
    -   `StackService`:
        -   `createStack(name)`: Creates the full `.stack` directory structure, initializes `info.json` and `settings.json`, and, crucially, calls `DatabaseCreator` from `core_graph_common` to create an empty `graph.db`.
        -   `updateStack(stack)`: Saves changes to a stack's metadata (`info.json`, `settings.json`).
        -   `listAvailableStacks()`: Discovers all valid `.stack` directories within a root directory.
    -   `StackMetadataService`: Lower-level service specifically for reading and writing `info.json` and `settings.json`.
-   **Usage Context**: Use this package as the primary entry point for creating, finding, or updating stack metadata.

### 2.3 `packages/core/stack_flutter`

-   **Responsibility**: Provides Flutter-specific implementations and integrates the common services with the UI layer using Riverpod providers.
-   **Key APIs**:
    -   `stack_providers.dart`:
        -   `availableStacksListProvider`: Provides the UI with a list of available, non-archived stacks.
        -   `activeStackProvider`: Manages the currently selected stack across the application.
        -   `StackActions`: A provider that exposes methods for UI-driven actions like creating a sample stack.
    -   Flutter-specific services like `AssetStackLocatorService`.
-   **Usage Context**: Use this package to interact with stack data from within the Flutter UI. The providers here are the bridge between the UI and the underlying `StackService` and `GraphContext`.

## 3. How to Perform Common Operations

### 3.1 Creating a New Stack

1.  **Get the `StackService`**: Obtain an instance of `StackService` from the `core_stack_common` package.
2.  **Call `createStack()`**:
    ```dart
    final stackService = StackService();
    final baseDirectory = await getApplicationDocumentsDirectory(); // Or another directory
    final newStack = await stackService.createStack(baseDirectory, 'MyNewStack');
    ```
3.  **Result**: This operation creates the `MyNewStack.stack` directory, populates it with default metadata files, and creates an initialized, empty `graph.db`.

### 3.2 Opening a Stack and Accessing its Graph

1.  **Find the Stack**: Use `StackService.listAvailableStacks()` to get a `Stack` object.
2.  **Get the Database Path**: The `Stack` object has a `path` property that points to the `graph.db` file.
3.  **Create a `GraphContext`**: Use the `GraphContext` from `core_graph_common` with a `RinneGraphStorage` backend to open a connection to the database.

    ```dart
    // 1. Find the stack
    final stack = await stackService.listAvailableStacks(searchDir).first;

    // 2. Get the path
    final dbPath = stack.path;

    // 3. Open the graph context
    if (dbPath != null) {
      final storage = RinneGraphStorage(dbPath);
      final graphContext = GraphContext(storage: storage);
      await graphContext.open();

      // Now you can use graphContext to query nodes, add links, etc.
      // ...

      await graphContext.close();
    }
    ```

### 3.3 Updating Stack Metadata

1.  **Get a `Stack` object**: From a provider or by listing stacks.
2.  **Modify the `StackInfo` or `StackSettings`**: Use the `copyWith` methods on the `info` or `settings` properties of the `Stack` object.
    ```dart
    final updatedStack = stack.copyWith(
      info: stack.info.copyWith(name: 'My Renamed Stack'),
    );
    ```
3.  **Call `updateStack()`**: Use the `StackService` to persist the changes.
    ```dart
    final stackService = StackService();
    await stackService.updateStack(updatedStack);
    ```

## 4. Future Direction: A Unified StackManager

The current, distributed nature of the APIs requires developers to understand the responsibilities of multiple packages. A potential future improvement is to introduce a higher-level **`StackManager`** service.

This service would act as a single facade, providing a unified API for all stack operations and managing the underlying services from `core_stack_common` and `core_graph_common` internally.

**Example of a unified API:**

```dart
// Hypothetical Future API
final stackManager = StackManager();

// Create and open a stack in one go
final activeGraphContext = await stackManager.createAndOpenStack('MyNewStack');

// Add a node
await activeGraphContext.addNode(Node(...));

// Close the stack
await stackManager.closeStack(activeGraphContext);
```

This would simplify development and reduce the cognitive load of working with Stacks. This documentation serves as the first step toward clarifying the current architecture and motivating this future improvement.
