# Data Flow Concerns and Questions

This document lists potential issues, complexity hotspots, and areas that may cause regressions, identified through code analysis. These are not definitive problems but rather questions and items worth investigating. The analysis was performed statically — some concerns may be invalid once runtime behavior is considered.

---

## 1. Stack Creation Bypasses Core Services

**Observation**: `StackManagementService` (in `features_stack_management`) creates the stack directory structure, writes metadata files, and initializes the graph database directly, without delegating to `StackService` or `StackMetadataService` (in `core_stack_common`).

**Questions**:
- Is this intentional, or did the feature evolve independently from the core services?
- If `core_stack_common` services are updated (e.g., metadata format changes), will `features_stack_management` need to be updated separately?
- Could this lead to inconsistencies between stacks created by the UI vs. stacks created by import?

**Potential impact on modifications**: Changing the stack directory structure or metadata format may require updates in multiple locations that don't share code.

---

## 2. GraphContext Async Initialization Without Await

**Observation**: In `graphContextProvider` and `activeStackGraphStorageProvider`, `initialize()` is called asynchronously but not awaited. The provider returns the context/storage immediately.

**Questions**:
- Is there a race condition risk where the GraphContext is used before initialization completes?
- Does RinneGraph's internal implementation handle this gracefully (e.g., queuing operations until init completes)?
- Could this explain intermittent errors when switching stacks rapidly?

**Potential impact on modifications**: Adding new operations that run immediately after stack activation might fail silently if initialization hasn't completed.

---

## 3. EntitySelectionBridge as a Central Coordinator

**Observation**: `EntitySelectionBridge` (desktop app) listens to `activeStackProvider` changes and orchestrates graph loading, selection sync, and `activeGraphProvider` updates. It acts as an implicit coordinator between `core_stack_flutter` and `core_graph_flutter`.

**Questions**:
- Is it clear to future developers that this bridge is the mechanism connecting stack changes to graph state?
- Could the 100ms delay before loading the graph (observed in the code) mask a deeper timing issue between provider initializations?
- When adding new features that depend on both stack and graph state, is it obvious that they need to account for this bridge's behavior?

**Potential impact on modifications**: Changes to the stack activation flow may break graph loading if the bridge's listener assumptions are violated.

---

## 4. Provider Override in main.dart

**Observation**: `graphStorageProvider` is overridden in `main.dart` to delegate to `activeStackGraphStorageProvider`. This is the sole connection between stack selection and graph database access.

**Questions**:
- If `graphStorageProvider` is accessed before a stack is active, it throws `StateError`. Is this adequately handled in all code paths?
- Does this override make testing harder, since tests need to replicate the same override?
- Is the override relationship discoverable? A developer looking at `core_graph_flutter` wouldn't know about this override without reading `main.dart`.

**Potential impact on modifications**: Adding new providers that depend on `graphStorageProvider` may fail unexpectedly during startup or when no stack is loaded.

---

## 5. In-Memory Graph Object vs. Database State

**Observation**: `activeGraphProvider` holds a `Graph` object built by querying all nodes and links from the database. This is a separate copy from what's in RinneGraph's SQLite database. Pathfinder searches operate on this in-memory copy.

**Questions**:
- When a node/link is created, updated, or deleted via `GraphContext`, is the in-memory `Graph` object automatically updated?
- If not, could the search results become stale until the graph is reloaded?
- How large can this in-memory graph get, and is there a memory concern for stacks approaching the ~50,000 record guideline?

**Potential impact on modifications**: Adding features that read from `activeGraphProvider` (e.g., graph visualization) need to ensure they stay in sync with database state.

---

## 6. Auto-Save as a Conditional Gate

**Observation**: In `RecordEditorActions`, property updates are only persisted to the database if `autoSaveProvider` is true. When auto-save is off, changes exist only in `activeEntityProvider` state.

**Questions**:
- What triggers a manual save when auto-save is off? Is there a save button or confirmation flow?
- If the user switches stacks or activities while auto-save is off, are unsaved changes lost?
- Is the auto-save state per-stack or global?

**Potential impact on modifications**: Features that read entity data may see different results depending on whether auto-save is on or off.

---

## 7. Undo/Redo Link Restoration (Incomplete)

**Observation**: `DeleteNodeCommand` captures connected link snapshots for undo purposes, but the restoration of links on undo has TODO comments and may not be fully implemented.

**Questions**:
- If a node with links is deleted and then undone, are the links actually restored?
- Could this lead to orphaned link references in the graph?
- Does this affect the user's expectation of undo behavior?

**Potential impact on modifications**: Building features that depend on link integrity after undo operations may encounter unexpected state.

---

## 8. Multiple Path to the Same Operation

**Observation**: Some operations can be triggered through different code paths:
- Stack activation: via welcome screen callback, startup handler, or programmatic API
- Node creation: via record editor, import service, or direct GraphContext call
- Entity selection: via pathfinder, graph view click, or programmatic selection

**Questions**:
- Are all paths guaranteed to update the same set of providers and side effects?
- For example, does stack activation always update both `activeStackProvider` and `openStacksActionsProvider`?
- Is there a risk that a new feature adds a third entry point that misses a step?

**Potential impact on modifications**: Adding a new way to trigger an operation may inadvertently skip a side effect that other paths include.

---

## 9. Graph Cache Eviction Strategy

**Observation**: `GraphContext` maintains `_nodeCache` and `_linkCache` as HashMaps with a max size of ~1000 items. When full, FIFO eviction applies.

**Questions**:
- For stacks with many nodes, is FIFO the best eviction strategy? Frequently accessed nodes may get evicted and re-fetched.
- Does cache eviction interact with undo operations? If a node is evicted from cache, does undo still work correctly (presumably yes, since it uses snapshots)?
- Could the cache size limit become a performance bottleneck for large stacks?

**Potential impact on modifications**: Performance-sensitive features (e.g., batch operations, large imports) may need to consider cache behavior.

---

## 10. Export Not Implemented

**Observation**: `StackExchangeService.exportStackToJson()` and `exportStackToCsv()` return error results. Export is not yet implemented.

**Questions**:
- When export is implemented, will it need to account for the same data flow complexities as import (schema handling, property type conversion)?
- Should export read from the in-memory `Graph` object or query the database directly?

---

## 11. Theme Custom Serialization (Incomplete)

**Observation**: `AppThemeData.toJson()` and `fromJson()` are marked as TODO. Custom themes cannot be persisted across sessions.

**Questions**:
- If a user configures a custom theme, what happens on app restart?
- Does this affect only the "custom" theme option, or could it impact theme color type persistence?

---

## 12. Background Import Task Integration

**Observation**: `CsvImportIntegration._runBackgroundImportTask()` creates a `Task` object but has TODO comments about integration with the Riverpod task system. The task may not actually run in the background.

**Questions**:
- Does the background import path actually execute, or is it effectively dead code?
- If it does execute, does the created stack appear in the available stacks list automatically (via `refreshStacksTriggerProvider`)?

---

## Summary of Complexity Hotspots

These areas involve the most cross-package coordination and are most likely to cause regressions when modified:

| Area | Packages Involved | Risk |
|------|-------------------|------|
| Stack activation → graph loading | desktop, core_stack_flutter, core_graph_flutter, core_graph_common | Provider chain with async init and bridge coordination |
| Node CRUD with undo | features_record_editor, core_graph_flutter, core_graph_common, core_undo | Auto-save conditional, undo snapshot management, cache sync |
| Import → stack + graph creation | features_import_export, core_exchange, core_stack_flutter, core_graph_common | Bypasses normal UI creation flow, direct DB access |
| Theme propagation | core_themes, core_settings, desktop app | Deep Riverpod watch cascade, override in main.dart |
