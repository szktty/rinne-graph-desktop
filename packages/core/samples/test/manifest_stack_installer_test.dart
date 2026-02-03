import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_samples/core_samples.dart';

void main() {
  // Initialize Flutter bindings
  TestWidgetsFlutterBinding.ensureInitialized();
  group('StackTemplateInstaller Tests', () {
    late StackTemplateInstaller installer;
    late Directory tempDir;

    setUp(() async {
      installer = StackTemplateInstaller();
      tempDir = await Directory.systemTemp.createTemp('manifest_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('hasManifestFile should return true for existing manifest', () async {
      // The team sample stack has a manifest file
      final hasManifest = await installer.hasManifestFile('assets/team');
      expect(hasManifest, isTrue);
    });

    test(
      'hasManifestFile should return false for non-existing manifest',
      () async {
        final hasManifest = await installer.hasManifestFile(
          'assets/non_existing',
        );
        expect(hasManifest, isFalse);
      },
    );

    test(
      'getManifestMetadata should return metadata for existing manifest',
      () async {
        final metadata = await installer.getManifestMetadata('assets/team');

        expect(metadata, isNotNull);
        expect(metadata!['name'], equals('Software Development Team Sample'));
        expect(metadata['description'], isNotNull);
        expect(metadata['author'], isNotNull);
        expect(metadata['version'], isNotNull);
        expect(metadata['tags'], isA<List>());
      },
    );

    test(
      'getManifestMetadata should return null for non-existing manifest',
      () async {
        final metadata = await installer.getManifestMetadata(
          'assets/non_existing',
        );

        expect(metadata, isNull);
      },
    );

    // Note: Testing createStackFromManifest requires actual asset files,
    // so it is recommended to implement it separately as an integration test or with mocks.
  });

  group('StackTemplateService Manifest API Tests', () {
    test(
      'generateStackFromTemplate should use StackTemplateInstaller',
      () async {
        final template = StackTemplateService.getStackTemplateById(
          'team_sample',
        );
        expect(template, isNotNull);

        // Check for template manifest file existence
        final hasManifest = await StackTemplateService.hasTemplateManifestFile(
          template!,
        );
        expect(hasManifest, isTrue);

        // Get metadata
        final metadata = await StackTemplateService.getTemplateManifestMetadata(
          template,
        );
        expect(metadata, isNotNull);
        expect(metadata!['name'], equals('Software Development Team Sample'));
      },
    );

    test('hasManifestFile should work with StackTemplateManifest', () async {
      final teamTemplate = StackTemplateService.getStackTemplateById(
        'team_sample',
      );
      final meijiTemplate = StackTemplateService.getStackTemplateById(
        'meiji_sample',
      );

      expect(teamTemplate, isNotNull);
      expect(meijiTemplate, isNotNull);

      final teamHasManifest =
          await StackTemplateService.hasTemplateManifestFile(teamTemplate!);
      final meijiHasManifest =
          await StackTemplateService.hasTemplateManifestFile(meijiTemplate!);

      expect(teamHasManifest, isTrue);
      expect(meijiHasManifest, isTrue);
    });

    test(
      'getManifestMetadata should work with StackTemplateManifest',
      () async {
        final teamTemplate = StackTemplateService.getStackTemplateById(
          'team_sample',
        );
        expect(teamTemplate, isNotNull);

        final metadata = await StackTemplateService.getTemplateManifestMetadata(
          teamTemplate!,
        );
        expect(metadata, isNotNull);
        expect(metadata!['name'], equals('Software Development Team Sample'));
        expect(metadata['tags'], contains('development'));
      },
    );
  });
}
