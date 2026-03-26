/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sidebar_width_provider.g.dart';

const _primarySidebarDefaultWidth = 320.0;
const _primarySidebarMinWidth = 240.0;
const _primarySidebarMaxWidth = 480.0;

const _secondarySidebarDefaultWidth = 288.0;
const _secondarySidebarMinWidth = 200.0;
const _secondarySidebarMaxWidth = 400.0;

/// Provider that manages the width of the primary sidebar.
@riverpod
class SidebarWidth extends _$SidebarWidth {
  @override
  double build() => _primarySidebarDefaultWidth;

  void setWidth(double width) {
    state = width.clamp(_primarySidebarMinWidth, _primarySidebarMaxWidth);
  }

  void adjustWidth(double delta) => setWidth(state + delta);
}

/// Provider that manages the width of the secondary sidebar.
@riverpod
class SecondarySidebarWidth extends _$SecondarySidebarWidth {
  @override
  double build() => _secondarySidebarDefaultWidth;

  void setWidth(double width) {
    state = width.clamp(_secondarySidebarMinWidth, _secondarySidebarMaxWidth);
  }

  void adjustWidth(double delta) => setWidth(state + delta);
}
