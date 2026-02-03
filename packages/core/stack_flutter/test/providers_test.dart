import 'package:core_stack_flutter/core_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Stack Providers', () {
    test('Documents directory provider returns directory', () async {
      final container = ProviderContainer();

      final documentsDir = await container.read(
        documentsDirectoryProvider.future,
      );

      // Verify that the documents directory can be retrieved
      expect(documentsDir.path, isNotEmpty);
      expect(documentsDir.existsSync(), isTrue);

      container.dispose();
    });

    test('Stack search directory provider returns directory', () async {
      final container = ProviderContainer();

      final searchDir = await container.read(
        stackSearchDirectoryProvider.future,
      );

      // Verify that the stack search directory can be retrieved
      expect(searchDir.path, isNotEmpty);
      expect(searchDir.path.contains('App'), isTrue);

      container.dispose();
    });

    test('Scratches directory provider returns directory', () async {
      final container = ProviderContainer();

      final scratchesDir = await container.read(
        scratchesDirectoryProvider.future,
      );

      // Verify that the scratches directory can be retrieved
      expect(scratchesDir.path, isNotEmpty);
      expect(scratchesDir.path.contains('Scratches'), isTrue);

      container.dispose();
    });

    test('Refresh stacks trigger provider works', () {
      final container = ProviderContainer();

      final initialCount = container.read(refreshStacksTriggerProvider);
      expect(initialCount, 0);

      // Execute the trigger
      container.read(refreshStacksTriggerProvider.notifier).trigger();

      final newCount = container.read(refreshStacksTriggerProvider);
      expect(newCount, 1);

      container.dispose();
    });

    test('Available stacks list provider returns list', () async {
      final container = ProviderContainer();

      final stacksList = await container.read(
        availableStacksListProvider.future,
      );

      // Verify that the stack list can be retrieved (can be empty)
      expect(stacksList, isA<List<Stack>>());

      container.dispose();
    });

    test('Stack actions provider trigger refresh works', () {
      final container = ProviderContainer();

      final actions = container.read(stackActionsProvider.notifier);
      final initialCount = container.read(refreshStacksTriggerProvider);

      // Trigger refresh from action
      actions.triggerRefresh();

      final newCount = container.read(refreshStacksTriggerProvider);
      expect(newCount, initialCount + 1);

      container.dispose();
    });
  });
}
