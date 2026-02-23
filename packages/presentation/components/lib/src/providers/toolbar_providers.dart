import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../toolbar/toolbar_state.dart' as toolbar_state;

part 'toolbar_providers.g.dart';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.
@riverpod
class ToolbarStateManager extends _$ToolbarStateManager {
  @override
  toolbar_state.ToolbarState build() {
    return const toolbar_state.ToolbarState();
  }

  /// Selects a tool.
  void selectTool(String toolId) {
    state = state.copyWith(selectedTool: () => toolId);
  }

  /// Enables a tool.
  void enableTool(String toolId) {
    state = state.copyWith(enabledTools: () => {...state.enabledTools, toolId});
  }

  /// Disables a tool.
  void disableTool(String toolId) {
    state = state.copyWith(
      enabledTools: () => state.enabledTools.where((t) => t != toolId).toSet(),
    );
  }

  /// Updates the state.
  void updateState(toolbar_state.ToolbarState newState) {
    state = newState;
  }
}

/// Provider that supplies toolbar actions.
@riverpod
ToolbarActions toolbarActions(Ref ref) {
  return ToolbarActions(ref);
}

/// Toolbar actions class.
class ToolbarActions {
  final Ref _ref;

  ToolbarActions(this._ref);

  /// Selects a tool.
  void selectTool(String toolId) {
    _ref.read(toolbarStateManagerProvider.notifier).selectTool(toolId);
  }

  /// Enables a tool.
  void enableTool(String toolId) {
    _ref.read(toolbarStateManagerProvider.notifier).enableTool(toolId);
  }

  /// Disables a tool.
  void disableTool(String toolId) {
    _ref.read(toolbarStateManagerProvider.notifier).disableTool(toolId);
  }
}
