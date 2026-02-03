import 'package:core_events/src/event.dart';
import 'package:core_events/src/event_bus.dart';
import 'package:core_events/src/signals/signal_event_bus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_providers.g.dart';

/// Provider that provides an EventBus for a specified event type
@riverpod
EventBus<T> eventBus<T extends Event>(EventBusRef<T> ref) {
  return EventBus<T>();
}

/// Provider that provides a SignalEventBus for a specified event type
@riverpod
SignalEventBus<T> signalEventBus<T extends Event>(SignalEventBusRef<T> ref) {
  return SignalEventBus<T>();
}

/// Provider managing the global event bus
@riverpod
GlobalEventBus globalEventBus(GlobalEventBusRef ref) {
  return GlobalEventBus();
}

/// Provider offering event operations
@riverpod
EventOperations eventOperations(EventOperationsRef ref) {
  return EventOperations(ref);
}

/// Global event bus class
class GlobalEventBus {
  final Map<Type, EventBus> _buses = {};

  /// Gets the event bus of the specified type
  EventBus<T> getBus<T extends Event>() {
    final type = T;
    if (!_buses.containsKey(type)) {
      _buses[type] = EventBus<T>();
    }
    return _buses[type]! as EventBus<T>;
  }

  /// Emits an event
  void emit<T extends Event>(T event) {
    getBus<T>().emit(event);
  }

  /// Listens to events
  Stream<T> listen<T extends Event>() {
    return getBus<T>().stream;
  }

  /// Clears all event buses
  void clearAll() {
    for (final bus in _buses.values) {
      bus.dispose();
    }
    _buses.clear();
  }
}

/// Class managing event operations
class EventOperations {
  EventOperations(this._ref);
  final EventOperationsRef _ref;

  /// Gets the event bus of the specified type
  EventBus<T> getEventBus<T extends Event>() {
    return _ref.read(eventBusProvider<T>());
  }

  /// Gets the signal event bus of the specified type
  SignalEventBus<T> getSignalEventBus<T extends Event>() {
    return _ref.read(signalEventBusProvider<T>());
  }

  /// Gets the global event bus
  GlobalEventBus getGlobalEventBus() {
    return _ref.read(globalEventBusProvider);
  }

  /// Emits an event (using global bus)
  void emitGlobal<T extends Event>(T event) {
    getGlobalEventBus().emit(event);
  }

  /// Listens to events (using global bus)
  Stream<T> listenGlobal<T extends Event>() {
    return getGlobalEventBus().listen<T>();
  }

  /// Emits an event on a specific event bus
  void emit<T extends Event>(T event) {
    getEventBus<T>().emit(event);
  }

  /// Listens to events on a specific event bus
  Stream<T> listen<T extends Event>() {
    return getEventBus<T>().stream;
  }

  /// Emits an event on the signal event bus
  void emitSignal<T extends Event>(T event) {
    getSignalEventBus<T>().emit(event);
  }

  /// Listens to events on the signal event bus
  Stream<T> listenSignal<T extends Event>() {
    return getSignalEventBus<T>().stream;
  }
}
