// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedActivityIndexHash() =>
    r'2984b8dc79483a410700c63e2d4813377c5a8a9c';

/// Alias for selected activity index for compatibility
///
/// Copied from [selectedActivityIndex].
@ProviderFor(selectedActivityIndex)
final selectedActivityIndexProvider = AutoDisposeProvider<int>.internal(
  selectedActivityIndex,
  name: r'selectedActivityIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedActivityIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedActivityIndexRef = AutoDisposeProviderRef<int>;
String _$pathfinderStateHash() => r'bc76e53d3921f703daa4203875223a875a18bf4d';

/// Alias for pathfinder state
///
/// Copied from [pathfinderState].
@ProviderFor(pathfinderState)
final pathfinderStateProvider = AutoDisposeProvider<PathfinderState>.internal(
  pathfinderState,
  name: r'pathfinderStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pathfinderStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PathfinderStateRef = AutoDisposeProviderRef<PathfinderState>;
String _$activityBarStateHash() => r'3552d91c737225557d1befcdff99b481a3c5f789';

/// Manages the selected index of the main activity bar.
///
/// Copied from [ActivityBarState].
@ProviderFor(ActivityBarState)
final activityBarStateProvider =
    AutoDisposeNotifierProvider<ActivityBarState, int>.internal(
      ActivityBarState.new,
      name: r'activityBarStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activityBarStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityBarState = AutoDisposeNotifier<int>;
String _$graphNavSidebarStateHash() =>
    r'8eb93d6f2efcc7ff7b4b5b6ecf7c94ccf6655fba';

/// Manages the selected index within the graph navigation sidebar.
/// -1 indicates no specific item is selected (e.g., showing "All" stacks).
///
/// Copied from [GraphNavSidebarState].
@ProviderFor(GraphNavSidebarState)
final graphNavSidebarStateProvider =
    AutoDisposeNotifierProvider<GraphNavSidebarState, int>.internal(
      GraphNavSidebarState.new,
      name: r'graphNavSidebarStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$graphNavSidebarStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GraphNavSidebarState = AutoDisposeNotifier<int>;
String _$settingsUiStateHash() => r'05b29c9d8808c07a7266647b6f43d2a821305de1';

/// Manages the selected index for the settings sidebar categories.
///
/// Copied from [SettingsUiState].
@ProviderFor(SettingsUiState)
final settingsUiStateProvider =
    AutoDisposeNotifierProvider<SettingsUiState, int>.internal(
      SettingsUiState.new,
      name: r'settingsUiStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsUiStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsUiState = AutoDisposeNotifier<int>;
String _$unifiedSidebarTabHash() => r'5219a60114d83df111811c6c6c2b5a3acbfb4bd2';

/// Provider managing the tab state of the unified sidebar
/// 0: browse tab, 1: search tab
///
/// Copied from [UnifiedSidebarTab].
@ProviderFor(UnifiedSidebarTab)
final unifiedSidebarTabProvider =
    AutoDisposeNotifierProvider<UnifiedSidebarTab, int>.internal(
      UnifiedSidebarTab.new,
      name: r'unifiedSidebarTabProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$unifiedSidebarTabHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UnifiedSidebarTab = AutoDisposeNotifier<int>;
String _$screenBasedSecondarySidebarStateHash() =>
    r'3615441fe78863c834b3a0574f27f1e8af8c28e5';

/// Provider managing secondary sidebar state per screen
/// Retains and restores state based on activity bar index
///
/// Copied from [ScreenBasedSecondarySidebarState].
@ProviderFor(ScreenBasedSecondarySidebarState)
final screenBasedSecondarySidebarStateProvider = AutoDisposeNotifierProvider<
  ScreenBasedSecondarySidebarState,
  bool
>.internal(
  ScreenBasedSecondarySidebarState.new,
  name: r'screenBasedSecondarySidebarStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$screenBasedSecondarySidebarStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScreenBasedSecondarySidebarState = AutoDisposeNotifier<bool>;
String _$activityBarChangeListenerHash() =>
    r'a9575d580f77088cdb4fb922fae01e7ed6733530';

/// Provider that monitors activity bar changes and restores secondary sidebar state
///
/// Copied from [ActivityBarChangeListener].
@ProviderFor(ActivityBarChangeListener)
final activityBarChangeListenerProvider =
    AutoDisposeNotifierProvider<ActivityBarChangeListener, void>.internal(
      ActivityBarChangeListener.new,
      name: r'activityBarChangeListenerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activityBarChangeListenerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityBarChangeListener = AutoDisposeNotifier<void>;
String _$graphNavigatorTabHash() => r'4f5972e244bd351dec84912fd0787ed93354bc00';

/// Provider managing tab state of graph navigator sidebar
/// 0: navigator tab, 1: search tab
///
/// Copied from [GraphNavigatorTab].
@ProviderFor(GraphNavigatorTab)
final graphNavigatorTabProvider =
    AutoDisposeNotifierProvider<GraphNavigatorTab, int>.internal(
      GraphNavigatorTab.new,
      name: r'graphNavigatorTabProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$graphNavigatorTabHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GraphNavigatorTab = AutoDisposeNotifier<int>;
String _$pathfinderStateNotifierHash() =>
    r'b6a4661d586280a33c115c7205745607ee622efd';

/// Pathfinder state provider for graph navigation
///
/// Copied from [PathfinderStateNotifier].
@ProviderFor(PathfinderStateNotifier)
final pathfinderStateNotifierProvider = AutoDisposeNotifierProvider<
  PathfinderStateNotifier,
  PathfinderState
>.internal(
  PathfinderStateNotifier.new,
  name: r'pathfinderStateNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pathfinderStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PathfinderStateNotifier = AutoDisposeNotifier<PathfinderState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
