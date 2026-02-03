import 'package:flutter_test/flutter_test.dart';
import 'package:core_undo/undo.dart';
import '../mocks/mock_graph_context.dart';
import '../mocks/mock_command.dart';

void main() {
  group('UndoManager Basic Tests', () {
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

    test('should start with empty history', () {
      expect(undoManager.canUndo, isFalse);
      expect(undoManager.canRedo, isFalse);
      expect(undoManager.historySize, equals(0));
      expect(undoManager.currentMemoryUsage, equals(0));
      expect(undoManager.undoHistory, isEmpty);
      expect(undoManager.redoHistory, isEmpty);
    });

    test('should execute command and add to undo history', () async {
      final command = MockCommand('test-1', 'Test command 1');

      await undoManager.execute(command);

      expect(command.wasExecuted, isTrue);
      expect(undoManager.canUndo, isTrue);
      expect(undoManager.canRedo, isFalse);
      expect(undoManager.undoHistory.length, equals(1));
      expect(undoManager.undoHistory.first, equals(command));
    });

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

    test('should clear redo history when executing new command', () async {
      final command1 = MockCommand('test-1', 'Test command 1');
      final command2 = MockCommand('test-2', 'Test command 2');

      // Execute, undo, then execute new command
      await undoManager.execute(command1);
      await undoManager.undo();
      await undoManager.execute(command2);

      expect(undoManager.canRedo, isFalse);
      expect(undoManager.redoHistory, isEmpty);
      expect(undoManager.undoHistory.length, equals(1));
      expect(undoManager.undoHistory.first, equals(command2));
    });

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

    test('should track memory usage', () async {
      final command = MockCommand('test-1', 'Test command 1', memoryUsage: 100);

      await undoManager.execute(command);

      expect(undoManager.currentMemoryUsage, equals(100));
    });

    test('should enforce maximum history size', () async {
      // Execute more commands than the limit
      for (int i = 0; i < 7; i++) {
        final command = MockCommand('test-$i', 'Test command $i');
        await undoManager.execute(command);
      }

      expect(undoManager.undoHistory.length, equals(5)); // Max limit
      expect(undoManager.historySize, equals(5));
    });

    test('should emit history change events', () async {
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

    test('should merge compatible commands', () async {
      final command1 = MockMergeableCommand('test-1', 'Test 1', canMerge: true);
      final command2 = MockMergeableCommand('test-2', 'Test 2', canMerge: true);
      command1.setMergeTarget(command2);

      await undoManager.execute(command1);
      await undoManager.execute(command2);

      expect(undoManager.undoHistory.length, equals(1));

      final mergedCommand =
          undoManager.undoHistory.first as MockMergeableCommand;
      expect(mergedCommand.wasMerged, isTrue);
    });
  });
}
