/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:fonde_ui/src/widgets/toolbar/toolbar_state.dart'
    show FondeToolbarState, FondeToolbarItemData;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toolbar_providers.g.dart';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.
@riverpod
class ToolbarStateManager extends _$ToolbarStateManager {
  @override
  FondeToolbarState build() {
    return const FondeToolbarState();
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
  void updateState(FondeToolbarState newState) {
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
