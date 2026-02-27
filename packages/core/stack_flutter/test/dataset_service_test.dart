/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import 'package:core_stack/src/model/dataset.dart';
import 'package:core_stack/src/model/stack.dart';
import 'package:core_stack/src/model/stack_info.dart';
import 'package:core_stack/src/model/stack_settings.dart';
import 'package:core_stack/src/service/dataset_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatasetService', () {
    late DatasetService service;
    late Directory tempDir;
    late Stack testStack;

    setUp(() async {
      service = DatasetService();

      // テスト用の一時ディレクトリを作成
      tempDir = await Directory.systemTemp.createTemp('dataset_test_');
      final stackDir = Directory('${tempDir.path}/test_stack.stack');
      await stackDir.create();

      // テスト用のスタックを作成
      final now = DateTime.now();
      testStack = Stack(
        directory: stackDir,
        info: StackInfo(
          name: 'Test Stack',
          description: 'Test stack for dataset service tests',
          version: '1.0.0',
          createdAt: now,
          lastModifiedAt: now,
        ),
        settings: const StackSettings(),
      );

      // データセットディレクトリを作成
      final datasetsDir = Directory('${stackDir.path}/datasets');
      await datasetsDir.create();

      // テスト用のデータセットファイルを作成
      await _createTestDatasetFile(datasetsDir, 'test_movies.json', {
        'name': 'test_movies',
        'description': 'Test movies dataset',
        'filter': {
          'entity_labels': ['Movie'],
          'properties': {
            'genre': ['Action', 'Drama'],
          },
        },
        'created': '2025-01-01T00:00:00.000000',
      });

      await _createTestDatasetFile(datasetsDir, 'test_people.json', {
        'name': 'test_people',
        'description': 'Test people dataset',
        'filter': {
          'entity_labels': ['Person'],
          'properties': {
            'role': ['Director', 'Actor'],
          },
        },
        'created': '2025-01-02T00:00:00.000000',
      });
    });

    tearDown(() async {
      // テスト用ディレクトリを削除
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('getDatasets', () {
      test('should return all datasets in the stack', () async {
        final datasets = await service.getDatasets(testStack);

        expect(datasets, hasLength(2));
        expect(
          datasets.map((d) => d.name),
          containsAll(['test_movies', 'test_people']),
        );
      });

      test(
        'should return empty list when no datasets directory exists',
        () async {
          // データセットディレクトリを削除
          final datasetsDir = Directory('${testStack.directory.path}/datasets');
          await datasetsDir.delete(recursive: true);

          final datasets = await service.getDatasets(testStack);
          expect(datasets, isEmpty);
        },
      );

      test('should sort datasets by creation date (newest first)', () async {
        final datasets = await service.getDatasets(testStack);

        expect(datasets[0].name, equals('test_people')); // 2025-01-02
        expect(datasets[1].name, equals('test_movies')); // 2025-01-01
      });
    });

    group('getDataset', () {
      test('should return dataset by ID', () async {
        final datasets = await service.getDatasets(testStack);
        final firstDataset = datasets.first;

        final found = await service.getDataset(testStack, firstDataset.id);
        expect(found, isNotNull);
        expect(found!.id, equals(firstDataset.id));
        expect(found.name, equals(firstDataset.name));
      });

      test('should return null for non-existent ID', () async {
        final found = await service.getDataset(testStack, 'non_existent_id');
        expect(found, isNull);
      });
    });

    group('getDatasetByName', () {
      test('should return dataset by name', () async {
        final found = await service.getDatasetByName(testStack, 'test_movies');
        expect(found, isNotNull);
        expect(found!.name, equals('test_movies'));
        expect(found.description, equals('Test movies dataset'));
      });

      test('should return null for non-existent name', () async {
        final found = await service.getDatasetByName(testStack, 'non_existent');
        expect(found, isNull);
      });
    });

    group('createDataset', () {
      test('should create a new dataset', () async {
        const filter = DatasetFilter(
          entityLabels: ['Book'],
          properties: {
            'category': ['Fiction'],
          },
        );

        final dataset = await service.createDataset(
          testStack,
          'test_books',
          'Test books dataset',
          filter: filter,
          metadata: const {'author': 'test'},
        );

        expect(dataset.name, equals('test_books'));
        expect(dataset.description, equals('Test books dataset'));
        expect(dataset.filter, isNotNull);
        expect(dataset.filter!.entityLabels, contains('Book'));
        expect(dataset.metadata['author'], equals('test'));

        // ファイルが作成されているか確認
        final file = File(
          '${testStack.directory.path}/datasets/test_books.json',
        );
        expect(await file.exists(), isTrue);
      });

      test('should throw error for duplicate dataset name', () async {
        expect(
          () async => service.createDataset(
            testStack,
            'test_movies', // 既存の名前
            'Duplicate dataset',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('updateDataset', () {
      test('should update existing dataset', () async {
        final datasets = await service.getDatasets(testStack);
        final originalDataset = datasets.firstWhere(
          (d) => d.name == 'test_movies',
        );

        final updatedDataset = await service.updateDataset(
          testStack,
          originalDataset.id,
          name: 'updated_movies',
          description: 'Updated description',
        );

        expect(updatedDataset.name, equals('updated_movies'));
        expect(updatedDataset.description, equals('Updated description'));
        expect(updatedDataset.modified, isNotNull);

        // 元のファイルが削除され、新しいファイルが作成されているか確認
        final oldFile = File(
          '${testStack.directory.path}/datasets/test_movies.json',
        );
        final newFile = File(
          '${testStack.directory.path}/datasets/updated_movies.json',
        );
        expect(await oldFile.exists(), isFalse);
        expect(await newFile.exists(), isTrue);
      });

      test('should throw error for non-existent dataset', () async {
        expect(
          () async => service.updateDataset(
            testStack,
            'non_existent_id',
            name: 'new_name',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('deleteDataset', () {
      test('should delete existing dataset', () async {
        final datasets = await service.getDatasets(testStack);
        final targetDataset = datasets.firstWhere(
          (d) => d.name == 'test_movies',
        );

        final success = await service.deleteDataset(
          testStack,
          targetDataset.id,
        );
        expect(success, isTrue);

        // ファイルが削除されているか確認
        final file = File(
          '${testStack.directory.path}/datasets/test_movies.json',
        );
        expect(await file.exists(), isFalse);

        // データセットリストから削除されているか確認
        final remainingDatasets = await service.getDatasets(testStack);
        expect(
          remainingDatasets.map((d) => d.name),
          isNot(contains('test_movies')),
        );
      });

      test('should return false for non-existent dataset', () async {
        final success = await service.deleteDataset(
          testStack,
          'non_existent_id',
        );
        expect(success, isFalse);
      });
    });

    group('getFilteredDatasets', () {
      test('should filter by entity labels', () async {
        final filtered = await service.getFilteredDatasets(
          testStack,
          entityLabels: ['Movie'],
        );

        expect(filtered, hasLength(1));
        expect(filtered.first.name, equals('test_movies'));
      });

      test('should filter by name pattern', () async {
        final filtered = await service.getFilteredDatasets(
          testStack,
          namePattern: 'movies',
        );

        expect(filtered, hasLength(1));
        expect(filtered.first.name, equals('test_movies'));
      });

      test('should filter by creation date range', () async {
        final createdAfter = DateTime.parse('2025-01-01T12:00:00.000000');

        final filtered = await service.getFilteredDatasets(
          testStack,
          createdAfter: createdAfter,
        );

        expect(filtered, hasLength(1));
        expect(filtered.first.name, equals('test_people'));
      });
    });

    group('getDatasetStatistics', () {
      test('should return correct statistics', () async {
        final stats = await service.getDatasetStatistics(testStack);

        expect(stats['total'], equals(2));
        expect(stats['withFilter'], equals(2));
        expect(stats['withoutFilter'], equals(0));
        expect(stats['entityLabels'], containsAll(['Movie', 'Person']));
        expect(stats['uniqueEntityLabels'], equals(2));
      });
    });

    group('validateDataset', () {
      test('should return no errors for valid dataset', () {
        final dataset = Dataset.create(
          name: 'valid_dataset',
          description: 'Valid dataset description',
        );

        final errors = service.validateDataset(dataset);
        expect(errors, isEmpty);
      });

      test('should return errors for invalid dataset', () {
        final dataset = Dataset.create(
          name: '', // 空の名前
          description: '', // 空の説明
        );

        final errors = service.validateDataset(dataset);
        expect(errors, isNotEmpty);
        expect(errors, contains('Dataset name cannot be empty'));
        expect(errors, contains('Dataset description cannot be empty'));
      });

      test('should return error for invalid file name characters', () {
        final dataset = Dataset.create(
          name: 'invalid<>name', // ファイル名に使えない文字
          description: 'Valid description',
        );

        final errors = service.validateDataset(dataset);
        expect(
          errors,
          contains('Dataset name contains invalid characters for file names'),
        );
      });
    });

    group('duplicateDataset', () {
      test('should create a duplicate with new name', () async {
        final datasets = await service.getDatasets(testStack);
        final originalDataset = datasets.firstWhere(
          (d) => d.name == 'test_movies',
        );

        final duplicated = await service.duplicateDataset(
          testStack,
          originalDataset.id,
          'duplicated_movies',
        );

        expect(duplicated.name, equals('duplicated_movies'));
        expect(
          duplicated.description,
          equals('${originalDataset.description} (copy)'),
        );
        expect(
          duplicated.filter!.entityLabels,
          equals(originalDataset.filter!.entityLabels),
        );
        expect(duplicated.id, isNot(equals(originalDataset.id)));

        // 元のデータセットも残っているか確認
        final allDatasets = await service.getDatasets(testStack);
        expect(
          allDatasets.map((d) => d.name),
          containsAll(['test_movies', 'duplicated_movies']),
        );
      });
    });
  });
}

// ヘルパー関数：テスト用のデータセットファイルを作成
Future<void> _createTestDatasetFile(
  Directory datasetsDir,
  String fileName,
  Map<String, dynamic> data,
) async {
  final file = File('${datasetsDir.path}/$fileName');
  final jsonString = const JsonEncoder.withIndent('  ').convert(data);
  await file.writeAsString(jsonString);
}
