# Core Events

A foundational package for event sourcing.

## Overview

This package provides event sourcing functionality used throughout the application. It includes basic components such as event bus, event dispatcher, and event subscriber.

## Key Features

- Event base class
- Event bus implementation
- Event dispatcher interface
- Event subscriber interface
- Event bus implementation using Signals.dart
- Event bus provision via Riverpod providers

## Usage

### Basic Usage

```dart
import 'package:core_events/core_events.dart';

// Define an event
class UserCreatedEvent extends Event {
  final String userId;
  final String username;

  const UserCreatedEvent({
    required this.userId,
    required this.username,
    super.timestamp,
  });

  @override
  String toString() => 'UserCreatedEvent(userId: $userId, username: $username, timestamp: $timestamp)';
}

// Create an event bus
final eventBus = EventBus<Event>();

// Subscribe to events
final unsubscribe = eventBus.subscribe((event) {
  if (event is UserCreatedEvent) {
    print('User created: ${event.username}');
  }
});

// Dispatch an event
eventBus.dispatch(UserCreatedEvent(
  userId: '123',
  username: 'john_doe',
));

// Unsubscribe
unsubscribe();
```

### Using Riverpod Providers

```dart
import 'package:core_events/core_events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define an event
class UserCreatedEvent extends Event {
  final String userId;
  final String username;

  const UserCreatedEvent({
    required this.userId,
    required this.username,
    super.timestamp,
  });
}

// Using providers
Widget build(BuildContext context, WidgetRef ref) {
  final eventBus = ref.watch(eventBusProvider<Event>);

  // Subscribe to events
  ref.listen(() {
    final unsubscribe = eventBus.subscribe((event) {
      if (event is UserCreatedEvent) {
        print('User created: ${event.username}');
      }
    });

    return unsubscribe;
  }, []);

  return ElevatedButton(
    onPressed: () {
      // Dispatch an event
      eventBus.dispatch(UserCreatedEvent(
        userId: '123',
        username: 'john_doe',
      ));
    },
    child: Text('Create User'),
  );
}
```

### Using Signals.dart

```dart
import 'package:core_events/core_events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define an event
class UserCreatedEvent extends Event {
  final String userId;
  final String username;

  const UserCreatedEvent({
    required this.userId,
    required this.username,
    super.timestamp,
  });
}

// Using providers
Widget build(BuildContext context, WidgetRef ref) {
  final eventBus = ref.watch(signalEventBusProvider<Event>);

  // Create a signal to watch only UserCreatedEvent
  final userCreatedSignal = eventBus.ofType<UserCreatedEvent>();

  // Watch the signal
  ref.listen(() {
    final disposer = userCreatedSignal.watch((event) {
      if (event != null) {
        print('User created: ${event.username}');
      }
    });

    return disposer;
  }, []);

  return ElevatedButton(
    onPressed: () {
      // Dispatch an event
      eventBus.dispatch(UserCreatedEvent(
        userId: '123',
        username: 'john_doe',
      ));
    },
    child: Text('Create User'),
  );
}
```
