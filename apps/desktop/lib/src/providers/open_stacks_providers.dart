import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

part 'open_stacks_providers.g.dart';

/// Provider managing the list of open stacks
@riverpod
class OpenStacks extends _$OpenStacks {
  @override
  List<core_stack.Stack> build() => [];

  /// Adds a stack (does not add if already exists)
  void addStack(core_stack.Stack stack) {
    if (!state.any((s) => s.directory.path == stack.directory.path)) {
      state = [...state, stack];
    }
  }

  /// Removes a stack
  void removeStack(core_stack.Stack stack) {
    state =
        state.where((s) => s.directory.path != stack.directory.path).toList();
  }

  /// Sets the stack list
  void setStacks(List<core_stack.Stack> stacks) {
    state = stacks;
  }

  /// Checks if a specific stack is open
  bool isStackOpen(core_stack.Stack stack) {
    return state.any((s) => s.directory.path == stack.directory.path);
  }

  /// Closes all stacks
  void closeAllStacks() {
    state = [];
  }
}

/// Action provider for open stacks
@riverpod
class OpenStacksActions extends _$OpenStacksActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Adds a stack
  void addStack(core_stack.Stack stack) {
    ref.read(openStacksProvider.notifier).addStack(stack);
  }

  /// Removes a stack
  void removeStack(core_stack.Stack stack) {
    ref.read(openStacksProvider.notifier).removeStack(stack);
  }

  /// Sets the stack list
  void setStacks(List<core_stack.Stack> stacks) {
    ref.read(openStacksProvider.notifier).setStacks(stacks);
  }

  /// Closes all stacks
  void closeAllStacks() {
    ref.read(openStacksProvider.notifier).closeAllStacks();
  }
}
