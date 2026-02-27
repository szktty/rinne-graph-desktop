/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'view_toolbar_providers.g.dart';

/// View type state management provider
@riverpod
class ViewToolbarState extends _$ViewToolbarState {
  @override
  String build() => 'graph';

  void setActiveView(String view) {
    state = view;
  }

  void setTableView() {
    state = 'table';
  }

  void setGraphView() {
    state = 'graph';
  }
}
