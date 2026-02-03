import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:settings/src/exceptions/settings_exception.dart';
import 'package:settings/src/models/settings.dart';
import 'package:settings/src/repository/settings_repository.dart';

class TestSettingsRepository extends SettingsRepository {
  TestSettingsRepository(this.testDir);

  final Directory testDir;

  @override
  Future<String> get _settingsPath async {
    return path.join(testDir.path, 'settings.json');
  }
}

void main() {
  late Directory tempDir;
  late TestSettingsRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('settings_test_');
    repository = TestSettingsRepository(tempDir);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('SettingsRepository', () {
    test(
      'loadSettings returns default settings when file does not exist',
      () async {
        final settings = await repository.loadSettings();
        expect(settings, equals(const Settings()));
      },
    );

    test('loadSettings loads settings from file', () async {
      const expected = Settings(language: 'ja', darkMode: true);

      final file = File(path.join(tempDir.path, 'settings.json'));
      await file.writeAsString(jsonEncode(expected.toJson()));

      final settings = await repository.loadSettings();
      expect(settings, equals(expected));
    });

    test('loadSettings throws SettingsLoadException on invalid JSON', () async {
      final file = File(path.join(tempDir.path, 'settings.json'));
      await file.writeAsString('invalid json');

      expect(
        () => repository.loadSettings(),
        throwsA(isA<SettingsLoadException>()),
      );
    });

    test('saveSettings writes settings to file', () async {
      const settings = Settings(language: 'ja', darkMode: true);

      await repository.saveSettings(settings);

      final file = File(path.join(tempDir.path, 'settings.json'));
      expect(await file.exists(), isTrue);

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      expect(Settings.fromJson(json), equals(settings));
    });

    test('saveSettings throws SettingsSaveException on write error', () async {
      // Delete the test directory to cause a write error
      await tempDir.delete(recursive: true);

      expect(
        () => repository.saveSettings(const Settings()),
        throwsA(isA<SettingsSaveException>()),
      );
    });
  });

  group('InMemorySettingsRepository', () {
    test('saves and loads settings in memory', () async {
      final repository = InMemorySettingsRepository();
      const settings = Settings(language: 'ja', darkMode: true);

      await repository.saveSettings(settings);
      final loaded = await repository.loadSettings();

      expect(loaded, equals(settings));
    });
  });
}
