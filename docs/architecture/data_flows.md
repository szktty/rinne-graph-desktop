# Data Flows

This document describes the main data flows across packages for major operations. AI agents should read this before modifying code that crosses package boundaries.

## 1. Stack Creation

```
User clicks "Create Stack"
    ↓
features_stack_management: StackManagementService.createNewStack()
    ├─ showStackCreationDialog() → StackCreationResult (name, savePath, description)
    ├─ _sanitizeFileName() (spaces → hyphens, special chars removed)
    ├─ Create directory structure: {path}/{name}.stack/{meta,data,datasets,filters,assets}/
    ├─ _createMetadataFiles() → writes meta/info.json, meta/settings.json
    └─ _createEmptyGraphDatabase() → rg.Graph.open() creates data/graph.db
```

**Packages involved**: `features_stack_management` → `rinne_graph` (external library)

Stack creation currently lives entirely in `features_stack_management`, creating filesystem and database directly without going through `core_stack_common` services.

## 2. Stack Discovery & Loading

```
App startup OR welcome screen
    ↓
core_stack_flutter: availableStacksListProvider
    ├─ Watches refreshStacksTriggerProvider
    ├─ Gets search directory: stackSearchDirectoryProvider → ~/Documents/App/Stacks/
    ├─ core_stack_flutter: StackService.listAvailableStacks(searchDir)
    │   ├─ core_stack_common: StackLocatorService finds .stack directories (maxDepth: 5)
    │   └─ core_stack_common: StackMetadataService.loadMetadata(stackDir)
    │       ├─ Reads meta/info.json → StackInfo
    │       └─ Reads meta/settings.json → StackSettings
    ├─ _validateStack() for each discovered stack
    └─ Excludes archived stacks (settings.customFields['isArchived'])
    ↓
Returns List<Stack>
```

## 3. Stack Opening (Activation)

When a stack is selected (from welcome screen or startup):

```
UI: onStackSelected callback
    ↓
core_stack_flutter: activeStackProvider.notifier.setStack(stack)  [keepAlive: true]
    ↓ (triggers watchers)
desktop app: activeStackGraphStorageProvider
    ├─ Watches activeStackProvider
    ├─ Constructs path: {stack.directory.path}/data/graph.db
    ├─ Creates RinneGraphStorage(graphDbPath)
    ├─ Calls storage.initialize() (async)
    └─ On dispose: storage.close()
    ↓
core_graph_flutter: graphStorageProvider (overridden at app startup in main.dart)
    └─ Returns activeStackGraphStorageProvider value
    ↓
core_graph_flutter: graphContextProvider
    ├─ Creates GraphContext(storage: storage)
    ├─ Calls context.initialize()
    └─ On dispose: context.close()
    ↓
desktop app: EntitySelectionBridge (listens to activeStackProvider)
    ├─ Queries graphContext for all nodes and links
    ├─ Builds Graph object
    └─ core_graph_flutter: activeGraphProvider.notifier.setGraph(graph)
```

**Packages involved**: `desktop app` → `core_stack_flutter` → `core_graph_flutter` → `core_graph_common` → `rinne_graph`

**Provider override in main.dart** (critical):
```dart
graphStorageProvider.overrideWith((ref) {
    return ref.watch(activeStackGraphStorageProvider) ??
           (throw StateError('No active stack graph storage'));
})
```

Also tracked in `desktop app`:
```
openStacksActionsProvider.notifier.addStack(stack)  // tab management
selectedActivityItemProvider → AppActivityItemType.lens  // switch to graph view
```

## 4. Node Creation

```
UI: RecordEditor (features_record_editor)
    ↓
features_record_editor: RecordEditorActions.addProperty()
    ├─ activeEntityProvider.notifier.addProperty(name, type)
    └─ propertyOrderProvider.notifier.addProperty()
    ↓ (if auto-save enabled)
core_graph_flutter: NodeOperations.createNode(description, properties, labels)
    ↓
core_graph_common: GraphContext.createNode()
    ├─ Delegates to storage.createNode()
    └─ Caches result in _nodeCache (HashMap, max 1000)
    ↓
core_graph_common: RinneGraphStorage.createNode()
    └─ _graph!.transaction((txn) async {
         ├─ Generate EntityId
         ├─ Build properties: app_id, app_type, app_created_at, app_updated_at + user properties
         ├─ txn.createVertex(Vertex(labels, properties))
         └─ Convert RinneGraph Vertex → Node
       })
```

**Undo integration** (optional):
```
core_undo: UndoManager.execute(CreateNodeCommand)
    ├─ command.execute(graphContext) → same createNode flow
    ├─ Add to _undoStack
    └─ Emit CommandExecuted event
```

## 5. Node Update

```
UI: PropertyEditor (features_record_editor)
    ↓
features_record_editor: RecordEditorActions.updateProperty(name, value)
    ↓ (if auto-save enabled)
    activeEntityProvider.notifier.updateProperty() → state = state.withProperty(name, value)
    ↓
core_graph_flutter: NodeOperations.updateNode(node)
    ↓
core_graph_common: GraphContext.updateNode(node)
    ├─ storage.updateNode(node)
    └─ _cacheNode(node)
    ↓
core_graph_common: RinneGraphStorage.updateNode()
    └─ _graph!.transaction((txn) async {
         ├─ Find vertex by app_id via traversal: g.V().hasKey('app_id', node.id.value)
         ├─ Update properties + app_updated_at timestamp
         └─ Update vertex
       })
```

**Undo merging**: `UpdateNodeCommand` merges consecutive updates to same node within 2-second window.

## 6. Node Deletion (with cascade)

```
UI: Delete button
    ↓
core_undo: DeleteNodeCommand.create()
    ├─ Fetches node from context
    ├─ Creates NodeSnapshot (all properties, labels, timestamps)
    └─ Queries connected links (for undo restoration)
    ↓
core_graph_common: GraphContext.deleteNode(id)
    ├─ storage.deleteNode(id)
    └─ Remove from _nodeCache
    ↓
core_graph_common: RinneGraphStorage.deleteNode()
    └─ _graph!.transaction((txn) async {
         ├─ Find vertex by app_id
         ├─ Query all connected edges: g.V([vertex.id!]).bothE()
         ├─ Delete each edge (cascade)
         └─ Delete vertex
       })
```

## 7. Link Creation / Update / Deletion

Follows the same pattern as node operations:
```
UI → core_graph_flutter: LinkOperations → core_graph_common: GraphContext → RinneGraphStorage
```
- `createLink(sourceId, targetId, type, description, properties)`
- `updateLink(link)` — same transaction pattern
- `deleteLink(linkId)` — no cascade needed

## 8. Search (Pathfinder)

```
UI: Pathfinder search field (features_pathfinder)
    ↓
features_pathfinder: pathfinderSearchQueryProvider.setSearchQuery(query)
    ↓ (computed)
features_pathfinder: searchEntities provider
    ├─ Watches pathfinderActiveGraphProvider (in-memory Graph object)
    ├─ Watches entitySearchServiceProvider
    └─ Calls searchService.searchEntities(activeGraph, query)
    ↓
features_pathfinder: EntitySearchService.searchEntities()
    ├─ Linear scan of graph.nodes.values
    │   ├─ Case-insensitive substring match on: description.type, all property values, node ID
    │   └─ Extract display name from 'name' or 'title' property
    ├─ Same for graph.links.values
    └─ Returns combined results (limit 20)
    ↓
features_pathfinder: PathfinderActions.executeSelectedItem()
    ├─ Add to recent items
    └─ Set selectedEntityIdProvider → triggers entity display
```

**Note**: Search operates entirely in-memory on the `activeGraph` object — no database queries.

## 9. Import (CSV/JSON)

```
UI: Import trigger (features_import_export)
    ↓
features_import_export: CsvImportIntegration.handleCsvImport()
    ├─ File picker dialog → CSV file path
    ├─ Stack name dialog → name input
    └─ Import mode dialog → foreground vs background
    ↓
features_import_export: CsvImportService.importCsvToStack()
    ├─ Read CSV file (UTF-8)
    ├─ Parse: CsvToListConverter().convert(contents)
    ├─ Create stack: stackActions.createCustomStack()
    ├─ Create RinneGraphStorage at {stack}/data/graph.db
    ├─ Initialize GraphContext
    └─ For each CSV row:
       ├─ Build properties map from columns
       └─ graphContext.createNode(description, properties)
```

JSON import uses `core_exchange: JsonConverter.importFromJson()`:
```
JsonConverter.convertFromJson()
    ├─ jsonDecode() → Map
    ├─ Process nodes: jsonData['nodes'] or jsonData['entities']
    │   └─ SchemaProcessor.processNodeData() → graphContext.createNode()
    └─ Process links: jsonData['links'] or jsonData['edges']
        └─ SchemaProcessor.processLinkData() → graphContext.createLink()
```

## 10. UI Shell & Activity Switching

```
MainAppShell (desktop app, ConsumerWidget)
    ├─ Watches: activityBarStateProvider, activeStackProvider, sidebar states
    ├─ Initializes: EntitySelectionBridge, ActivityBarChangeListener
    ├─ Schedules: StartupHandler (via addPostFrameCallback)
    └─ Build:
       ├─ If activeStack == null → WelcomeScreenContent
       └─ If activeStack != null → MainShellLayout
          ├─ activityBar: ActivityBarBuilder → AppActivityBar
          ├─ primarySidebar: SidebarBuilder (per activity type)
          ├─ secondarySidebar: SidebarBuilder (per activity type)
          └─ content: ContentBuilder (per activity type)

Activity switching:
    activityBarStateProvider.setIndex(newIndex)
        ↓
    ActivityBarChangeListener
        ├─ Load screen state for new activity
        └─ Update secondarySidebarStateProvider
        ↓
    MainAppShell rebuild → SidebarBuilder/ContentBuilder select new widgets
```

## 11. Theme Change Propagation

```
User selects theme (features_settings)
    ↓
core_themes: activeThemeProvider.notifier.setTheme(newTheme)
    ├─ State update (immediate)
    └─ Async: save to settingsStorageService 'active_theme_name'
    ↓ (cascade via Riverpod watch)
core_themes: effectiveColorSchemeWithThemeProvider rebuilds
    ├─ Reads: activeThemeProvider (new)
    ├─ Reads: platformBrightnessProvider
    └─ Reads: themeColorTypeProvider
    ↓
core_themes: effectiveThemeDataProvider rebuilds
    ↓
core_themes: effectiveFlutterColorSchemeProvider rebuilds
    ↓
desktop app: _AppMaterialApp rebuilds with new theme
    └─ MaterialApp theme property updated → all widgets using theme rebuild
```

System theme change follows the same cascade, triggered from `platformBrightnessProvider`.

## Provider Dependency Summary

```
                    ┌─ activeStackProvider ─────────────────────┐
                    │                                           ↓
                    ↓                              EntitySelectionBridge
      activeStackGraphStorageProvider                    │
                    │                                   ↓
                    ↓                           activeGraphProvider
            graphStorageProvider                         │
            (overridden in main.dart)                   ↓
                    │                     selectedEntityIdProvider
                    ↓                              │
           graphContextProvider                    ↓
            │           │                  selectedEntity
            ↓           ↓
    NodeOperations  LinkOperations
            │           │
            ↓           ↓
    RinneGraphStorage (SQLite)
```
