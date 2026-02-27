/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_events/src/event.dart';

/// Interface for event subscribers.
///
/// Event subscribers receive events from event dispatchers.
abstract interface class EventSubscriber<T extends Event> {
  /// Called when an event is received.
  void onEvent(T event);
}
