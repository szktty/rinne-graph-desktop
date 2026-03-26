/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sidebar_state_providers.g.dart';

/// Provider that manages the visibility of the primary sidebar.
@riverpod
class PrimarySidebarState extends _$PrimarySidebarState {
  @override
  bool build() => true;

  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
  void setVisible(bool visible) => state = visible;
}

/// Provider that manages the visibility of the secondary sidebar.
@riverpod
class SecondarySidebarState extends _$SecondarySidebarState {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
  void setVisible(bool visible) => state = visible;
}

/// Provider that manages the per-screen visibility of the secondary sidebar.
///
/// Stores a map from activity bar screen index to sidebar visibility.
@riverpod
class PerScreenSecondarySidebarState extends _$PerScreenSecondarySidebarState {
  @override
  Map<int, bool> build() => {};

  bool getStateForScreen(int screenIndex) => state[screenIndex] ?? false;

  void setStateForScreen(int screenIndex, bool visible) {
    state = {...state, screenIndex: visible};
  }
}
