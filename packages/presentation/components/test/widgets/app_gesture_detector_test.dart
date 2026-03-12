/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation_components/src/widgets/app_gesture_detector.dart';

void main() {
  group('FondeGestureDetector', () {
    late DateTime mockTime;
    late List<String> callLog;

    DateTime mockTimeProvider() => mockTime;

    void onTap() => callLog.add('onTap');
    void onDoubleTap() => callLog.add('onDoubleTap');

    setUp(() {
      mockTime = DateTime(2023, 1, 1, 12, 0, 0);
      callLog = [];
    });

    Widget createTestWidget({
      VoidCallback? onTap,
      VoidCallback? onTapCancel,
      VoidCallback? onDoubleTap,
      Duration? doubleTapTimeout,
      TimeProvider? timeProvider,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FondeGestureDetector(
            onTap: onTap,
            onTapCancel: onTapCancel,
            onDoubleTap: onDoubleTap,
            doubleTapTimeout:
                doubleTapTimeout ?? const Duration(milliseconds: 250),
            timeProvider: timeProvider ?? mockTimeProvider,
            child: Container(
              key: const Key('test-container'),
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    group('Single Tap Only', () {
      testWidgets('calls onTap immediately when onDoubleTap is null', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(onTap: onTap));

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onTap']));
      });

      testWidgets('handles multiple single taps correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(onTap: onTap));

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        mockTime = mockTime.add(const Duration(milliseconds: 300));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onTap', 'onTap']));
      });
    });

    group('Double Tap Only', () {
      testWidgets('calls onDoubleTap when two taps occur within timeout', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(onDoubleTap: onDoubleTap));

        // First tap
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Second tap within timeout
        mockTime = mockTime.add(const Duration(milliseconds: 200));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onDoubleTap']));
      });

      testWidgets('does not call onDoubleTap when taps are too far apart', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(onDoubleTap: onDoubleTap));

        // First tap
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Second tap after timeout
        mockTime = mockTime.add(const Duration(milliseconds: 300));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, isEmpty);
      });
    });

    group('Both Single and Double Tap', () {
      testWidgets('calls onTap after timeout when no second tap occurs', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(onTap: onTap, onDoubleTap: onDoubleTap),
        );

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // No callback should be called immediately
        expect(callLog, isEmpty);

        // Advance time past timeout
        await tester.pump(const Duration(milliseconds: 250));

        expect(callLog, equals(['onTap']));
      });

      testWidgets(
        'calls onDoubleTap and cancels onTap when double tap occurs',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(onTap: onTap, onDoubleTap: onDoubleTap),
          );

          // First tap
          await tester.tap(find.byKey(const Key('test-container')));
          await tester.pump();

          // Second tap within timeout
          mockTime = mockTime.add(const Duration(milliseconds: 200));
          await tester.tap(find.byKey(const Key('test-container')));
          await tester.pump();

          expect(callLog, equals(['onDoubleTap']));

          // Advance time to ensure onTap is not called
          await tester.pump(const Duration(milliseconds: 300));
          expect(callLog, equals(['onDoubleTap']));
        },
      );
    });

    group('onTapCancel Feature', () {
      void onTapCancel() => callLog.add('onTapCancel');

      testWidgets('calls onTap immediately with onTapCancel provided', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            onTap: onTap,
            onTapCancel: onTapCancel,
            onDoubleTap: onDoubleTap,
          ),
        );

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // onTap should be called immediately
        expect(callLog, equals(['onTap']));

        // Advance time past timeout - no additional calls
        await tester.pump(const Duration(milliseconds: 250));
        expect(callLog, equals(['onTap']));
      });

      testWidgets(
        'calls onTap, then onTapCancel and onDoubleTap for double tap',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              onTap: onTap,
              onTapCancel: onTapCancel,
              onDoubleTap: onDoubleTap,
            ),
          );

          // First tap
          await tester.tap(find.byKey(const Key('test-container')));
          await tester.pump();

          // onTap should be called immediately
          expect(callLog, equals(['onTap']));

          // Second tap within timeout
          mockTime = mockTime.add(const Duration(milliseconds: 200));
          await tester.tap(find.byKey(const Key('test-container')));
          await tester.pump();

          expect(callLog, equals(['onTap', 'onTapCancel', 'onDoubleTap']));
        },
      );
    });

    group('Rapid Tap Prevention', () {
      testWidgets('ignores taps that are too rapid (< 50ms)', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            onTap: onTap,
            onDoubleTap:
                onDoubleTap, // Need both handlers to test rapid tap prevention
          ),
        );

        // First tap
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Second tap too quickly (< 50ms) - should be ignored
        mockTime = mockTime.add(const Duration(milliseconds: 30));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Wait for single tap timer to expire
        await tester.pump(const Duration(milliseconds: 250));

        expect(
          callLog,
          equals(['onTap']),
        ); // Only first tap should be processed
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('does not call callbacks after widget is disposed', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(onTap: onTap, onDoubleTap: onDoubleTap),
        );

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Dispose the widget
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox())),
        );

        // Advance time past timeout
        await tester.pump(const Duration(milliseconds: 300));

        expect(callLog, isEmpty); // No callbacks should be called
      });
    });

    group('Error Handling', () {
      testWidgets('handles onTap callback exceptions gracefully', (
        tester,
      ) async {
        void throwingOnTap() => throw Exception('Test exception');

        await tester.pumpWidget(createTestWidget(onTap: throwingOnTap));

        // Should not throw
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Widget should still be functional
        expect(find.byKey(const Key('test-container')), findsOneWidget);
      });

      testWidgets('handles onDoubleTap callback exceptions gracefully', (
        tester,
      ) async {
        void throwingOnDoubleTap() => throw Exception('Test exception');

        await tester.pumpWidget(
          createTestWidget(onDoubleTap: throwingOnDoubleTap),
        );

        // First tap
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Second tap
        mockTime = mockTime.add(const Duration(milliseconds: 200));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Widget should still be functional
        expect(find.byKey(const Key('test-container')), findsOneWidget);
      });
    });

    group('Optimization', () {
      testWidgets('returns child directly when no callbacks are provided', (
        tester,
      ) async {
        const testChild = Text('Test Child');

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: FondeGestureDetector(child: testChild)),
          ),
        );

        expect(find.text('Test Child'), findsOneWidget);
        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets('attaches GestureDetector when callbacks are provided', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(onTap: onTap));

        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Custom Timeout', () {
      testWidgets('respects custom doubleTapTimeout', (tester) async {
        const customTimeout = Duration(milliseconds: 500);

        await tester.pumpWidget(
          createTestWidget(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            doubleTapTimeout: customTimeout,
          ),
        );

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Advance time less than custom timeout
        await tester.pump(const Duration(milliseconds: 400));
        expect(callLog, isEmpty);

        // Advance time past custom timeout
        await tester.pump(const Duration(milliseconds: 200));
        expect(callLog, equals(['onTap']));
      });

      testWidgets('double tap works with custom timeout', (tester) async {
        const customTimeout = Duration(milliseconds: 100);

        await tester.pumpWidget(
          createTestWidget(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            doubleTapTimeout: customTimeout,
          ),
        );

        // First tap
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Second tap within custom timeout
        mockTime = mockTime.add(const Duration(milliseconds: 80));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onDoubleTap']));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles multiple rapid double taps', (tester) async {
        await tester.pumpWidget(
          createTestWidget(onTap: onTap, onDoubleTap: onDoubleTap),
        );

        // First double tap sequence
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        mockTime = mockTime.add(const Duration(milliseconds: 200));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onDoubleTap']));
        callLog.clear();

        // Second double tap sequence after some time
        mockTime = mockTime.add(const Duration(milliseconds: 300));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        mockTime = mockTime.add(const Duration(milliseconds: 200));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onDoubleTap']));
      });

      testWidgets('handles tap sequence: single -> double -> single', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(onTap: onTap, onDoubleTap: onDoubleTap),
        );

        // Single tap (wait for timeout)
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        expect(callLog, equals(['onTap']));
        callLog.clear();

        // Double tap
        mockTime = mockTime.add(const Duration(milliseconds: 300));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        mockTime = mockTime.add(const Duration(milliseconds: 200));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onDoubleTap']));
        callLog.clear();

        // Another single tap
        mockTime = mockTime.add(const Duration(milliseconds: 300));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        expect(callLog, equals(['onTap']));
      });

      testWidgets('handles exactly at timeout boundary', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            doubleTapTimeout: const Duration(milliseconds: 250),
          ),
        );

        // First tap
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Second tap exactly at timeout boundary
        mockTime = mockTime.add(const Duration(milliseconds: 250));
        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        // Should not be considered a double tap (>= timeout)
        expect(callLog, isEmpty);

        // Wait for single tap timer
        await tester.pump(const Duration(milliseconds: 250));
        expect(callLog, equals(['onTap']));
      });
    });

    group('Time Provider', () {
      testWidgets('uses default time provider when not specified', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FondeGestureDetector(
                onTap: onTap,
                child: SizedBox(
                  key: const Key('test-container'),
                  width: 100,
                  height: 100,
                  child: Container(color: Colors.blue),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('test-container')));
        await tester.pump();

        expect(callLog, equals(['onTap']));
      });
    });
  });
}
