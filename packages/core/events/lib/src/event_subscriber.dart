import 'package:core_events/src/event.dart';

/// Interface for event subscribers.
///
/// Event subscribers receive events from event dispatchers.
abstract interface class EventSubscriber<T extends Event> {
  /// Called when an event is received.
  void onEvent(T event);
}
