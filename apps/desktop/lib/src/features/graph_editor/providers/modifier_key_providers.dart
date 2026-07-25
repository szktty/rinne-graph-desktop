/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'modifier_key_providers.g.dart';

/// Whether Alt/Option was held when the current gesture started.
///
/// Sampled at pointer-down rather than read live, because plough dispatches
/// `onTap` from behind its tap-recognition timer: by the time a behavior runs,
/// the user may already have released the key. A `Listener` runs before the
/// gesture arena resolves, so it observes the modifier at the instant the
/// gesture physically began.
@Riverpod(keepAlive: true)
class AltPressed extends _$AltPressed {
  @override
  bool build() => false;

  // ignore: avoid_positional_boolean_parameters
  void set(bool pressed) {
    if (state == pressed) return;
    state = pressed;
  }
}
