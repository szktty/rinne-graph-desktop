import 'package:core_stack_common/core_stack_common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('core_stack_flutter', () {
    test('should export core_stack_common classes', () {
      // Test that we can access classes from core_stack_common
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      expect(stackInfo.name, equals('Test Stack'));
      expect(stackInfo.version, equals('1.0.0'));
    });

    test('should create DatasetFilter', () {
      const filter = DatasetFilter(
        entityLabels: ['person'],
        properties: {
          'name': ['test'],
        },
      );

      expect(filter.entityLabels, equals(['person']));
      expect(filter.properties, containsPair('name', ['test']));
    });

    test('should create Dataset', () {
      const filter = DatasetFilter(entityLabels: ['person'], properties: {});
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
      expect(dataset.id, equals('test-id'));
      expect(dataset.type, equals(DatasetType.saved));
    });

    test('should create service instances', () {
      final locatorService = StackLocatorService();
      final metadataService = StackMetadataService();
      final datasetService = DatasetService();

      expect(locatorService, isNotNull);
      expect(metadataService, isNotNull);
      expect(datasetService, isNotNull);
    });
  });
}
