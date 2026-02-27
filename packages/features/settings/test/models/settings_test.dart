/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:settings/src/models/settings.dart';

void main() {
  group('Settings', () {
    test('fromJson creates instance with default values', () {
      const settings = Settings();

      expect(settings.language, equals('en'));
      expect(settings.darkMode, isFalse);
      expect(settings.autoSave, isTrue);
      expect(settings.autoSaveIntervalMinutes, equals(5));
      expect(settings.defaultFontSize, equals(14));
      expect(settings.lastOpenedFile, isNull);
    });

    test('fromJson creates instance with provided values', () {
      final settings = Settings.fromJson({
        'language': 'ja',
        'darkMode': true,
        'autoSave': false,
        'autoSaveIntervalMinutes': 10,
        'defaultFontSize': 16,
        'lastOpenedFile': '/path/to/file',
      });

      expect(settings.language, equals('ja'));
      expect(settings.darkMode, isTrue);
      expect(settings.autoSave, isFalse);
      expect(settings.autoSaveIntervalMinutes, equals(10));
      expect(settings.defaultFontSize, equals(16));
      expect(settings.lastOpenedFile, equals('/path/to/file'));
    });

    test('toJson serializes all fields', () {
      const settings = Settings(
        language: 'ja',
        darkMode: true,
        autoSave: false,
        autoSaveIntervalMinutes: 10,
        defaultFontSize: 16,
        lastOpenedFile: '/path/to/file',
      );

      final json = settings.toJson();

      expect(json['language'], equals('ja'));
      expect(json['darkMode'], isTrue);
      expect(json['autoSave'], isFalse);
      expect(json['autoSaveIntervalMinutes'], equals(10));
      expect(json['defaultFontSize'], equals(16));
      expect(json['lastOpenedFile'], equals('/path/to/file'));
    });

    test('copyWith creates new instance with specified fields', () {
      const original = Settings();
      final updated = original.copyWith(language: 'ja', darkMode: true);

      expect(updated.language, equals('ja'));
      expect(updated.darkMode, isTrue);
      // Other fields retain their original values
      expect(updated.autoSave, equals(original.autoSave));
      expect(
        updated.autoSaveIntervalMinutes,
        equals(original.autoSaveIntervalMinutes),
      );
      expect(updated.defaultFontSize, equals(original.defaultFontSize));
      expect(updated.lastOpenedFile, equals(original.lastOpenedFile));
    });
  });
}
