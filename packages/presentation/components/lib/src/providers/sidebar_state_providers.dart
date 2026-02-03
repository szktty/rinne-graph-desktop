import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'sidebar_state_providers.g.dart';

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.
@riverpod
class PerScreenSecondarySidebarState extends _$PerScreenSecondarySidebarState {
  @override
  Map<int, bool> build() => {};

  /// Get the secondary sidebar state for the specified screen.
  bool getStateForScreen(int screenIndex) {
    return state[screenIndex] ?? false; // Default is hidden
  }

  /// Set the secondary sidebar state for the specified screen.
  void setStateForScreen(int screenIndex, bool visible) {
    state = {...state, screenIndex: visible};
  }

  /// Toggle the secondary sidebar state for the specified screen.
  void toggleStateForScreen(int screenIndex) {
    final currentState = getStateForScreen(screenIndex);
    setStateForScreen(screenIndex, !currentState);
  }
}

/// Provider that manages the visibility state of the primary sidebar (left side).
@riverpod
class PrimarySidebarState extends _$PrimarySidebarState {
  @override
  bool build() => true; // Default is visible

  void toggle() {
    state = !state;
  }

  void setVisible(bool visible) {
    state = visible;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.
@riverpod
class SecondarySidebarState extends _$SecondarySidebarState {
  @override
  bool build() {
    // To get the current activity bar index,
    // you need to watch activityBarStateProvider in actual use.
    return false; // Default is hidden
  }

  void toggle() {
    state = !state;
  }

  void setVisible(bool visible) {
    state = visible;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.
@riverpod
bool contextualSecondarySidebarState(Ref ref) {
  // Watch the current index of the activity bar.
  // Note: This provider needs to reference activityBarStateProvider
  // when used from apps/desktop.

  // By default, it returns the value of the current SecondarySidebarState.
  return ref.watch(secondarySidebarStateProvider);
}
