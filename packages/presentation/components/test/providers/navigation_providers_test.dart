/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart';
import 'package:presentation_components/src/providers/navigation_providers.dart';

void main() {
  group('NavigationProviders', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('NavigationStateData', () {
      test('creates instance with required parameters', () {
        final entityId1 = EntityId();
        final entityId2 = EntityId();

        final data = NavigationStateData(
          expandedGroupIds: [entityId1, entityId2],
          selectedItemId: entityId1,
        );

        expect(data.expandedGroupIds, hasLength(2));
        expect(data.expandedGroupIds, contains(entityId1));
        expect(data.expandedGroupIds, contains(entityId2));
        expect(data.selectedItemId, equals(entityId1));
      });

      test('creates instance with empty expanded groups', () {
        final data = NavigationStateData(
          expandedGroupIds: [],
          selectedItemId: null,
        );

        expect(data.expandedGroupIds, isEmpty);
        expect(data.selectedItemId, isNull);
      });

      test(
        'copyWith preserves original values when no parameters provided',
        () {
          final entityId1 = EntityId();
          final entityId2 = EntityId();

          final original = NavigationStateData(
            expandedGroupIds: [entityId1],
            selectedItemId: entityId2,
          );

          final copied = original.copyWith();

          expect(copied.expandedGroupIds, equals(original.expandedGroupIds));
          expect(copied.selectedItemId, equals(original.selectedItemId));
          expect(
            copied.expandedGroupIds,
            isNot(same(original.expandedGroupIds)),
          );
        },
      );

      test('copyWith updates expandedGroupIds when provided', () {
        final entityId1 = EntityId();
        final entityId2 = EntityId();
        final entityId3 = EntityId();

        final original = NavigationStateData(
          expandedGroupIds: [entityId1],
          selectedItemId: entityId2,
        );

        final updated = original.copyWith(expandedGroupIds: [entityId3]);

        expect(updated.expandedGroupIds, equals([entityId3]));
        expect(updated.selectedItemId, equals(entityId2)); // Unchanged
      });

      test('copyWith updates selectedItemId when provided', () {
        final entityId1 = EntityId();
        final entityId2 = EntityId();
        final entityId3 = EntityId();

        final original = NavigationStateData(
          expandedGroupIds: [entityId1],
          selectedItemId: entityId2,
        );

        final updated = original.copyWith(selectedItemId: entityId3);

        expect(updated.expandedGroupIds, equals([entityId1])); // Unchanged
        expect(updated.selectedItemId, equals(entityId3));
      });

      test('copyWith can set selectedItemId to null', () {
        final entityId1 = EntityId();
        final entityId2 = EntityId();

        final original = NavigationStateData(
          expandedGroupIds: [entityId1],
          selectedItemId: entityId2,
        );

        final updated = original.copyWith(selectedItemId: null);

        expect(updated.selectedItemId, isNull);
      });

      test('copyWith updates both parameters when provided', () {
        final entityId1 = EntityId();
        final entityId2 = EntityId();
        final entityId3 = EntityId();
        final entityId4 = EntityId();

        final original = NavigationStateData(
          expandedGroupIds: [entityId1],
          selectedItemId: entityId2,
        );

        final updated = original.copyWith(
          expandedGroupIds: [entityId3, entityId4],
          selectedItemId: entityId3,
        );

        expect(updated.expandedGroupIds, equals([entityId3, entityId4]));
        expect(updated.selectedItemId, equals(entityId3));
      });
    });

    group('NavigationStateProvider', () {
      test('has correct initial state', () {
        final state = container.read(navigationStateProvider);

        expect(state.expandedGroupIds, isEmpty);
        expect(state.selectedItemId, isNull);
      });

      test('toggleGroup expands closed group', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupId = EntityId();

        // Initial state - group is not expanded
        expect(notifier.isGroupExpanded(groupId), isFalse);

        // Toggle to expand
        notifier.toggleGroup(groupId);

        final state = container.read(navigationStateProvider);
        expect(state.expandedGroupIds, contains(groupId));
        expect(notifier.isGroupExpanded(groupId), isTrue);
      });

      test('toggleGroup collapses expanded group', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupId = EntityId();

        // First, expand the group
        notifier.toggleGroup(groupId);
        expect(notifier.isGroupExpanded(groupId), isTrue);

        // Then toggle to collapse
        notifier.toggleGroup(groupId);

        final state = container.read(navigationStateProvider);
        expect(state.expandedGroupIds, isNot(contains(groupId)));
        expect(notifier.isGroupExpanded(groupId), isFalse);
      });

      test('toggleGroup handles multiple groups independently', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupId1 = EntityId();
        final groupId2 = EntityId();
        final groupId3 = EntityId();

        // Expand groups 1 and 2
        notifier.toggleGroup(groupId1);
        notifier.toggleGroup(groupId2);

        expect(notifier.isGroupExpanded(groupId1), isTrue);
        expect(notifier.isGroupExpanded(groupId2), isTrue);
        expect(notifier.isGroupExpanded(groupId3), isFalse);

        // Collapse group 1, keep group 2 expanded
        notifier.toggleGroup(groupId1);

        expect(notifier.isGroupExpanded(groupId1), isFalse);
        expect(notifier.isGroupExpanded(groupId2), isTrue);
        expect(notifier.isGroupExpanded(groupId3), isFalse);

        // Expand group 3
        notifier.toggleGroup(groupId3);

        final state = container.read(navigationStateProvider);
        expect(state.expandedGroupIds, hasLength(2));
        expect(state.expandedGroupIds, contains(groupId2));
        expect(state.expandedGroupIds, contains(groupId3));
        expect(state.expandedGroupIds, isNot(contains(groupId1)));
      });

      test('selectItem sets selected item', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final itemId = EntityId();

        notifier.selectItem(itemId);

        final state = container.read(navigationStateProvider);
        expect(state.selectedItemId, equals(itemId));
        expect(notifier.isItemSelected(itemId), isTrue);
      });

      test('selectItem changes selection to new item', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final itemId1 = EntityId();
        final itemId2 = EntityId();

        // Select first item
        notifier.selectItem(itemId1);
        expect(notifier.isItemSelected(itemId1), isTrue);
        expect(notifier.isItemSelected(itemId2), isFalse);

        // Select second item
        notifier.selectItem(itemId2);
        expect(notifier.isItemSelected(itemId1), isFalse);
        expect(notifier.isItemSelected(itemId2), isTrue);

        final state = container.read(navigationStateProvider);
        expect(state.selectedItemId, equals(itemId2));
      });

      test('clearSelection removes selected item', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final itemId = EntityId();

        // First select an item
        notifier.selectItem(itemId);
        expect(notifier.isItemSelected(itemId), isTrue);

        // Then clear selection
        notifier.clearSelection();

        final state = container.read(navigationStateProvider);
        expect(state.selectedItemId, isNull);
        expect(notifier.isItemSelected(itemId), isFalse);
      });

      test('isGroupExpanded returns correct values', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupId1 = EntityId();
        final groupId2 = EntityId();

        // Initially, no groups are expanded
        expect(notifier.isGroupExpanded(groupId1), isFalse);
        expect(notifier.isGroupExpanded(groupId2), isFalse);

        // Expand group1
        notifier.toggleGroup(groupId1);
        expect(notifier.isGroupExpanded(groupId1), isTrue);
        expect(notifier.isGroupExpanded(groupId2), isFalse);

        // Expand group2
        notifier.toggleGroup(groupId2);
        expect(notifier.isGroupExpanded(groupId1), isTrue);
        expect(notifier.isGroupExpanded(groupId2), isTrue);

        // Collapse group1
        notifier.toggleGroup(groupId1);
        expect(notifier.isGroupExpanded(groupId1), isFalse);
        expect(notifier.isGroupExpanded(groupId2), isTrue);
      });

      test('isItemSelected returns correct values', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final itemId1 = EntityId();
        final itemId2 = EntityId();

        // Initially, no items are selected
        expect(notifier.isItemSelected(itemId1), isFalse);
        expect(notifier.isItemSelected(itemId2), isFalse);

        // Select item1
        notifier.selectItem(itemId1);
        expect(notifier.isItemSelected(itemId1), isTrue);
        expect(notifier.isItemSelected(itemId2), isFalse);

        // Select item2
        notifier.selectItem(itemId2);
        expect(notifier.isItemSelected(itemId1), isFalse);
        expect(notifier.isItemSelected(itemId2), isTrue);

        // Clear selection
        notifier.clearSelection();
        expect(notifier.isItemSelected(itemId1), isFalse);
        expect(notifier.isItemSelected(itemId2), isFalse);
      });
    });

    group('Provider State Notifications', () {
      test('notifies listeners when group is toggled', () {
        var notificationCount = 0;
        container.listen(navigationStateProvider, (previous, next) {
          notificationCount++;
        });

        final notifier = container.read(navigationStateProvider.notifier);
        final groupId = EntityId();

        notifier.toggleGroup(groupId);
        expect(notificationCount, equals(1));

        notifier.toggleGroup(groupId);
        expect(notificationCount, equals(2));
      });

      test('notifies listeners when item is selected', () {
        var notificationCount = 0;
        container.listen(navigationStateProvider, (previous, next) {
          notificationCount++;
        });

        final notifier = container.read(navigationStateProvider.notifier);
        final itemId = EntityId();

        notifier.selectItem(itemId);
        expect(notificationCount, equals(1));

        notifier.selectItem(EntityId());
        expect(notificationCount, equals(2));
      });

      test('notifies listeners when selection is cleared', () {
        var notificationCount = 0;
        final notifier = container.read(navigationStateProvider.notifier);

        // Select an item first
        notifier.selectItem(EntityId());

        // Start listening after initial selection
        container.listen(navigationStateProvider, (previous, next) {
          notificationCount++;
        });

        notifier.clearSelection();
        expect(notificationCount, equals(1));
      });
    });

    group('Complex State Scenarios', () {
      test('handles multiple rapid operations', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupIds = List.generate(5, (_) => EntityId());
        final itemIds = List.generate(3, (_) => EntityId());

        // Rapid group toggles
        for (final groupId in groupIds) {
          notifier.toggleGroup(groupId);
        }

        // Rapid item selections
        for (final itemId in itemIds) {
          notifier.selectItem(itemId);
        }

        final state = container.read(navigationStateProvider);
        expect(state.expandedGroupIds, hasLength(5));
        expect(state.selectedItemId, equals(itemIds.last));

        // All groups should be expanded
        for (final groupId in groupIds) {
          expect(notifier.isGroupExpanded(groupId), isTrue);
        }

        // Only the last item should be selected
        for (int i = 0; i < itemIds.length - 1; i++) {
          expect(notifier.isItemSelected(itemIds[i]), isFalse);
        }
        expect(notifier.isItemSelected(itemIds.last), isTrue);
      });

      test('maintains state consistency during mixed operations', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupId1 = EntityId();
        final groupId2 = EntityId();
        final itemId1 = EntityId();
        final itemId2 = EntityId();

        // Complex sequence of operations
        notifier.toggleGroup(groupId1);
        notifier.selectItem(itemId1);
        notifier.toggleGroup(groupId2);
        notifier.selectItem(itemId2);
        notifier.toggleGroup(groupId1); // Collapse first group
        notifier.clearSelection();

        final state = container.read(navigationStateProvider);

        // Verify final state
        expect(state.expandedGroupIds, hasLength(1));
        expect(state.expandedGroupIds, contains(groupId2));
        expect(state.expandedGroupIds, isNot(contains(groupId1)));
        expect(state.selectedItemId, isNull);

        // Verify helper methods
        expect(notifier.isGroupExpanded(groupId1), isFalse);
        expect(notifier.isGroupExpanded(groupId2), isTrue);
        expect(notifier.isItemSelected(itemId1), isFalse);
        expect(notifier.isItemSelected(itemId2), isFalse);
      });

      test('handles same EntityId for different purposes', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final sharedId = EntityId();

        // Use same EntityId as both group and item
        notifier.toggleGroup(sharedId);
        notifier.selectItem(sharedId);

        final state = container.read(navigationStateProvider);

        expect(state.expandedGroupIds, contains(sharedId));
        expect(state.selectedItemId, equals(sharedId));
        expect(notifier.isGroupExpanded(sharedId), isTrue);
        expect(notifier.isItemSelected(sharedId), isTrue);
      });
    });

    group('Edge Cases', () {
      test('handles duplicate group toggle operations', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final groupId = EntityId();

        // Toggle multiple times in succession
        notifier.toggleGroup(groupId);
        notifier.toggleGroup(groupId);
        notifier.toggleGroup(groupId);

        // Should end up expanded (odd number of toggles)
        expect(notifier.isGroupExpanded(groupId), isTrue);

        final state = container.read(navigationStateProvider);
        expect(state.expandedGroupIds, contains(groupId));
        expect(
          state.expandedGroupIds.where((id) => id == groupId),
          hasLength(1),
        );
      });

      test('selecting same item multiple times', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final itemId = EntityId();

        notifier.selectItem(itemId);
        notifier.selectItem(itemId);
        notifier.selectItem(itemId);

        final state = container.read(navigationStateProvider);
        expect(state.selectedItemId, equals(itemId));
        expect(notifier.isItemSelected(itemId), isTrue);
      });

      test('clearing selection when nothing is selected', () {
        final notifier = container.read(navigationStateProvider.notifier);

        // Clear selection when already empty
        notifier.clearSelection();
        notifier.clearSelection();

        final state = container.read(navigationStateProvider);
        expect(state.selectedItemId, isNull);
      });

      test('operations with many EntityIds', () {
        final notifier = container.read(navigationStateProvider.notifier);
        final manyGroupIds = List.generate(100, (_) => EntityId());

        // Expand many groups
        for (final groupId in manyGroupIds) {
          notifier.toggleGroup(groupId);
        }

        final state = container.read(navigationStateProvider);
        expect(state.expandedGroupIds, hasLength(100));

        // Verify all are expanded
        for (final groupId in manyGroupIds) {
          expect(notifier.isGroupExpanded(groupId), isTrue);
        }

        // Collapse some groups
        for (int i = 0; i < 50; i++) {
          notifier.toggleGroup(manyGroupIds[i]);
        }

        final finalState = container.read(navigationStateProvider);
        expect(finalState.expandedGroupIds, hasLength(50));
      });
    });
  });
}
