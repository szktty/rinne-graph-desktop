/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_events/src/event.dart';

/// Interface for event dispatchers.
///
/// Event dispatchers are responsible for sending events to subscribers.
abstract interface class EventDispatcher<T extends Event> {
  /// Dispatches an event to all subscribers.
  void dispatch(T event);
}
