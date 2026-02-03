import 'package:core_events/src/event.dart';
import 'package:core_events/src/event_dispatcher.dart';
import 'package:flutter/foundation.dart';
import 'package:signals/signals.dart';

/// A signal-based event bus implementation.
///
/// This event bus uses signals to manage event subscriptions and dispatching.
class SignalEventBus<T extends Event> implements EventDispatcher<T> {
  /// Creates a new signal-based event bus.
  SignalEventBus();

  // Signal holding the latest event
  final Signal<T?> _eventSignal = signal<T?>(null);

  // Signal providing the event stream
  final ListSignal<T> _eventsSignal = listSignal<T>([]);

  /// Gets the signal of the latest event
  Signal<T?> get latestEvent => _eventSignal;

  /// Gets the signal of event history
  ListSignal<T> get events => _eventsSignal;

  /// Dispatches an event to all subscribers.
  @override
  void dispatch(T event) {
    debugPrint('Dispatching event: $event');

    // 最新のイベントを更新
    _eventSignal.value = event;

    // イベント履歴に追加
    _eventsSignal.add(event);
  }

  /// Creates a signal that filters and observes events
  Signal<T?> filter(bool Function(T) predicate) {
    return computed(() {
          final event = _eventSignal.value;
          if (event != null && predicate(event)) {
            return event;
          }
          return null;
        })
        as Signal<T?>;
  }

  /// Creates a signal that transforms and observes events
  Signal<R?> map<R>(R Function(T) mapper) {
    return computed(() {
          final event = _eventSignal.value;
          if (event != null) {
            return mapper(event);
          }
          return null;
        })
        as Signal<R?>;
  }

  /// Creates a signal that observes only events of a specific type
  Signal<E?> ofType<E extends T>() {
    return computed(() {
          final event = _eventSignal.value;
          if (event is E) {
            return event;
          }
          return null;
        })
        as Signal<E?>;
  }

  /// Subscribes to events
  ///
  /// Returns a function that can be called to unsubscribe.
  void Function() subscribe(void Function(T) listener) {
    final disposer = _eventSignal.subscribe((event) {
      if (event != null) {
        listener(event);
      }
    });
    return disposer;
  }

  /// Subscribes to events of a specific type
  ///
  /// Returns a function that can be called to unsubscribe.
  void Function() subscribeType<E extends T>(void Function(E) listener) {
    final signal = ofType<E>();
    final disposer = signal.subscribe((event) {
      if (event != null) {
        listener(event);
      }
    });
    return disposer;
  }
}
