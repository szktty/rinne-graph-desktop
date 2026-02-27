/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';

/// Riverpod class for managing widget IDs.
///
/// Manages the IDs of multiple widgets and provides operations such as
/// adding, deleting, and checking for existence.
/// Mainly used for managing navigation and list selection states.
class WidgetIdManager extends StateNotifier<List<UniqueId>> {
  WidgetIdManager() : super([]);

  void clear() {
    state = [];
  }

  void add(UniqueId id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }

  void addAll(List<UniqueId> newIds) {
    final uniqueIds = {...state, ...newIds};
    state = uniqueIds.toList();
  }

  void remove(UniqueId id) {
    state = state.where((i) => i != id).toList();
  }

  bool contains(UniqueId id) => state.contains(id);

  void removeAll() {
    state = [];
  }

  void setOnly(UniqueId id) {
    state = [id];
  }

  void setOnlyMultiple(List<UniqueId> newIds) {
    state = newIds;
  }

  void toggle(UniqueId id) {
    if (contains(id)) {
      remove(id);
    } else {
      add(id);
    }
  }
}

/// Provider for managing widget IDs.
///
/// Manages a list of multiple widget IDs, and provides operations such as
/// adding, deleting, and switching selection states. Used for navigation and
/// list selection state management.
final widgetIdManagerProvider =
    StateNotifierProvider.autoDispose<WidgetIdManager, List<UniqueId>>((ref) {
      return WidgetIdManager();
    });

/// Riverpod class for managing selectable widget IDs.
///
/// Manages the selection state of multiple widgets and provides operations
/// such as select, deselect, and toggle.
/// Mainly used for item selection in lists and tree views.
class SelectionManager extends StateNotifier<List<UniqueId>> {
  SelectionManager() : super([]);

  void clearSelection() => state = [];

  bool isSelected(UniqueId id) => state.contains(id);

  void select(UniqueId id) {
    if (!isSelected(id)) {
      state = [...state, id];
    }
  }

  void deselect(UniqueId id) {
    state = state.where((i) => i != id).toList();
  }

  void toggleSelection(UniqueId id) {
    if (isSelected(id)) {
      deselect(id);
    } else {
      select(id);
    }
  }

  void selectMultiple(List<UniqueId> ids) {
    final uniqueIds = {...state, ...ids};
    state = uniqueIds.toList();
  }
}

/// Provider for managing selectable widget IDs.
///
/// Manages the selection state of multiple widgets and provides operations
/// such as select, deselect, and toggle.
/// Mainly used for item selection in lists and tree views.
final selectionManagerProvider =
    StateNotifierProvider.autoDispose<SelectionManager, List<UniqueId>>((ref) {
      return SelectionManager();
    });
