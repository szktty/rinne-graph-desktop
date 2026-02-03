import 'package:core_events/src/event.dart';

/// Interface for event dispatchers.
///
/// Event dispatchers are responsible for sending events to subscribers.
abstract interface class EventDispatcher<T extends Event> {
  /// Dispatches an event to all subscribers.
  void dispatch(T event);
}
