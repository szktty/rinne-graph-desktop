/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:core_stack_common/core_stack_common.dart';
import 'package:core_stack_common/src/service/stack_service.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('StackService', () {
    late Directory tempDir;
    late StackService stackService;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('stack_service_test_');
      stackService = StackService();
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'createStack should create a valid stack directory structure',
      () async {
        final stackName = 'MyTestStack';
        final stack = await stackService.createStack(tempDir, stackName);

        // Verify the top-level directory
        expect(stack.directory.path, endsWith('.stack'));
        expect(await stack.directory.exists(), isTrue);

        // Verify metadata
        expect(stack.info.name, stackName);
        expect(stack.isScratch, isFalse);

        // Verify subdirectories
        final metaDir = Directory(p.join(stack.directory.path, 'meta'));
        final dataDir = Directory(p.join(stack.directory.path, 'data'));
        final assetsDir = Directory(p.join(stack.directory.path, 'assets'));
        final datasetsDir = Directory(p.join(stack.directory.path, 'datasets'));
        final filtersDir = Directory(p.join(stack.directory.path, 'filters'));

        expect(await metaDir.exists(), isTrue);
        expect(await dataDir.exists(), isTrue);
        expect(await assetsDir.exists(), isTrue);
        expect(await datasetsDir.exists(), isTrue);
        expect(await filtersDir.exists(), isTrue);

        // Verify metadata files
        final infoFile = File(p.join(metaDir.path, 'info.json'));
        final settingsFile = File(p.join(metaDir.path, 'settings.json'));
        expect(await infoFile.exists(), isTrue);
        expect(await settingsFile.exists(), isTrue);

        // Verify graph.db
        final dbFile = File(p.join(dataDir.path, 'graph.db'));
        expect(await dbFile.exists(), isTrue);
        expect(await dbFile.length(), greaterThan(0));
      },
    );

    test('updateStack should save changes to metadata', () async {
      final stackName = 'UpdatableStack';
      final originalStack = await stackService.createStack(tempDir, stackName);

      final newName = 'My Updated Stack Name';
      final updatedInfo = originalStack.info.copyWith(name: newName);
      final updatedStack = originalStack.copyWith(info: updatedInfo);

      await stackService.updateStack(updatedStack);

      // Reload the metadata to verify the change
      final metadataLoader = StackMetadataService();
      final (reloadedInfo, _) = await metadataLoader.loadMetadata(
        originalStack.directory,
      );

      expect(reloadedInfo, isNotNull);
      expect(reloadedInfo!.name, newName);
    });

    test('listAvailableStacks should find created stacks', () async {
      // Create two stacks
      await stackService.createStack(tempDir, 'StackOne');
      await stackService.createStack(tempDir, 'StackTwo');

      // Create a non-stack directory to ensure it's ignored
      await Directory(p.join(tempDir.path, 'not-a-stack')).create();

      final stacks = await stackService.listAvailableStacks(tempDir).toList();

      expect(stacks.length, 2);
      expect(stacks.any((s) => s.info.name == 'StackOne'), isTrue);
      expect(stacks.any((s) => s.info.name == 'StackTwo'), isTrue);
    });

    test('createStack should throw if stack already exists', () async {
      final stackName = 'ExistingStack';
      await stackService.createStack(tempDir, stackName);

      expect(
        () => stackService.createStack(tempDir, stackName),
        throwsA(isA<FileSystemException>()),
      );
    });

    test('should correctly load a previously created stack', () async {
      final stackName = 'LoadableStack';
      final createdStack = await stackService.createStack(tempDir, stackName);

      // Simulate a "fresh" load by getting the stack again
      final loadedStacks =
          await stackService.listAvailableStacks(tempDir).toList();

      expect(loadedStacks.length, greaterThanOrEqualTo(1));
      final loadedStack = loadedStacks.firstWhere(
        (s) => s.info.name == stackName,
      );

      // Verify basic properties
      expect(loadedStack.info.name, createdStack.info.name);
      expect(
        loadedStack.info.createdAt.toIso8601String(),
        createdStack.info.createdAt.toIso8601String(),
      ); // Compare ISO string for DateTime equality
      expect(loadedStack.directory.path, createdStack.directory.path);
      expect(
        loadedStack.settings.defaultView,
        createdStack.settings.defaultView,
      );

      // Verify graph.db exists
      final dbFile = File(
        p.join(loadedStack.directory.path, 'data', 'graph.db'),
      );
      expect(await dbFile.exists(), isTrue);
    });
  });
}
