/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';

void main() {
  group('FileSystemService', () {
    late FileSystemService fileSystemService;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      fileSystemService = FileSystemService();
    });

    test('should create instance', () {
      expect(fileSystemService, isNotNull);
    });

    test('should get user specific directory', () async {
      final userDir = await fileSystemService.getUserSpecificDirectory();
      expect(userDir, isNotNull);
      expect(userDir.path, isNotEmpty);
    });

    test('should get stacks directory', () async {
      final stacksDir = await fileSystemService.getStacksDirectory();
      expect(stacksDir, isNotNull);
      expect(stacksDir.path, contains('Stacks'));
    });

    test('should get application directories', () async {
      final documentsDir =
          await fileSystemService.getApplicationDocumentsDirectory();
      final supportDir =
          await fileSystemService.getApplicationSupportDirectory();
      final tempDir = await fileSystemService.getTemporaryDirectory();

      expect(documentsDir, isNotNull);
      expect(supportDir, isNotNull);
      expect(tempDir, isNotNull);
    });
  });
}
