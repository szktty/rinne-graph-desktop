// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the selected index of the main activity bar.

@ProviderFor(ActivityBarState)
final activityBarStateProvider = ActivityBarStateProvider._();

/// Manages the selected index of the main activity bar.
final class ActivityBarStateProvider
    extends $NotifierProvider<ActivityBarState, int> {
  /// Manages the selected index of the main activity bar.
  ActivityBarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityBarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityBarStateHash();

  @$internal
  @override
  ActivityBarState create() => ActivityBarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$activityBarStateHash() => r'3552d91c737225557d1befcdff99b481a3c5f789';

/// Manages the selected index of the main activity bar.

abstract class _$ActivityBarState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Alias for selected activity index for compatibility

@ProviderFor(selectedActivityIndex)
final selectedActivityIndexProvider = SelectedActivityIndexProvider._();

/// Alias for selected activity index for compatibility

final class SelectedActivityIndexProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Alias for selected activity index for compatibility
  SelectedActivityIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedActivityIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedActivityIndexHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return selectedActivityIndex(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedActivityIndexHash() =>
    r'2ecd7ae8e2703e58e8357f50c5fdfe3a257c2071';

/// Manages the selected index within the graph navigation sidebar.
/// -1 indicates no specific item is selected (e.g., showing "All" stacks).

@ProviderFor(GraphNavSidebarState)
final graphNavSidebarStateProvider = GraphNavSidebarStateProvider._();

/// Manages the selected index within the graph navigation sidebar.
/// -1 indicates no specific item is selected (e.g., showing "All" stacks).
final class GraphNavSidebarStateProvider
    extends $NotifierProvider<GraphNavSidebarState, int> {
  /// Manages the selected index within the graph navigation sidebar.
  /// -1 indicates no specific item is selected (e.g., showing "All" stacks).
  GraphNavSidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphNavSidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphNavSidebarStateHash();

  @$internal
  @override
  GraphNavSidebarState create() => GraphNavSidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$graphNavSidebarStateHash() =>
    r'8eb93d6f2efcc7ff7b4b5b6ecf7c94ccf6655fba';

/// Manages the selected index within the graph navigation sidebar.
/// -1 indicates no specific item is selected (e.g., showing "All" stacks).

abstract class _$GraphNavSidebarState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Manages the selected index for the settings sidebar categories.

@ProviderFor(SettingsUiState)
final settingsUiStateProvider = SettingsUiStateProvider._();

/// Manages the selected index for the settings sidebar categories.
final class SettingsUiStateProvider
    extends $NotifierProvider<SettingsUiState, int> {
  /// Manages the selected index for the settings sidebar categories.
  SettingsUiStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsUiStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsUiStateHash();

  @$internal
  @override
  SettingsUiState create() => SettingsUiState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$settingsUiStateHash() => r'05b29c9d8808c07a7266647b6f43d2a821305de1';

/// Manages the selected index for the settings sidebar categories.

abstract class _$SettingsUiState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing the tab state of the unified sidebar
/// 0: browse tab, 1: search tab

@ProviderFor(UnifiedSidebarTab)
final unifiedSidebarTabProvider = UnifiedSidebarTabProvider._();

/// Provider managing the tab state of the unified sidebar
/// 0: browse tab, 1: search tab
final class UnifiedSidebarTabProvider
    extends $NotifierProvider<UnifiedSidebarTab, int> {
  /// Provider managing the tab state of the unified sidebar
  /// 0: browse tab, 1: search tab
  UnifiedSidebarTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unifiedSidebarTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unifiedSidebarTabHash();

  @$internal
  @override
  UnifiedSidebarTab create() => UnifiedSidebarTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unifiedSidebarTabHash() => r'5219a60114d83df111811c6c6c2b5a3acbfb4bd2';

/// Provider managing the tab state of the unified sidebar
/// 0: browse tab, 1: search tab

abstract class _$UnifiedSidebarTab extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing secondary sidebar state per screen
/// Retains and restores state based on activity bar index

@ProviderFor(ScreenBasedSecondarySidebarState)
final screenBasedSecondarySidebarStateProvider =
    ScreenBasedSecondarySidebarStateProvider._();

/// Provider managing secondary sidebar state per screen
/// Retains and restores state based on activity bar index
final class ScreenBasedSecondarySidebarStateProvider
    extends $NotifierProvider<ScreenBasedSecondarySidebarState, bool> {
  /// Provider managing secondary sidebar state per screen
  /// Retains and restores state based on activity bar index
  ScreenBasedSecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenBasedSecondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenBasedSecondarySidebarStateHash();

  @$internal
  @override
  ScreenBasedSecondarySidebarState create() =>
      ScreenBasedSecondarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$screenBasedSecondarySidebarStateHash() =>
    r'3615441fe78863c834b3a0574f27f1e8af8c28e5';

/// Provider managing secondary sidebar state per screen
/// Retains and restores state based on activity bar index

abstract class _$ScreenBasedSecondarySidebarState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that monitors activity bar changes and restores secondary sidebar state

@ProviderFor(ActivityBarChangeListener)
final activityBarChangeListenerProvider = ActivityBarChangeListenerProvider._();

/// Provider that monitors activity bar changes and restores secondary sidebar state
final class ActivityBarChangeListenerProvider
    extends $NotifierProvider<ActivityBarChangeListener, void> {
  /// Provider that monitors activity bar changes and restores secondary sidebar state
  ActivityBarChangeListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityBarChangeListenerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityBarChangeListenerHash();

  @$internal
  @override
  ActivityBarChangeListener create() => ActivityBarChangeListener();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$activityBarChangeListenerHash() =>
    r'a9575d580f77088cdb4fb922fae01e7ed6733530';

/// Provider that monitors activity bar changes and restores secondary sidebar state

abstract class _$ActivityBarChangeListener extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider managing tab state of graph navigator sidebar
/// 0: navigator tab, 1: search tab

@ProviderFor(GraphNavigatorTab)
final graphNavigatorTabProvider = GraphNavigatorTabProvider._();

/// Provider managing tab state of graph navigator sidebar
/// 0: navigator tab, 1: search tab
final class GraphNavigatorTabProvider
    extends $NotifierProvider<GraphNavigatorTab, int> {
  /// Provider managing tab state of graph navigator sidebar
  /// 0: navigator tab, 1: search tab
  GraphNavigatorTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphNavigatorTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphNavigatorTabHash();

  @$internal
  @override
  GraphNavigatorTab create() => GraphNavigatorTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$graphNavigatorTabHash() => r'4f5972e244bd351dec84912fd0787ed93354bc00';

/// Provider managing tab state of graph navigator sidebar
/// 0: navigator tab, 1: search tab

abstract class _$GraphNavigatorTab extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Pathfinder state provider for graph navigation

@ProviderFor(PathfinderStateNotifier)
final pathfinderStateProvider = PathfinderStateNotifierProvider._();

/// Pathfinder state provider for graph navigation
final class PathfinderStateNotifierProvider
    extends $NotifierProvider<PathfinderStateNotifier, PathfinderState> {
  /// Pathfinder state provider for graph navigation
  PathfinderStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pathfinderStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pathfinderStateNotifierHash();

  @$internal
  @override
  PathfinderStateNotifier create() => PathfinderStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PathfinderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PathfinderState>(value),
    );
  }
}

String _$pathfinderStateNotifierHash() =>
    r'b6a4661d586280a33c115c7205745607ee622efd';

/// Pathfinder state provider for graph navigation

abstract class _$PathfinderStateNotifier extends $Notifier<PathfinderState> {
  PathfinderState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PathfinderState, PathfinderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PathfinderState, PathfinderState>,
              PathfinderState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
