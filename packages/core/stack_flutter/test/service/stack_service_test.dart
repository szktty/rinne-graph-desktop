import 'dart:io';

import 'package:core_stack/src/model.dart';
import 'package:core_stack/src/service/stack_locator_service.dart';
import 'package:core_stack/src/service/stack_metadata_service.dart';
import 'package:core_stack/src/service/stack_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockStackLocatorService extends Mock implements StackLocatorService {}

class MockStackMetadataService extends Mock implements StackMetadataService {}

class MockDirectory extends Mock implements Directory {}

void main() {
  group('StackService', () {
    late StackService stackService;
    late MockStackLocatorService mockLocator;
    late MockStackMetadataService mockMetadataLoader;
    late MockDirectory mockRootDirectory;

    setUp(() {
      mockLocator = MockStackLocatorService();
      mockMetadataLoader = MockStackMetadataService();
      mockRootDirectory = MockDirectory();

      stackService = StackService(
        locator: mockLocator,
        metadataLoader: mockMetadataLoader,
      );
    });

    group('Constructor', () {
      test('creates instance with provided dependencies', () {
        final service = StackService(
          locator: mockLocator,
          metadataLoader: mockMetadataLoader,
        );

        expect(service, isA<StackService>());
      });

      test('creates instance with default dependencies when not provided', () {
        final service = StackService();

        expect(service, isA<StackService>());
      });

      test('uses provided locator service', () {
        final customLocator = MockStackLocatorService();
        final service = StackService(locator: customLocator);

        expect(service, isA<StackService>());
      });

      test('uses provided metadata loader service', () {
        final customMetadataLoader = MockStackMetadataService();
        final service = StackService(metadataLoader: customMetadataLoader);

        expect(service, isA<StackService>());
      });
    });

    group('listAvailableStacks', () {
      test('yields valid stacks when info is available', () async {
        // Setup test data
        final stackDir1 = MockDirectory();
        final stackDir2 = MockDirectory();

        when(() => stackDir1.path).thenReturn('/path/to/stack1');
        when(() => stackDir2.path).thenReturn('/path/to/stack2');

        const info1 = StackInfo(name: 'Stack 1', version: '1.0.0');
        const info2 = StackInfo(name: 'Stack 2', version: '1.0.0');
        const settings1 = StackSettings();
        const settings2 = StackSettings();

        // Mock locator to return stack directories
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([stackDir1, stackDir2]));

        // Mock metadata loader to return valid metadata
        when(
          () => mockMetadataLoader.loadMetadata(stackDir1),
        ).thenAnswer((_) async => (info1, settings1));
        when(
          () => mockMetadataLoader.loadMetadata(stackDir2),
        ).thenAnswer((_) async => (info2, settings2));

        // Execute test
        final stacks =
            await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify results
        expect(stacks, hasLength(2));
        expect(stacks[0].info.name, equals('Stack 1'));
        expect(stacks[1].info.name, equals('Stack 2'));
        expect(stacks[0].directory.path, equals('/path/to/stack1'));
        expect(stacks[1].directory.path, equals('/path/to/stack2'));
      });

      test('skips stacks with null info', () async {
        // Setup test data
        final stackDir1 = MockDirectory();
        final stackDir2 = MockDirectory();
        final stackDir3 = MockDirectory();

        when(() => stackDir1.path).thenReturn('/path/to/valid');
        when(() => stackDir2.path).thenReturn('/path/to/invalid');
        when(() => stackDir3.path).thenReturn('/path/to/another_valid');

        const validInfo1 = StackInfo(name: 'Valid Stack 1', version: '1.0.0');
        const validInfo3 = StackInfo(name: 'Valid Stack 3', version: '1.0.0');
        const validSettings = StackSettings();

        // Mock locator to return all directories
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer(
          (_) => Stream.fromIterable([stackDir1, stackDir2, stackDir3]),
        );

        // Mock metadata loader: valid for 1 and 3, null info for 2
        when(
          () => mockMetadataLoader.loadMetadata(stackDir1),
        ).thenAnswer((_) async => (validInfo1, validSettings));
        when(
          () => mockMetadataLoader.loadMetadata(stackDir2),
        ).thenAnswer((_) async => (null, validSettings)); // Invalid stack
        when(
          () => mockMetadataLoader.loadMetadata(stackDir3),
        ).thenAnswer((_) async => (validInfo3, validSettings));

        // Execute test
        final stacks =
            await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify results - should only include valid stacks
        expect(stacks, hasLength(2));
        expect(stacks[0].info.name, equals('Valid Stack 1'));
        expect(stacks[1].info.name, equals('Valid Stack 3'));
      });

      test('handles stacks with null settings', () async {
        // Setup test data
        final stackDir = MockDirectory();
        when(() => stackDir.path).thenReturn('/path/to/stack');

        const info = StackInfo(
          name: 'Stack Without Settings',
          version: '1.0.0',
        );

        // Mock locator
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([stackDir]));

        // Mock metadata loader to return info but null settings
        when(
          () => mockMetadataLoader.loadMetadata(stackDir),
        ).thenAnswer((_) async => (info, null));

        // Execute test
        final stacks =
            await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify results
        expect(stacks, hasLength(1));
        expect(stacks[0].info.name, equals('Stack Without Settings'));
        expect(stacks[0].settings, isNull);
      });

      test('passes maxDepth parameter to locator', () async {
        const testMaxDepth = 5;

        // Mock empty result to avoid complex setup
        when(
          () =>
              mockLocator.findStacks(mockRootDirectory, maxDepth: testMaxDepth),
        ).thenAnswer((_) => const Stream.empty());

        // Execute test
        await stackService
            .listAvailableStacks(mockRootDirectory, maxDepth: testMaxDepth)
            .toList();

        // Verify maxDepth was passed correctly
        verify(
          () =>
              mockLocator.findStacks(mockRootDirectory, maxDepth: testMaxDepth),
        ).called(1);
      });

      test('handles empty directory gracefully', () async {
        // Mock empty result
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer((_) => const Stream.empty());

        // Execute test
        final stacks =
            await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify results
        expect(stacks, isEmpty);
      });

      test('handles locator errors gracefully', () async {
        // Mock locator to throw error
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenThrow(Exception('Directory access error'));

        // Execute test and expect error
        expect(
          () => stackService.listAvailableStacks(mockRootDirectory).toList(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles metadata loading errors gracefully', () async {
        // Setup test data
        final stackDir = MockDirectory();
        when(() => stackDir.path).thenReturn('/path/to/stack');

        // Mock locator to return directory
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([stackDir]));

        // Mock metadata loader to throw error
        when(
          () => mockMetadataLoader.loadMetadata(stackDir),
        ).thenThrow(Exception('Metadata loading error'));

        // Execute test and expect error
        expect(
          () => stackService.listAvailableStacks(mockRootDirectory).toList(),
          throwsA(isA<Exception>()),
        );
      });

      test('processes multiple stacks in correct order', () async {
        // Setup test data with specific order
        final stackDirs = List.generate(5, (i) {
          final dir = MockDirectory();
          when(() => dir.path).thenReturn('/path/to/stack$i');
          return dir;
        });

        final infos = List.generate(
          5,
          (i) => StackInfo(name: 'Stack $i', version: '1.0.0'),
        );
        const settings = StackSettings();

        // Mock locator to return directories in order
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer((_) => Stream.fromIterable(stackDirs));

        // Mock metadata loader for each directory
        for (var i = 0; i < 5; i++) {
          when(
            () => mockMetadataLoader.loadMetadata(stackDirs[i]),
          ).thenAnswer((_) async => (infos[i], settings));
        }

        // Execute test
        final stacks =
            await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify results maintain order
        expect(stacks, hasLength(5));
        for (var i = 0; i < 5; i++) {
          expect(stacks[i].info.name, equals('Stack $i'));
          expect(stacks[i].directory.path, equals('/path/to/stack$i'));
        }
      });

      test('handles mixed valid and invalid stacks correctly', () async {
        // Setup test data - alternating valid/invalid pattern
        final stackDirs = List.generate(6, (i) {
          final dir = MockDirectory();
          when(() => dir.path).thenReturn('/path/to/stack$i');
          return dir;
        });

        // Mock locator
        when(
          () => mockLocator.findStacks(
            mockRootDirectory,
            maxDepth: any(named: 'maxDepth'),
          ),
        ).thenAnswer((_) => Stream.fromIterable(stackDirs));

        // Mock metadata loader - even indices valid, odd indices invalid
        for (var i = 0; i < 6; i++) {
          if (i % 2 == 0) {
            // Valid stack
            final info = StackInfo(name: 'Valid Stack $i', version: '1.0.0');
            const settings = StackSettings();
            when(
              () => mockMetadataLoader.loadMetadata(stackDirs[i]),
            ).thenAnswer((_) async => (info, settings));
          } else {
            // Invalid stack (null info)
            when(
              () => mockMetadataLoader.loadMetadata(stackDirs[i]),
            ).thenAnswer((_) async => (null, null));
          }
        }

        // Execute test
        final stacks =
            await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify results - should only include valid stacks (even indices)
        expect(stacks, hasLength(3));
        expect(stacks[0].info.name, equals('Valid Stack 0'));
        expect(stacks[1].info.name, equals('Valid Stack 2'));
        expect(stacks[2].info.name, equals('Valid Stack 4'));
      });
    });

    group('Integration Tests', () {
      test('full workflow with valid stacks', () async {
        // Setup complete test scenario
        final stackDir = MockDirectory();
        when(() => stackDir.path).thenReturn('/test/stack');

        const info = StackInfo(
          name: 'Integration Test Stack',
          version: '2.0.0',
          description: 'Test stack for integration',
        );
        const settings = StackSettings();

        // Mock all services
        when(() => mockRootDirectory.path).thenReturn('/test/root');
        when(
          () => mockLocator.findStacks(mockRootDirectory, maxDepth: 3),
        ).thenAnswer((_) => Stream.fromIterable([stackDir]));
        when(
          () => mockMetadataLoader.loadMetadata(stackDir),
        ).thenAnswer((_) async => (info, settings));

        // Execute full workflow
        final stacks =
            await stackService
                .listAvailableStacks(mockRootDirectory, maxDepth: 3)
                .toList();

        // Verify complete result
        expect(stacks, hasLength(1));
        final stack = stacks[0];
        expect(stack.info.name, equals('Integration Test Stack'));
        expect(stack.info.version, equals('2.0.0'));
        expect(stack.info.description, equals('Test stack for integration'));
        expect(stack.settings, equals(settings));
        expect(stack.directory.path, equals('/test/stack'));

        // Verify service interactions
        verify(
          () => mockLocator.findStacks(mockRootDirectory, maxDepth: 3),
        ).called(1);
        verify(() => mockMetadataLoader.loadMetadata(stackDir)).called(1);
      });

      test('service behavior with default maxDepth', () async {
        // Mock empty result for simplicity
        when(
          () => mockLocator.findStacks(mockRootDirectory),
        ).thenAnswer((_) => const Stream.empty());

        // Execute without maxDepth parameter
        await stackService.listAvailableStacks(mockRootDirectory).toList();

        // Verify null maxDepth was passed
        verify(() => mockLocator.findStacks(mockRootDirectory)).called(1);
      });
    });

    group('Error Handling', () {
      test('propagates locator service errors', () async {
        when(
          () => mockLocator.findStacks(any(), maxDepth: any(named: 'maxDepth')),
        ).thenThrow(const FileSystemException('Access denied'));

        expect(
          () => stackService.listAvailableStacks(mockRootDirectory).toList(),
          throwsA(isA<FileSystemException>()),
        );
      });

      test('propagates metadata service errors', () async {
        final stackDir = MockDirectory();
        when(() => stackDir.path).thenReturn('/test/stack');

        when(
          () => mockLocator.findStacks(any(), maxDepth: any(named: 'maxDepth')),
        ).thenAnswer((_) => Stream.fromIterable([stackDir]));
        when(
          () => mockMetadataLoader.loadMetadata(stackDir),
        ).thenThrow(const FormatException('Invalid JSON'));

        expect(
          () => stackService.listAvailableStacks(mockRootDirectory).toList(),
          throwsA(isA<FormatException>()),
        );
      });

      test('handles stream processing errors', () async {
        // Mock locator to return a stream that throws
        when(
          () => mockLocator.findStacks(any(), maxDepth: any(named: 'maxDepth')),
        ).thenAnswer(
          (_) => Stream.fromFuture(
            Future.delayed(
              Duration.zero,
              () => throw Exception('Stream error'),
            ),
          ),
        );

        expect(
          () => stackService.listAvailableStacks(mockRootDirectory).toList(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
