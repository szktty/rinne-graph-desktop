/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:features_updates/src/services/version_checker.dart';

void main() {
  group('Version', () {
    group('parse', () {
      test('Parses basic version string', () {
        final version = Version.parse('1.2.3');
        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, isNull);
        expect(version.buildMetadata, isNull);
      });

      test('Parses version with v prefix', () {
        final version = Version.parse('v1.2.3');
        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
      });

      test('Parses version with pre-release identifier', () {
        final version = Version.parse('1.2.3-alpha');
        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, 'alpha');
      });

      test(
        'Parses version with pre-release identifier (multiple segments)',
        () {
          final version = Version.parse('1.2.3-beta.1');
          expect(version.major, 1);
          expect(version.minor, 2);
          expect(version.patch, 3);
          expect(version.preRelease, 'beta.1');
        },
      );

      test('Parses version with build metadata', () {
        final version = Version.parse('1.2.3+build.123');
        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.buildMetadata, 'build.123');
      });

      test('Parses version with pre-release and build metadata', () {
        final version = Version.parse('1.2.3-alpha+build.123');
        expect(version.major, 1);
        expect(version.minor, 2);
        expect(version.patch, 3);
        expect(version.preRelease, 'alpha');
        expect(version.buildMetadata, 'build.123');
      });

      test('Throws FormatException for invalid format', () {
        expect(() => Version.parse('1.2'), throwsFormatException);
        expect(() => Version.parse('invalid'), throwsFormatException);
        expect(() => Version.parse(''), throwsFormatException);
      });
    });

    group('toString', () {
      test('Stringifies basic version', () {
        final version = Version(major: 1, minor: 2, patch: 3);
        expect(version.toString(), '1.2.3');
      });

      test('Stringifies version with pre-release', () {
        final version = Version(
          major: 1,
          minor: 2,
          patch: 3,
          preRelease: 'alpha',
        );
        expect(version.toString(), '1.2.3-alpha');
      });

      test('Stringifies version with build metadata', () {
        final version = Version(
          major: 1,
          minor: 2,
          patch: 3,
          buildMetadata: 'build.123',
        );
        expect(version.toString(), '1.2.3+build.123');
      });

      test('Stringifies version with pre-release and build metadata', () {
        final version = Version(
          major: 1,
          minor: 2,
          patch: 3,
          preRelease: 'alpha',
          buildMetadata: 'build.123',
        );
        expect(version.toString(), '1.2.3-alpha+build.123');
      });
    });

    group('compareTo', () {
      test('Compares major versions', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('2.0.0');
        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('Compares minor versions', () {
        final v1 = Version.parse('1.1.0');
        final v2 = Version.parse('1.2.0');
        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('Compares patch versions', () {
        final v1 = Version.parse('1.0.1');
        final v2 = Version.parse('1.0.2');
        expect(v1.compareTo(v2), lessThan(0));
        expect(v2.compareTo(v1), greaterThan(0));
      });

      test('Compares identical versions', () {
        final v1 = Version.parse('1.2.3');
        final v2 = Version.parse('1.2.3');
        expect(v1.compareTo(v2), 0);
      });

      test('Compares pre-release versions', () {
        final stable = Version.parse('1.0.0');
        final preRelease = Version.parse('1.0.0-alpha');

        // No pre-release > with pre-release
        expect(stable.compareTo(preRelease), greaterThan(0));
        expect(preRelease.compareTo(stable), lessThan(0));
      });

      test('Compares different pre-release identifiers', () {
        final alpha = Version.parse('1.0.0-alpha');
        final beta = Version.parse('1.0.0-beta');

        // Compare alphabetically
        expect(alpha.compareTo(beta), lessThan(0));
        expect(beta.compareTo(alpha), greaterThan(0));
      });

      test('Compares complex versions', () {
        final versions = [
          Version.parse('1.0.0-alpha'),
          Version.parse('1.0.0-beta'),
          Version.parse('1.0.0'),
          Version.parse('1.0.1'),
          Version.parse('1.1.0'),
          Version.parse('2.0.0'),
        ];

        // After sorting, confirm that the order is correct
        final sorted = List<Version>.from(versions)..sort();
        expect(sorted, versions);
      });
    });

    group('isNewerThan', () {
      test('Correctly identifies newer version', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('2.0.0');
        expect(v2.isNewerThan(v1), isTrue);
        expect(v1.isNewerThan(v2), isFalse);
      });

      test('Returns false for identical versions', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('1.0.0');
        expect(v1.isNewerThan(v2), isFalse);
      });
    });

    group('isOlderThan', () {
      test('Correctly identifies older version', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('2.0.0');
        expect(v1.isOlderThan(v2), isTrue);
        expect(v2.isOlderThan(v1), isFalse);
      });

      test('Returns false for identical versions', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('1.0.0');
        expect(v1.isOlderThan(v2), isFalse);
      });
    });

    group('isSameAs', () {
      test('Correctly identifies identical versions', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('1.0.0');
        expect(v1.isSameAs(v2), isTrue);
      });

      test('Returns false for different versions', () {
        final v1 = Version.parse('1.0.0');
        final v2 = Version.parse('2.0.0');
        expect(v1.isSameAs(v2), isFalse);
      });
    });

    group('equality', () {
      test('Identical versions are equal', () {
        final v1 = Version.parse('1.2.3');
        final v2 = Version.parse('1.2.3');
        expect(v1, equals(v2));
        expect(v1.hashCode, equals(v2.hashCode));
      });

      test('Different versions are not equal', () {
        final v1 = Version.parse('1.2.3');
        final v2 = Version.parse('1.2.4');
        expect(v1, isNot(equals(v2)));
      });

      test('Not equal if pre-release differs', () {
        final v1 = Version.parse('1.2.3-alpha');
        final v2 = Version.parse('1.2.3-beta');
        expect(v1, isNot(equals(v2)));
      });
    });
  });

  group('VersionChecker', () {
    group('getLatestVersion', () {
      test('Gets latest version from tag list', () {
        final checker = VersionChecker(owner: 'test', repo: 'test');
        final tags = ['v1.0.0', 'v1.1.0', 'v2.0.0', 'v1.5.0'];

        final latest = checker.getLatestVersion(tags);
        expect(latest, isNotNull);
        expect(latest.toString(), '2.0.0');
      });

      test('Excludes pre-release versions', () {
        final checker = VersionChecker(owner: 'test', repo: 'test');
        final tags = ['v1.0.0', 'v2.0.0-alpha', 'v1.5.0'];

        final latest = checker.getLatestVersion(tags);
        expect(latest, isNotNull);
        expect(latest.toString(), '1.5.0');
      });

      test('Ignores invalid tags', () {
        final checker = VersionChecker(owner: 'test', repo: 'test');
        final tags = ['v1.0.0', 'invalid', 'v2.0.0', 'also-invalid'];

        final latest = checker.getLatestVersion(tags);
        expect(latest, isNotNull);
        expect(latest.toString(), '2.0.0');
      });

      test('Returns null for empty tag list', () {
        final checker = VersionChecker(owner: 'test', repo: 'test');
        final tags = <String>[];

        final latest = checker.getLatestVersion(tags);
        expect(latest, isNull);
      });

      test('Returns null if all are pre-release', () {
        final checker = VersionChecker(owner: 'test', repo: 'test');
        final tags = ['v1.0.0-alpha', 'v2.0.0-beta'];

        final latest = checker.getLatestVersion(tags);
        expect(latest, isNull);
      });
    });
  });

  group('UpdateCheckResult', () {
    test('available factory constructor', () {
      final current = Version.parse('1.0.0');
      final latest = Version.parse('2.0.0');

      final result = UpdateCheckResult.available(
        currentVersion: current,
        latestVersion: latest,
      );

      expect(result.updateAvailable, isTrue);
      expect(result.currentVersion, current);
      expect(result.latestVersion, latest);
      expect(result.errorMessage, isNull);
    });

    test('notAvailable factory constructor', () {
      final current = Version.parse('1.0.0');

      final result = UpdateCheckResult.notAvailable(currentVersion: current);

      expect(result.updateAvailable, isFalse);
      expect(result.currentVersion, current);
      expect(result.latestVersion, isNull);
      expect(result.errorMessage, isNull);
    });

    test('error factory constructor', () {
      final current = Version.parse('1.0.0');
      const errorMsg = 'Network error';

      final result = UpdateCheckResult.error(
        currentVersion: current,
        errorMessage: errorMsg,
      );

      expect(result.updateAvailable, isFalse);
      expect(result.currentVersion, current);
      expect(result.latestVersion, isNull);
      expect(result.errorMessage, errorMsg);
    });
  });
}
