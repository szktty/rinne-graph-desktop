import 'dart:convert';
import 'dart:io';

import 'package:core_stack/src/api/dataset_api.dart';
import 'package:core_stack/src/model/dataset.dart';
import 'package:core_stack/src/model/stack.dart';
import 'package:core_stack/src/model/stack_info.dart';
import 'package:core_stack/src/model/stack_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatasetApi', () {
    late DatasetApi api;
    late Directory tempDir;
    late Stack testStack;

    setUp(() async {
      api = DatasetApi();

      // テスト用の一時ディレクトリを作成
      tempDir = await Directory.systemTemp.createTemp('dataset_api_test_');
      final stackDir = Directory('${tempDir.path}/test_stack.stack');
      await stackDir.create();

      // テスト用のスタックを作成
      final now = DateTime.now();
      testStack = Stack(
        directory: stackDir,
        info: StackInfo(
          name: 'Test Stack',
          description: 'Test stack for dataset API tests',
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
      await _createTestDatasetFile(datasetsDir, 'existing_dataset.json', {
        'name': 'existing_dataset',
        'description': 'Existing test dataset',
        'filter': {
          'entity_labels': ['Test'],
          'properties': {
            'type': ['sample'],
          },
        },
        'created': DateTime.now().toIso8601String(),
      });
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('listDatasets', () {
      test('should return success with datasets', () async {
        final result = await api.listDatasets(testStack);

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data, hasLength(1));
        expect(result.data!.first.name, equals('existing_dataset'));
        expect(result.error, isNull);
      });
    });

    group('getDataset', () {
      test('should return success for existing dataset', () async {
        final listResult = await api.listDatasets(testStack);
        final datasetId = listResult.data!.first.id;

        final result = await api.getDataset(testStack, datasetId);

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.id, equals(datasetId));
        expect(result.error, isNull);
      });

      test('should return error for non-existent dataset', () async {
        final result = await api.getDataset(testStack, 'non_existent_id');

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('Dataset not found'));
        expect(result.errorCode, equals('DATASET_NOT_FOUND'));
      });
    });

    group('getDatasetByName', () {
      test('should return success for existing dataset name', () async {
        final result = await api.getDatasetByName(
          testStack,
          'existing_dataset',
        );

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.name, equals('existing_dataset'));
        expect(result.error, isNull);
      });

      test('should return error for non-existent dataset name', () async {
        final result = await api.getDatasetByName(testStack, 'non_existent');

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('Dataset not found'));
        expect(result.errorCode, equals('DATASET_NOT_FOUND'));
      });
    });

    group('createDataset', () {
      test('should create dataset successfully', () async {
        const filter = DatasetFilter(
          entityLabels: ['NewType'],
          properties: {
            'category': ['test'],
          },
        );

        final result = await api.createDataset(
          testStack,
          name: 'new_dataset',
          description: 'New test dataset',
          filter: filter,
          metadata: const {'author': 'test'},
        );

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.name, equals('new_dataset'));
        expect(result.data!.description, equals('New test dataset'));
        expect(result.data!.filter, isNotNull);
        expect(result.data!.metadata['author'], equals('test'));
        expect(result.error, isNull);
      });

      test('should return error for empty name', () async {
        final result = await api.createDataset(
          testStack,
          name: '',
          description: 'Valid description',
        );

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('Dataset name cannot be empty'));
        expect(result.errorCode, equals('INVALID_INPUT'));
      });

      test('should return error for empty description', () async {
        final result = await api.createDataset(
          testStack,
          name: 'valid_name',
          description: '',
        );

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('Dataset description cannot be empty'));
        expect(result.errorCode, equals('INVALID_INPUT'));
      });

      test('should return error for duplicate name', () async {
        final result = await api.createDataset(
          testStack,
          name: 'existing_dataset',
          description: 'Duplicate dataset',
        );

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, isNotNull);
        expect(result.errorCode, equals('DATASET_ALREADY_EXISTS'));
      });
    });

    group('updateDataset', () {
      test('should update dataset successfully', () async {
        final listResult = await api.listDatasets(testStack);
        final datasetId = listResult.data!.first.id;

        final result = await api.updateDataset(
          testStack,
          datasetId,
          name: 'updated_dataset',
          description: 'Updated description',
        );

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.name, equals('updated_dataset'));
        expect(result.data!.description, equals('Updated description'));
        expect(result.data!.modified, isNotNull);
        expect(result.error, isNull);
      });

      test('should return error for non-existent dataset', () async {
        final result = await api.updateDataset(
          testStack,
          'non_existent_id',
          name: 'new_name',
        );

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, isNotNull);
        expect(result.errorCode, equals('DATASET_NOT_FOUND'));
      });

      test('should return error for empty name', () async {
        final listResult = await api.listDatasets(testStack);
        final datasetId = listResult.data!.first.id;

        final result = await api.updateDataset(testStack, datasetId, name: '');

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('Dataset name cannot be empty'));
        expect(result.errorCode, equals('INVALID_INPUT'));
      });
    });

    group('deleteDataset', () {
      test('should delete dataset successfully', () async {
        final listResult = await api.listDatasets(testStack);
        final datasetId = listResult.data!.first.id;

        final result = await api.deleteDataset(testStack, datasetId);

        expect(result.success, isTrue);
        expect(result.data, isTrue);
        expect(result.error, isNull);

        // データセットが削除されているか確認
        final afterDeleteResult = await api.listDatasets(testStack);
        expect(afterDeleteResult.data, isEmpty);
      });

      test('should return error for non-existent dataset', () async {
        final result = await api.deleteDataset(testStack, 'non_existent_id');

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('Dataset not found'));
        expect(result.errorCode, equals('DATASET_NOT_FOUND'));
      });
    });

    group('searchDatasets', () {
      test('should search datasets with entity labels', () async {
        final result = await api.searchDatasets(
          testStack,
          entityLabels: ['Test'],
        );

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data, hasLength(1));
        expect(result.error, isNull);
      });

      test('should search datasets with name pattern', () async {
        final result = await api.searchDatasets(
          testStack,
          namePattern: 'existing',
        );

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data, hasLength(1));
        expect(result.error, isNull);
      });
    });

    group('getDatasetStatistics', () {
      test('should return statistics successfully', () async {
        final result = await api.getDatasetStatistics(testStack);

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!['total'], equals(1));
        expect(result.data!['withFilter'], equals(1));
        expect(result.error, isNull);
      });
    });

    group('validateDataset', () {
      test('should return no errors for valid dataset', () {
        final dataset = Dataset.create(
          name: 'valid_dataset',
          description: 'Valid description',
        );

        final result = api.validateDataset(dataset);

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data, isEmpty);
        expect(result.error, isNull);
      });

      test('should return errors for invalid dataset', () {
        final dataset = Dataset.create(name: '', description: '');

        final result = api.validateDataset(dataset);

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data, isNotEmpty);
        expect(result.error, isNull);
      });
    });

    group('duplicateDataset', () {
      test('should duplicate dataset successfully', () async {
        final listResult = await api.listDatasets(testStack);
        final datasetId = listResult.data!.first.id;

        final result = await api.duplicateDataset(
          testStack,
          datasetId,
          'duplicated_dataset',
        );

        expect(result.success, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!.name, equals('duplicated_dataset'));
        expect(result.data!.description, contains('copy'));
        expect(result.error, isNull);

        // 元のデータセットも残っているか確認
        final afterDuplicateResult = await api.listDatasets(testStack);
        expect(afterDuplicateResult.data, hasLength(2));
      });

      test('should return error for empty new name', () async {
        final listResult = await api.listDatasets(testStack);
        final datasetId = listResult.data!.first.id;

        final result = await api.duplicateDataset(testStack, datasetId, '');

        expect(result.success, isFalse);
        expect(result.data, isNull);
        expect(result.error, contains('New dataset name cannot be empty'));
        expect(result.errorCode, equals('INVALID_INPUT'));
      });
    });

    group('DatasetApiResult', () {
      test('should serialize to JSON correctly', () {
        final dataset = Dataset.create(
          name: 'test_dataset',
          description: 'Test description',
        );

        final successResult = DatasetApiResult.success(dataset);
        final json = successResult.toJson();

        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['name'], equals('test_dataset'));
        expect(json['error'], isNull);
      });

      test('should serialize error to JSON correctly', () {
        final errorResult = DatasetApiResult<Dataset>.error(
          'Test error message',
          errorCode: 'TEST_ERROR',
        );
        final json = errorResult.toJson();

        expect(json['success'], isFalse);
        expect(json['data'], isNull);
        expect(json['error'], equals('Test error message'));
        expect(json['errorCode'], equals('TEST_ERROR'));
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
