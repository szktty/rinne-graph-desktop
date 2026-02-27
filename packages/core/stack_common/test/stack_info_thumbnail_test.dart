/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:core_stack_common/core_stack_common.dart';

void main() {
  group('StackInfo Thumbnail Tests', () {
    test('should create StackInfo with thumbnail', () {
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        description: 'Test Description',
        author: 'Test Author',
        thumbnail: 'thumbnail.png',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
        tags: ['test'],
      );

      expect(stackInfo.name, equals('Test Stack'));
      expect(stackInfo.thumbnail, equals('thumbnail.png'));
    });

    test('should create StackInfo without thumbnail', () {
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      expect(stackInfo.name, equals('Test Stack'));
      expect(stackInfo.thumbnail, isNull);
    });

    test('should serialize to JSON with thumbnail', () {
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        description: 'Test Description',
        author: 'Test Author',
        thumbnail: 'thumbnail.png',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
        tags: ['test'],
      );

      final json = stackInfo.toJson();

      expect(json['name'], equals('Test Stack'));
      expect(json['thumbnail'], equals('thumbnail.png'));
      expect(json['description'], equals('Test Description'));
      expect(json['author'], equals('Test Author'));
    });

    test('should serialize to JSON without thumbnail', () {
      final now = DateTime.now();
      final stackInfo = StackInfo(
        name: 'Test Stack',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      final json = stackInfo.toJson();

      expect(json['name'], equals('Test Stack'));
      expect(json.containsKey('thumbnail'), isFalse);
    });

    test('should deserialize from JSON with thumbnail', () {
      final json = {
        'name': 'Test Stack',
        'description': 'Test Description',
        'author': 'Test Author',
        'thumbnail': 'thumbnail.png',
        'createdAt': '2025-01-01T00:00:00.000Z',
        'lastModifiedAt': '2025-01-01T00:00:00.000Z',
        'version': '1.0.0',
        'tags': ['test'],
      };

      final stackInfo = StackInfo.fromJson(json);

      expect(stackInfo.name, equals('Test Stack'));
      expect(stackInfo.thumbnail, equals('thumbnail.png'));
      expect(stackInfo.description, equals('Test Description'));
      expect(stackInfo.author, equals('Test Author'));
    });

    test('should deserialize from JSON without thumbnail', () {
      final json = {
        'name': 'Test Stack',
        'createdAt': '2025-01-01T00:00:00.000Z',
        'lastModifiedAt': '2025-01-01T00:00:00.000Z',
        'version': '1.0.0',
        'tags': <String>[],
      };

      final stackInfo = StackInfo.fromJson(json);

      expect(stackInfo.name, equals('Test Stack'));
      expect(stackInfo.thumbnail, isNull);
    });

    test('should copy with thumbnail', () {
      final now = DateTime.now();
      final original = StackInfo(
        name: 'Original Stack',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      final updated = original.copyWith(thumbnail: 'new_thumbnail.png');

      expect(updated.name, equals('Original Stack'));
      expect(updated.thumbnail, equals('new_thumbnail.png'));
      expect(original.thumbnail, isNull);
    });

    test('should maintain equality with thumbnail', () {
      final now = DateTime.now();
      final stackInfo1 = StackInfo(
        name: 'Test Stack',
        thumbnail: 'thumbnail.png',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      final stackInfo2 = StackInfo(
        name: 'Test Stack',
        thumbnail: 'thumbnail.png',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      final stackInfo3 = StackInfo(
        name: 'Test Stack',
        thumbnail: 'different.png',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      expect(stackInfo1, equals(stackInfo2));
      expect(stackInfo1, isNot(equals(stackInfo3)));
      expect(stackInfo1.hashCode, equals(stackInfo2.hashCode));
      expect(stackInfo1.hashCode, isNot(equals(stackInfo3.hashCode)));
    });

    test('should only support local file paths for thumbnails', () {
      final now = DateTime.now();

      // Local file paths are valid
      final localThumbnail = StackInfo(
        name: 'Local Stack',
        thumbnail: 'thumbnail.png',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      expect(localThumbnail.thumbnail, equals('thumbnail.png'));

      // Only file names are expected (paths are not included)
      final fileNameOnly = StackInfo(
        name: 'File Name Stack',
        thumbnail: 'my_image.jpg',
        createdAt: now,
        lastModifiedAt: now,
        version: '1.0.0',
      );

      expect(fileNameOnly.thumbnail, equals('my_image.jpg'));
    });
  });
}
