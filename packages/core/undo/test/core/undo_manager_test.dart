/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:core_undo/undo.dart';

import '../mocks/mock_graph_context.dart';
import '../mocks/mock_command.dart';

void main() {
  group('UndoManager', () {
    late MockGraphContext mockContext;
    late UndoManager undoManager;

    setUp(() {
      mockContext = MockGraphContext();
      undoManager = UndoManager(
        graphContext: mockContext,
        maxHistorySize: 5,
        maxMemoryUsage: 1024,
      );
    });

    tearDown(() {
      undoManager.dispose();
    });

    group('initialization', () {
      test('should start with empty history', () {
        expect(undoManager.canUndo, isFalse);
        expect(undoManager.canRedo, isFalse);
        expect(undoManager.historySize, equals(0));
        expect(undoManager.currentMemoryUsage, equals(0));
        expect(undoManager.undoHistory, isEmpty);
        expect(undoManager.redoHistory, isEmpty);
      });

      test('should have correct limits', () {
        expect(undoManager.maxHistorySize, equals(5));
        expect(undoManager.maxMemoryUsage, equals(1024));
      });
    });

    group('command execution', () {
      test('should execute command and add to undo history', () async {
        final command = MockCommand('test-1', 'Test command 1');

        await undoManager.execute(command);

        expect(command.wasExecuted, isTrue);
        expect(undoManager.canUndo, isTrue);
        expect(undoManager.canRedo, isFalse);
        expect(undoManager.undoHistory.length, equals(1));
        expect(undoManager.undoHistory.first, equals(command));
      });

      test('should clear redo history when executing new command', () async {
        final command1 = MockCommand('test-1', 'Test command 1');
        final command2 = MockCommand('test-2', 'Test command 2');
        final command3 = MockCommand('test-3', 'Test command 3');

        // Execute, undo, then execute new command
        await undoManager.execute(command1);
        await undoManager.undo();
        await undoManager.execute(command2);

        expect(undoManager.canRedo, isFalse);
        expect(undoManager.redoHistory, isEmpty);
        expect(undoManager.undoHistory.length, equals(1));
        expect(undoManager.undoHistory.first, equals(command2));
      });

      test('should track memory usage', () async {
        final command = MockCommand(
          'test-1',
          'Test command 1',
          memoryUsage: 100,
        );

        await undoManager.execute(command);

        expect(undoManager.currentMemoryUsage, equals(100));
      });
    });

    group('undo operations', () {
      test('should undo command and move to redo history', () async {
        final command = MockCommand('test-1', 'Test command 1');

        await undoManager.execute(command);
        await undoManager.undo();

        expect(command.wasUndone, isTrue);
        expect(undoManager.canUndo, isFalse);
        expect(undoManager.canRedo, isTrue);
        expect(undoManager.undoHistory, isEmpty);
        expect(undoManager.redoHistory.length, equals(1));
        expect(undoManager.redoHistory.first, equals(command));
      });

      test('should throw when trying to undo with empty history', () async {
        expect(() => undoManager.undo(), throwsA(isA<UndoStateException>()));
      });

      test('should maintain memory usage after undo', () async {
        final command = MockCommand(
          'test-1',
          'Test command 1',
          memoryUsage: 100,
        );

        await undoManager.execute(command);
        await undoManager.undo();

        expect(undoManager.currentMemoryUsage, equals(100));
      });
    });

    group('redo operations', () {
      test('should redo command and move back to undo history', () async {
        final command = MockCommand('test-1', 'Test command 1');

        await undoManager.execute(command);
        await undoManager.undo();
        await undoManager.redo();

        expect(command.wasRedone, isTrue);
        expect(undoManager.canUndo, isTrue);
        expect(undoManager.canRedo, isFalse);
        expect(undoManager.undoHistory.length, equals(1));
        expect(undoManager.undoHistory.first, equals(command));
        expect(undoManager.redoHistory, isEmpty);
      });

      test(
        'should throw when trying to redo with empty redo history',
        () async {
          expect(() => undoManager.redo(), throwsA(isA<UndoStateException>()));
        },
      );
    });

    group('command merging', () {
      test('should merge compatible commands', () async {
        final command1 = MockMergeableCommand(
          'test-1',
          'Test 1',
          canMerge: true,
        );
        final command2 = MockMergeableCommand(
          'test-2',
          'Test 2',
          canMerge: true,
        );
        command1.setMergeTarget(command2);

        await undoManager.execute(command1);
        await undoManager.execute(command2);

        expect(undoManager.undoHistory.length, equals(1));
        expect(undoManager.undoHistory.first, isA<MockMergeableCommand>());

        final mergedCommand =
            undoManager.undoHistory.first as MockMergeableCommand;
        expect(mergedCommand.wasMerged, isTrue);
      });

      test('should not merge incompatible commands', () async {
        final command1 = MockCommand('test-1', 'Test 1');
        final command2 = MockCommand('test-2', 'Test 2');

        await undoManager.execute(command1);
        await undoManager.execute(command2);

        expect(undoManager.undoHistory.length, equals(2));
      });
    });

    group('history limits', () {
      test('should enforce maximum history size', () async {
        // Execute more commands than the limit
        for (int i = 0; i < 7; i++) {
          final command = MockCommand('test-$i', 'Test command $i');
          await undoManager.execute(command);
        }

        expect(undoManager.undoHistory.length, equals(5)); // Max limit
        expect(undoManager.historySize, equals(5));
      });

      test('should enforce maximum memory usage', () async {
        // Create commands that would exceed memory limit
        final command1 = MockCommand('test-1', 'Test 1', memoryUsage: 600);
        final command2 = MockCommand('test-2', 'Test 2', memoryUsage: 600);

        await undoManager.execute(command1);
        await undoManager.execute(command2);

        // Should prune older commands to stay under limit
        expect(undoManager.currentMemoryUsage, lessThanOrEqualTo(1024));
      });
    });

    group('clear operation', () {
      test('should clear all history', () async {
        final command1 = MockCommand('test-1', 'Test 1');
        final command2 = MockCommand('test-2', 'Test 2');

        await undoManager.execute(command1);
        await undoManager.execute(command2);
        await undoManager.undo();

        undoManager.clear();

        expect(undoManager.canUndo, isFalse);
        expect(undoManager.canRedo, isFalse);
        expect(undoManager.undoHistory, isEmpty);
        expect(undoManager.redoHistory, isEmpty);
        expect(undoManager.currentMemoryUsage, equals(0));
      });
    });

    group('history changes stream', () {
      test('should emit events for operations', () async {
        final events = <UndoHistoryChange>[];
        final subscription = undoManager.historyChanges.listen(events.add);

        final command = MockCommand('test-1', 'Test command');

        await undoManager.execute(command);
        await undoManager.undo();
        await undoManager.redo();
        undoManager.clear();

        await subscription.cancel();

        expect(events.length, equals(4));
        expect(events[0], isA<CommandExecuted>());
        expect(events[1], isA<CommandUndone>());
        expect(events[2], isA<CommandRedone>());
        expect(events[3], isA<HistoryCleared>());
      });
    });

    group('concurrent operations', () {
      test('should prevent concurrent execute operations', () async {
        final command1 = MockSlowCommand('test-1', 'Slow command 1');
        final command2 = MockCommand('test-2', 'Fast command 2');

        // Start slow command
        final future1 = undoManager.execute(command1);

        // Try to execute another command while first is running
        expect(
          () => undoManager.execute(command2),
          throwsA(isA<UndoStateException>()),
        );

        await future1;
      });

      test('should prevent undo during execute', () async {
        final command = MockSlowCommand('test-1', 'Slow command');

        final future = undoManager.execute(command);

        expect(() => undoManager.undo(), throwsA(isA<UndoStateException>()));

        await future;
      });
    });
  });
}
