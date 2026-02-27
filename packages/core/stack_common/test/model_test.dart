/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:test/test.dart';
import 'package:core_stack_common/core_stack_common.dart';

void main() {
  group('StackInfo', () {
    test('should create instance with required fields', () {
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      expect(stackInfo.name, equals('Test Stack'));
      expect(stackInfo.createdAt, equals(now));
      expect(stackInfo.lastModifiedAt, equals(now));
      expect(stackInfo.version, equals('1.0.0'));
    });

    test('should create instance with optional fields', () {
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
        description: 'Test description',
      );

      expect(stackInfo.description, equals('Test description'));
    });
  });

  group('DatasetFilter', () {
    test('should create instance', () {
      final filter = DatasetFilter(
        entityLabels: ['person', 'company'],
        properties: {
          'name': ['test'],
        },
      );

      expect(filter.entityLabels, equals(['person', 'company']));
      expect(
        filter.properties,
        equals({
          'name': ['test'],
        }),
      );
    });

    test('should be equal when same values', () {
      final filter1 = DatasetFilter(
        entityLabels: ['person'],
        properties: {
          'name': ['test'],
        },
      );
      final filter2 = DatasetFilter(
        entityLabels: ['person'],
        properties: {
          'name': ['test'],
        },
      );

      expect(filter1, equals(filter2));
    });
  });

  group('Dataset', () {
    test('should create instance', () {
      final filter = DatasetFilter(entityLabels: ['person'], properties: {});
      final now = DateTime.now();
      final dataset = Dataset(
        id: 'test-id',
        name: 'Test Dataset',
        description: 'Test description',
        type: DatasetType.saved,
        created: now,
        filter: filter,
      );

      expect(dataset.name, equals('Test Dataset'));
      expect(dataset.filter, equals(filter));
      expect(dataset.id, equals('test-id'));
      expect(dataset.type, equals(DatasetType.saved));
    });
  });
}
