import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'toolbar_state.dart' as toolbar_models;

part 'toolbar_providers.g.dart';

/// Provider that manages the state of the toolbar.
@riverpod
class ToolbarStateNotifier extends _$ToolbarStateNotifier {
  @override
  toolbar_models.ToolbarState build() {
    return const toolbar_models.ToolbarState();
  }

  void setState(toolbar_models.ToolbarState newState) {
    state = newState;
  }

  void selectTool(String toolId) {
    state = state.copyWith(selectedTool: () => toolId);
  }

  void enableTool(String toolId) {
    state = state.copyWith(enabledTools: () => {...state.enabledTools, toolId});
  }

  void disableTool(String toolId) {
    state = state.copyWith(
      enabledTools: () => state.enabledTools.where((t) => t != toolId).toSet(),
    );
  }
}
