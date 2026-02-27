/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_events/core_events.dart' as core_events;
import 'package:flutter_test/flutter_test.dart';

// Test events for testing
class TestEvent extends Event {
  TestEvent(this.message, this.value, {super.timestamp});

  final String message;
  final int value;

  @override
  String toString() =>
      'TestEvent(message: $message, value: $value, timestamp: $timestamp)';
}

class AnotherTestEvent extends Event {
  AnotherTestEvent(this.data, {super.timestamp});

  final String data;

  @override
  String toString() => 'AnotherTestEvent(data: $data, timestamp: $timestamp)';
}

void main() {
  group('EventBus', () {
    late EventBus<Event> eventBus;

    setUp(() {
      eventBus = EventBus<Event>();
    });

    group('basic functionality', () {
      test('should create instance successfully', () {
        expect(eventBus, isNotNull);
        expect(eventBus, isA<EventBus<Event>>());
        expect(eventBus, isA<core_events.EventDispatcher<Event>>());
      });

      test('should dispatch events to subscribers', () {
        final receivedEvents = <core_events.Event>[];

        eventBus.subscribe(receivedEvents.add);

        final testEvent = TestEvent('test message', 42);
        eventBus.dispatch(testEvent);

        expect(receivedEvents, hasLength(1));
        expect(receivedEvents.first, equals(testEvent));
      });

      test('should dispatch events to multiple subscribers', () {
        final receivedEvents1 = <Event>[];
        final receivedEvents2 = <Event>[];

        eventBus.subscribe(receivedEvents1.add);
        eventBus.subscribe(receivedEvents2.add);

        final testEvent = TestEvent('test message', 42);
        eventBus.dispatch(testEvent);

        expect(receivedEvents1, hasLength(1));
        expect(receivedEvents2, hasLength(1));
        expect(receivedEvents1.first, equals(testEvent));
        expect(receivedEvents2.first, equals(testEvent));
      });

      test('should not dispatch to unsubscribed listeners', () {
        final receivedEvents = <core_events.Event>[];

        final unsubscribe = eventBus.subscribe(receivedEvents.add);

        final testEvent1 = TestEvent('test message 1', 1);
        eventBus.dispatch(testEvent1);

        expect(receivedEvents, hasLength(1));

        // Unsubscribe
        unsubscribe();

        final testEvent2 = TestEvent('test message 2', 2);
        eventBus.dispatch(testEvent2);

        // Should still only have the first event
        expect(receivedEvents, hasLength(1));
        expect(receivedEvents.first, equals(testEvent1));
      });
    });

    group('unsubscribe functionality', () {
      test('should unsubscribe using returned function', () {
        final receivedEvents = <core_events.Event>[];

        final unsubscribe = eventBus.subscribe(receivedEvents.add);

        eventBus.dispatch(TestEvent('before unsubscribe', 1));
        expect(receivedEvents, hasLength(1));

        unsubscribe();

        eventBus.dispatch(TestEvent('after unsubscribe', 2));
        expect(
          receivedEvents,
          hasLength(1),
        ); // Should not receive the second event
      });

      test('should unsubscribe using explicit unsubscribe method', () {
        final receivedEvents = <core_events.Event>[];

        void listener(Event event) {
          receivedEvents.add(event);
        }

        eventBus.subscribe(listener);

        eventBus.dispatch(TestEvent('before unsubscribe', 1));
        expect(receivedEvents, hasLength(1));

        eventBus.unsubscribe(listener);

        eventBus.dispatch(TestEvent('after unsubscribe', 2));
        expect(
          receivedEvents,
          hasLength(1),
        ); // Should not receive the second event
      });

      test('should handle unsubscribing non-existent listener gracefully', () {
        void listener(Event event) {}

        // Should not throw an exception
        expect(() => eventBus.unsubscribe(listener), returnsNormally);
      });
    });

    group('filtered subscriptions', () {
      test('should subscribe with filter using subscribeWhere', () {
        final receivedEvents = <core_events.Event>[];

        eventBus.subscribeWhere(
          receivedEvents.add,
          (event) => event is TestEvent && event.value > 10,
        );

        eventBus.dispatch(TestEvent('low value', 5));
        eventBus.dispatch(TestEvent('high value', 15));
        eventBus.dispatch(AnotherTestEvent('different type'));

        expect(receivedEvents, hasLength(1));
        expect(receivedEvents.first, isA<TestEvent>());
        expect((receivedEvents.first as TestEvent).value, equals(15));
      });

      test('should unsubscribe filtered subscription', () {
        final receivedEvents = <core_events.Event>[];

        final unsubscribe = eventBus.subscribeWhere(
          receivedEvents.add,
          (event) => event is TestEvent,
        );

        eventBus.dispatch(TestEvent('test', 1));
        expect(receivedEvents, hasLength(1));

        unsubscribe();

        eventBus.dispatch(TestEvent('test2', 2));
        expect(
          receivedEvents,
          hasLength(1),
        ); // Should not receive the second event
      });
    });

    group('type-specific subscriptions', () {
      test('should subscribe to specific event types using subscribeType', () {
        final testEvents = <TestEvent>[];
        final anotherEvents = <AnotherTestEvent>[];

        eventBus.subscribeType<TestEvent>(testEvents.add);
        eventBus.subscribeType<AnotherTestEvent>(anotherEvents.add);

        eventBus.dispatch(TestEvent('test message', 42));
        eventBus.dispatch(AnotherTestEvent('another data'));
        eventBus.dispatch(TestEvent('second test', 24));

        expect(testEvents, hasLength(2));
        expect(anotherEvents, hasLength(1));
        expect(testEvents.first.message, equals('test message'));
        expect(testEvents.last.message, equals('second test'));
        expect(anotherEvents.first.data, equals('another data'));
      });

      test('should unsubscribe type-specific subscription', () {
        final testEvents = <TestEvent>[];

        final unsubscribe = eventBus.subscribeType<TestEvent>(testEvents.add);

        eventBus.dispatch(TestEvent('test', 1));
        expect(testEvents, hasLength(1));

        unsubscribe();

        eventBus.dispatch(TestEvent('test2', 2));
        expect(testEvents, hasLength(1)); // Should not receive the second event
      });
    });

    group('edge cases', () {
      test('should handle empty event bus dispatch', () {
        final testEvent = TestEvent('test', 1);

        // Should not throw an exception even with no subscribers
        expect(() => eventBus.dispatch(testEvent), returnsNormally);
      });

      test('should handle multiple unsubscribes of the same listener', () {
        final receivedEvents = <core_events.Event>[];

        void listener(Event event) {
          receivedEvents.add(event);
        }

        eventBus.subscribe(listener);

        // Multiple unsubscribes should not cause issues
        eventBus.unsubscribe(listener);
        eventBus.unsubscribe(listener);

        eventBus.dispatch(TestEvent('test', 1));
        expect(receivedEvents, isEmpty);
      });

      test('should handle listener that throws exception', () {
        final receivedEvents = <core_events.Event>[];

        // Add a listener that throws
        eventBus.subscribe((event) {
          throw Exception('Test exception');
        });

        // Add a normal listener
        eventBus.subscribe(receivedEvents.add);

        final testEvent = TestEvent('test', 1);

        // Dispatch should complete even if one listener throws
        // Note: In real implementation, you might want to handle exceptions
        expect(() => eventBus.dispatch(testEvent), throwsException);

        // The second listener might not be called due to the exception
        // This behavior depends on the implementation
      });
    });

    group('performance', () {
      test('should handle many subscribers efficiently', () {
        final subscribers = <List<Event>>[];

        // Add 100 subscribers
        for (var i = 0; i < 100; i++) {
          final events = <Event>[];
          subscribers.add(events);
          eventBus.subscribe(events.add);
        }

        final testEvent = TestEvent('performance test', 1);
        eventBus.dispatch(testEvent);

        // All subscribers should receive the event
        for (final events in subscribers) {
          expect(events, hasLength(1));
          expect(events.first, equals(testEvent));
        }
      });
    });
  });
}
