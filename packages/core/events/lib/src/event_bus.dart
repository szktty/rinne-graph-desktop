/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_events/src/event.dart';
import 'package:core_events/src/event_dispatcher.dart';
import 'package:flutter/foundation.dart';

/// A simple event bus implementation.
///
/// The event bus allows components to subscribe to events and
/// dispatches events to all subscribers.
class EventBus<T extends Event> implements EventDispatcher<T> {
  /// Creates a new event bus.
  EventBus();

  final List<void Function(T)> _listeners = [];

  /// Dispatches an event to all subscribers.
  @override
  void dispatch(T event) {
    debugPrint('Dispatching event: $event');
    for (final listener in _listeners) {
      listener(event);
    }
  }

  /// Subscribes to events.
  ///
  /// Returns a function that can be called to unsubscribe.
  void Function() subscribe(void Function(T) listener) {
    _listeners.add(listener);
    return () => unsubscribe(listener);
  }

  /// Unsubscribes from events.
  void unsubscribe(void Function(T) listener) {
    _listeners.remove(listener);
  }

  /// Subscribes to events that match the given filter.
  ///
  /// Returns a function that can be called to unsubscribe.
  void Function() subscribeWhere(
    void Function(T) listener,
    bool Function(T) filter,
  ) {
    void wrappedListener(T event) {
      if (filter(event)) {
        listener(event);
      }
    }

    _listeners.add(wrappedListener);
    return () => unsubscribe(wrappedListener);
  }

  /// Subscribes to events of a specific type.
  ///
  /// Returns a function that can be called to unsubscribe.
  void Function() subscribeType<E extends T>(void Function(E) listener) {
    void wrappedListener(T event) {
      if (event is E) {
        listener(event);
      }
    }

    _listeners.add(wrappedListener);
    return () => unsubscribe(wrappedListener);
  }
}
