/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'command_model.dart';

/// 
/// AppCommand
class CommandRegistry extends StateNotifier<Map<String, AppCommand>> {
  CommandRegistry() : super({});

  void register(AppCommand command) {
    state = {...state, command.id: command};
  }

  void registerAll(Iterable<AppCommand> commands) {
    final next = Map<String, AppCommand>.from(state);
    for (final c in commands) {
      next[c.id] = c;
    }
    state = next;
  }

  void unregister(String id) {
    if (!state.containsKey(id)) return;
    final next = Map<String, AppCommand>.from(state);
    next.remove(id);
    state = next;
  }

  void clear() => state = {};

  List<AppCommand> list() =>
      state.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  AppCommand? get(String id) => state[id];
}

final commandRegistryProvider =
    StateNotifierProvider<CommandRegistry, Map<String, AppCommand>>(
      (ref) => CommandRegistry(),
    );
