# Keyword Search UI Implementation Plan

**Date**: 2026-03-26 / Updated: 2026-03-27
**Status**: Session 2 Complete (Sessions 1 and 2 done)

---

## Background

### Why this task exists

RinneGraph needs "bring your data and explore it" as the minimum viable experience for alpha.
The two blockers are:

1. **Import** — users can't bring external data in yet (CSV import has a TODO in background task integration)
2. **Search** — even after importing, there's no usable UI to find nodes/links

This plan addresses both, with search UI as the primary focus.

### Design decisions made

After discussion on 2026-03-26:

- **Alpha scope = Keyword Search only.** Path Search UI is deferred — it will be hidden/commented out, not deleted, so it can be restored later.
- **No `searchModeProvider` toggle** — since Path Search is deferred, keyword mode is the only mode. The toggle will be added when Path Search is actually implemented.
- **Highlight vs hide**: default is highlight (dim non-hits). Hide mode (filter) is reserved for the "Open as Subgraph View" action.
- **Subgraph View** (Phase 5 in the original design doc) is also deferred for alpha.
- **Path Search reasoning**: the visual pattern-input UI (Node→Link→Node tiles) is understood at a design level but the implementation is non-trivial. Deferring removes the blocker without losing the design work.

---

## Implementation Progress

### Session 1 — COMPLETED (2026-03-26, branch: feature/keyword-search-ui)

- **Step 1**: Added keyword search providers to `search_providers.dart`:
  - `KeywordSearchQuery`, `KeywordSearchFiltersState`, `KeywordSearchResult`, `KeywordSearchExecuting`
  - `availableNodeLabelsProvider`, `availableLinkTypesProvider` (FutureProvider)
  - `KeywordSearchActions` (executeSearch with client-side filter, clearSearch)
  - Path Search providers kept intact
- **Step 2**: Replaced `_SearchTabContent` in `graph_navigator_sidebar.dart`:
  - Old Path Search UI fully commented out at bottom of file
  - New widgets: `_KeywordSearchField`, `_SearchFilterChips`, `_SearchEmptyHint`, `_SearchExecutingIndicator`, `_SearchErrorBanner`, `_SearchResultList`, `_SearchResultFooter`
  - Node tap → `selectionStateProvider.selectEntity()`
  - Link tap → `selectionStateProvider.selectEntity()`

**Key fix vs. plan**: `Node.labels` is `Set<String>` (not `.label`); `Link.type` is `String`. Filter logic updated accordingly.

---

### Session 2 — COMPLETED (2026-03-27, branch: feature/keyword-search-ui)

**Focus**: Secondary sidebar shows TabbedRecordEditor on entity selection; title bar open button.

#### Changes made

**Commit `6ae4fac`**: "Show TabbedRecordEditor in secondary sidebar on entity selection"

1. **`packages/presentation/components/lib/src/details_pane/details_pane.dart`**
   - Removed `GraphEntityPropertiesDisplay` branch (and its `core_graph_flutter` import)
   - Always shows `TabbedRecordEditor` when `selectedEntity != null`
   - Shows placeholder text when no entity is selected

2. **`apps/desktop/lib/src/widgets/main_app_shell.dart`**
   - Converted `MainAppShell` from `ConsumerWidget` → `ConsumerStatefulWidget`
   - Added `FondeSecondarySidebarController _secondarySidebarController` held in state
   - Implemented **bidirectional sync**:
     - Riverpod → controller: `ref.listen<bool>(secondarySidebarStateProvider, ...)` in `build()`
     - Controller → Riverpod: `_onControllerChanged()` listener in `initState()`
   - Passed `secondarySidebarController: _secondarySidebarController` to `FondeScaffold`
   - Added `FondeMainToolbar(trailing: const _SecondarySidebarToggleButton())`
   - Added `_SecondarySidebarToggleButton` widget class at bottom of file:
     - Reads `secondarySidebarStateProvider` — returns `SizedBox.shrink()` when sidebar is open
     - `ExcludeFocus` wrapper to prevent focus
     - `SizedBox(width: 28, height: 28)` for proper icon sizing
     - Calls both `FondeSidebarControllerScope.secondaryOf(context)?.show()` AND `screenBasedSecondarySidebarStateProvider.notifier.show()` on press

#### Key architectural insight

`FondeScaffold` uses `ChangeNotifier`-based `FondeSecondarySidebarController` independently of Riverpod. The close button inside `FondeSecondarySidebarToolbar` calls `controller.hide()` directly, bypassing Riverpod. Without the bidirectional sync, the Riverpod state (`secondarySidebarStateProvider`) stayed `true` after the sidebar was closed — causing the open button to remain hidden.

**Solution**: hold controller in `ConsumerStatefulWidget` state, sync changes in both directions.

---

## Current State

### What works today

- Sample stack loads and graph renders
- Tapping a node shows properties in the right sidebar
- `SearchExecutionService.executeKeywordSearch()` is fully implemented
- `SearchExecutionService.getAvailableLabelsAndTypes()` exists (calls `getNodeLabels()` / `getLinkTypes()`)
- `SearchResultState`, `SearchExecuting`, `SearchError` providers exist in `search_providers.dart`

### What the current Search tab shows

`graph_navigator_sidebar.dart` → `_SearchTabContent`:

- A keyword field at the top with `// TODO: Implement keyword search` — not wired up
- "Exploration Options" collapsible (Depth dropdown, Max Results label) — works but belongs to Path Search
- "Advanced Search" section with Node/Link pattern tiles — the Path Search UI, partially implemented
- "Execute Search" button — calls `executeSearch()` which runs `executePatternSearch()` (Path Search only)
- Results shown as a plain text box (node count, link count, execution time)

### Missing providers (per design doc)

| Provider | Status |
|---|---|
| `keywordSearchQueryProvider` | ❌ not created |
| `keywordSearchFiltersProvider` | ❌ not created |
| `keywordSearchResultProvider` | ❌ not created |
| `keywordSearchExecutingProvider` | ❌ not created |
| `availableNodeLabelsProvider` | ❌ not created |
| `availableLinkTypesProvider` | ❌ not created |
| `searchHighlightProvider` | ❌ not created |
| `searchFocusTargetProvider` | ❌ not created |

---

## Implementation Plan

### Session 1 — Providers + Keyword Search UI

**Goal**: keyword search is fully functional in the sidebar. No graph view integration yet.

**Build rule**: edit one file → `cd apps/desktop && flutter build macos` → proceed.

#### Step 1: Add keyword search providers to `search_providers.dart`

File: `apps/desktop/lib/src/providers/search_providers.dart`

Add the following providers. Do NOT remove existing Path Search providers
(`SearchPatternState`, `ExplorationOptionsState`, `SearchActions`) — they will be needed when Path Search is restored.

```dart
// Keyword search input text
@riverpod
class KeywordSearchQuery extends _$KeywordSearchQuery {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
  void clear() => state = '';
}

// Label/type filter state for keyword search
class KeywordSearchFilters {
  final Set<String> nodeLabels; // empty = all
  final Set<String> linkTypes;  // empty = all
  const KeywordSearchFilters({
    this.nodeLabels = const {},
    this.linkTypes = const {},
  });
  KeywordSearchFilters copyWith({Set<String>? nodeLabels, Set<String>? linkTypes}) =>
      KeywordSearchFilters(
        nodeLabels: nodeLabels ?? this.nodeLabels,
        linkTypes: linkTypes ?? this.linkTypes,
      );
}

@riverpod
class KeywordSearchFiltersState extends _$KeywordSearchFiltersState {
  @override
  KeywordSearchFilters build() => const KeywordSearchFilters();
  void toggleNodeLabel(String label) { ... }
  void toggleLinkType(String type) { ... }
  void clear() => state = const KeywordSearchFilters();
}

// Keyword search result (separate from Path Search result)
@riverpod
class KeywordSearchResult extends _$KeywordSearchResult {
  @override
  SearchResult? build() => null;
  void setResult(SearchResult? result) => state = result;
  void clear() => state = null;
}

// Keyword search executing flag (separate from Path Search)
@riverpod
class KeywordSearchExecuting extends _$KeywordSearchExecuting {
  @override
  bool build() => false;
  void start() => state = true;
  void stop() => state = false;
}

// Available node labels from real graph data
@riverpod
Future<List<String>> availableNodeLabels(Ref ref) async {
  final service = ref.watch(searchExecutionServiceProvider);
  if (service == null) return [];
  final data = await service.getAvailableLabelsAndTypes();
  return (data['nodeLabels'] as List).cast<String>();
}

// Available link types from real graph data
@riverpod
Future<List<String>> availableLinkTypes(Ref ref) async {
  final service = ref.watch(searchExecutionServiceProvider);
  if (service == null) return [];
  final data = await service.getAvailableLabelsAndTypes();
  return (data['linkTypes'] as List).cast<String>();
}

// Keyword search action
@riverpod
class KeywordSearchActions extends _$KeywordSearchActions {
  @override
  void build() {}

  Future<void> executeSearch() async {
    final service = ref.read(searchExecutionServiceProvider);
    final query = ref.read(keywordSearchQueryProvider);
    final filters = ref.read(keywordSearchFiltersStateProvider);

    if (service == null) return;
    if (query.trim().isEmpty) return;

    ref.read(keywordSearchExecutingProvider.notifier).start();
    try {
      // Base keyword search
      final result = await service.executeKeywordSearch(
        keyword: query,
        options: const ExplorationOptions(maxResults: 200),
      );

      // Apply label/type filters client-side if any are selected
      final filteredNodes = filters.nodeLabels.isEmpty
          ? result.nodes
          : result.nodes.where((n) => filters.nodeLabels.contains(n.label)).toList();
      final filteredLinks = filters.linkTypes.isEmpty
          ? result.links
          : result.links.where((l) => filters.linkTypes.contains(l.label)).toList();

      ref.read(keywordSearchResultProvider.notifier).setResult(SearchResult(
        nodes: filteredNodes,
        links: filteredLinks,
        totalNodeCount: filteredNodes.length,
        totalLinkCount: filteredLinks.length,
        executionTime: result.executionTime,
      ));
    } catch (e) {
      // reuse existing SearchError provider
      ref.read(searchErrorProvider.notifier).setError(e.toString());
    } finally {
      ref.read(keywordSearchExecutingProvider.notifier).stop();
    }
  }

  void clearSearch() {
    ref.read(keywordSearchQueryProvider.notifier).clear();
    ref.read(keywordSearchResultProvider.notifier).clear();
    ref.read(keywordSearchFiltersStateProvider.notifier).clear();
    ref.read(searchErrorProvider.notifier).clearError();
  }
}
```

After editing → `flutter build macos` → run `melos run gen:all` first (new @riverpod classes).

#### Step 2: Replace `_SearchTabContent` in `graph_navigator_sidebar.dart`

File: `apps/desktop/lib/src/widgets/graph_navigator_sidebar.dart`

**What to do**:
- Comment out the entire body of `_SearchTabContentState.build()` that renders Exploration Options, Advanced Search, pattern tiles, and Execute Search button. Keep the code — do not delete.
- Replace with new keyword-mode UI widgets (see below).

**New widget structure inside `_SearchTabContent`**:

```
Column
├── _KeywordSearchField        ← text input, onSubmitted triggers search
├── _SearchFilterChips         ← horizontal scroll, node labels + link types
├── [empty state / executing / results]
│   ├── if empty: "Enter a keyword to search" hint text
│   ├── if executing: static indicator + "Searching..."
│   └── if result: _SearchResultList (Expanded + scrollable)
└── _SearchResultFooter        ← "N nodes, M links (Xms)" + clear button
                                  only shown when result != null
```

**`_SearchFilterChips`**:
- Reads `availableNodeLabelsProvider` and `availableLinkTypesProvider` (FutureProvider — show nothing while loading)
- First chip: `[All]` — clears all filter selections
- Node label chips: colored with `appColorScheme.appSpecific.graph.nodeBase`
- Link type chips: grey, prefixed with `→`
- Selected chip = filled; unselected = outlined

**`_SearchResultList`**:
- Two sections: `Nodes (N)` and `Links (M)`
- Each node row: circle icon + node label/ID + label chip — single tap selects in graph (connect to `selectionStateProvider`)
- Each link row: arrow icon + link type + "from → to" — single tap selects
- Double tap: scroll & focus in graph view (deferred to Session 2 — wire up stub for now)

**`_SearchResultFooter`**:
- Text: `"N nodes, M links  (Xms)"`
- "Clear" text button on the right

Build after completing Step 2.

---

### Session 3 — Graph View Integration (Highlight) [NEXT]

**Goal**: search results dim non-matching nodes/links in the graph view.

#### Step 3: Add `searchHighlightProvider` to `search_providers.dart`

```dart
class SearchHighlight {
  final Set<EntityId> nodeIds;
  final Set<EntityId> linkIds;
  const SearchHighlight({required this.nodeIds, required this.linkIds});
  bool get isEmpty => nodeIds.isEmpty && linkIds.isEmpty;
}

@riverpod
class SearchHighlightState extends _$SearchHighlightState {
  @override
  SearchHighlight? build() => null;
  void setHighlight(SearchHighlight highlight) => state = highlight;
  void clear() => state = null;
}
```

Wire up: after `KeywordSearchActions.executeSearch()` sets result, also call:
```dart
ref.read(searchHighlightStateProvider.notifier).setHighlight(
  SearchHighlight(
    nodeIds: result.nodes.map((n) => n.id).toSet(),
    linkIds: result.links.map((l) => l.id).toSet(),
  ),
);
```
And clear on `clearSearch()`.

#### Step 4: Add `searchFocusTargetProvider` to `search_providers.dart`

```dart
@riverpod
class SearchFocusTarget extends _$SearchFocusTarget {
  @override
  EntityId? build() => null;
  void focus(EntityId id) => state = id;
  void clear() => state = null;
}
```

#### Step 5: `AppNodeRenderer` — dim non-highlighted nodes

File: locate via `grep -r "AppNodeRenderer" apps/desktop/lib/ --include="*.dart" -l`

- Watch `searchHighlightStateProvider`
- If highlight is non-null and node's id is NOT in `highlight.nodeIds`, render node at reduced opacity (e.g. `0.25`)
- If highlight is null, render normally

Build after this step.

#### Step 6: `AppGraphView` — focus scroll on double tap

File: locate via `grep -r "AppGraphView" apps/desktop/lib/ --include="*.dart" -l`

- Watch `searchFocusTargetProvider`
- When value changes (non-null), animate `TransformationController` to center on the target node's position

Wire up double-tap in `_SearchResultList` items to call `ref.read(searchFocusTargetProvider.notifier).focus(entityId)`.

Build after this step.

---

### Session 4 — CSV Import Background Task TODO

**Goal**: the background import path in `csv_import_service.dart` actually works.

File: `packages/features/import_export/lib/src/services/csv_import_service.dart`

Look for `_runBackgroundImportTask()` with TODO comment. The fix is to integrate with whatever task/progress mechanism the app uses (check `packages/core/workflow/` or existing foreground import path for the pattern).

This session is **independent** of Sessions 1–2 and can be done in any order.

---

## Deferred Items (Post-Alpha)

| Item | Why deferred |
|---|---|
| Path Search UI | Design understood but implementation non-trivial; alpha doesn't need it |
| Subgraph View ("Open as Subgraph View") | Depends on Navigation tab dataset model; not needed for basic explore flow |
| `searchModeProvider` toggle | No toggle needed until Path Search is re-enabled |
| Link dim in graph view | AppLinkRenderer — lower value than node dim; add in Session 2 if easy |
| "Add Property Condition" in Path Search | Explicitly deferred in design doc |
| Persistent saved subgraphs | Post-alpha feature |

---

## Key File Locations

| File | Role |
|---|---|
| `apps/desktop/lib/src/providers/search_providers.dart` | All search providers |
| `apps/desktop/lib/src/services/search_execution_service.dart` | `executeKeywordSearch()`, `getAvailableLabelsAndTypes()` |
| `apps/desktop/lib/src/models/search_models.dart` | `ExplorationOptions`, `SearchResult`, `PatternEntity` |
| `apps/desktop/lib/src/widgets/graph_navigator_sidebar.dart` | Search tab UI — main edit target for Session 1 |
| `packages/features/import_export/lib/src/services/csv_import_service.dart` | CSV import — Session 3 target |

---

## Failed Approaches / Decisions Not to Revisit

- **Do not implement Path Search UI first** — it was the original blocker. Keyword-first is the explicit decision.
- **Do not use `filterStateProvider` (sample data)** for filter chips — it must read from live graph via `availableNodeLabelsProvider` / `availableLinkTypesProvider`.
- **Do not add `searchModeProvider`** until Path Search is re-enabled. Adding it now just adds dead state.
