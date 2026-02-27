/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

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
      // The meiji sample stack has a manifest file
      final hasManifest = await installer.hasManifestFile('assets/meiji');
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
        final metadata = await installer.getManifestMetadata('assets/meiji');

        expect(metadata, isNotNull);
        expect(metadata!['name'], equals('Bakumatsu Ryoma Relationship Chart'));
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
          'meiji_sample',
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
        expect(metadata!['name'], equals('Bakumatsu Ryoma Relationship Chart'));
      },
    );

    test('hasManifestFile should work with StackTemplateManifest', () async {
      final meijiTemplate = StackTemplateService.getStackTemplateById(
        'meiji_sample',
      );
      final graphOfTheGodsTemplate = StackTemplateService.getStackTemplateById(
        'graph_of_the_gods',
      );

      expect(meijiTemplate, isNotNull);
      expect(graphOfTheGodsTemplate, isNotNull);

      final meijiHasManifest =
          await StackTemplateService.hasTemplateManifestFile(meijiTemplate!);
      final graphOfTheGodsHasManifest =
          await StackTemplateService.hasTemplateManifestFile(
            graphOfTheGodsTemplate!,
          );

      expect(meijiHasManifest, isTrue);
      expect(graphOfTheGodsHasManifest, isTrue);
    });

    test(
      'getManifestMetadata should work with StackTemplateManifest',
      () async {
        final meijiTemplate = StackTemplateService.getStackTemplateById(
          'meiji_sample',
        );
        expect(meijiTemplate, isNotNull);

        final metadata = await StackTemplateService.getTemplateManifestMetadata(
          meijiTemplate!,
        );
        expect(metadata, isNotNull);
        expect(metadata!['name'], equals('Bakumatsu Ryoma Relationship Chart'));
        expect(metadata['tags'], contains('history'));
      },
    );
  });
}
