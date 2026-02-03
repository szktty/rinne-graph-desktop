import 'package:meta/meta.dart';

/// Base class for all events in the application.
///
/// Events represent something that happened in the application.
/// They are immutable and should be serializable.
@immutable
abstract class Event {
  /// Creates a new event with the given timestamp.
  ///
  /// If no timestamp is provided, the current time is used.
  Event({DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();

  /// The time when the event occurred.
  final DateTime timestamp;

  /// Returns a string representation of the event.
  @override
  String toString() => '$runtimeType(timestamp: $timestamp)';
}
