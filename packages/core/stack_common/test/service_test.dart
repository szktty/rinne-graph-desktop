import 'dart:io';
import 'package:test/test.dart';
import 'package:core_stack_common/core_stack_common.dart';

void main() {
  group('StackLocatorService', () {
    late StackLocatorService service;
    late Directory tempDir;

    setUp(() async {
      service = StackLocatorService();
      tempDir = await Directory.systemTemp.createTemp('stack_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should create instance', () {
      expect(service, isNotNull);
    });

    test('should find stack directories', () async {
      // Create a test .stack directory
      final stackDir = Directory('${tempDir.path}/test.stack');
      await stackDir.create();

      final stacks = await service.findStacks(tempDir).toList();
      expect(stacks.length, equals(1));
      expect(stacks.first.path, equals(stackDir.path));
    });

    test('should not find non-stack directories', () async {
      // Create a regular directory
      final regularDir = Directory('${tempDir.path}/regular');
      await regularDir.create();

      final stacks = await service.findStacks(tempDir).toList();
      expect(stacks.length, equals(0));
    });
  });

  group('StackMetadataService', () {
    late StackMetadataService service;

    setUp(() {
      service = StackMetadataService();
    });

    test('should create instance', () {
      expect(service, isNotNull);
    });
  });

  group('DatasetService', () {
    late DatasetService service;

    setUp(() {
      service = DatasetService();
    });

    test('should create instance', () {
      expect(service, isNotNull);
    });
  });
}
