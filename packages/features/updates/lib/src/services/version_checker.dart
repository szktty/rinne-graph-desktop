/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Class representing version information
class Version implements Comparable<Version> {
  /// Major version
  final int major;

  /// Minor version
  final int minor;

  /// Patch version
  final int patch;

  /// Pre-release identifier (e.g., "alpha", "beta.1")
  final String? preRelease;

  /// Build metadata (e.g., "20130313144700")
  final String? buildMetadata;

  /// Constructor
  const Version({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease,
    this.buildMetadata,
  });

  /// Create Version object from version string
  ///
  /// Supports semantic versioning (semver) format
  /// Examples: "1.2.3", "1.2.3-alpha", "1.2.3+build.123"
  factory Version.parse(String versionString) {
    // Remove "v" prefix (e.g., "v1.2.3" -> "1.2.3")
    final cleanVersion =
        versionString.startsWith('v')
            ? versionString.substring(1)
            : versionString;

    // Separate build metadata
    final buildSplit = cleanVersion.split('+');
    final versionWithoutBuild = buildSplit[0];
    final buildMetadata = buildSplit.length > 1 ? buildSplit[1] : null;

    // Separate pre-release identifier
    final preReleaseSplit = versionWithoutBuild.split('-');
    final versionCore = preReleaseSplit[0];
    final preRelease = preReleaseSplit.length > 1 ? preReleaseSplit[1] : null;

    // Separate major.minor.patch
    final parts = versionCore.split('.');
    if (parts.length < 3) {
      throw FormatException('Invalid version format: $versionString');
    }

    return Version(
      major: int.parse(parts[0]),
      minor: int.parse(parts[1]),
      patch: int.parse(parts[2]),
      preRelease: preRelease,
      buildMetadata: buildMetadata,
    );
  }

  /// Return version as string
  @override
  String toString() {
    final buffer = StringBuffer('$major.$minor.$patch');
    if (preRelease != null) {
      buffer.write('-$preRelease');
    }
    if (buildMetadata != null) {
      buffer.write('+$buildMetadata');
    }
    return buffer.toString();
  }

  /// Compare two versions
  ///
  /// Return value:
  /// - Negative value: this version is older
  /// - 0: same version
  /// - Positive value: this version is newer
  @override
  int compareTo(Version other) {
    // Compare major version
    if (major != other.major) {
      return major.compareTo(other.major);
    }

    // Compare minor version
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }

    // Compare patch version
    if (patch != other.patch) {
      return patch.compareTo(other.patch);
    }

    // Compare pre-release identifier
    // No pre-release > with pre-release
    if (preRelease == null && other.preRelease != null) {
      return 1;
    }
    if (preRelease != null && other.preRelease == null) {
      return -1;
    }
    if (preRelease != null && other.preRelease != null) {
      return preRelease!.compareTo(other.preRelease!);
    }

    return 0;
  }

  /// Whether this version is newer than other version
  bool isNewerThan(Version other) => compareTo(other) > 0;

  /// Whether this version is older than other version
  bool isOlderThan(Version other) => compareTo(other) < 0;

  /// Whether this version is same as other version
  bool isSameAs(Version other) => compareTo(other) == 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Version &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          preRelease == other.preRelease &&
          buildMetadata == other.buildMetadata;

  @override
  int get hashCode =>
      major.hashCode ^
      minor.hashCode ^
      patch.hashCode ^
      preRelease.hashCode ^
      buildMetadata.hashCode;
}

/// Version update check result
class UpdateCheckResult {
  /// Whether update is available
  final bool updateAvailable;

  /// Current version
  final Version currentVersion;

  /// Latest version (if update is available)
  final Version? latestVersion;

  /// Error message (if error occurred)
  final String? errorMessage;

  /// Constructor
  const UpdateCheckResult({
    required this.updateAvailable,
    required this.currentVersion,
    this.latestVersion,
    this.errorMessage,
  });

  /// Create result with update available
  factory UpdateCheckResult.available({
    required Version currentVersion,
    required Version latestVersion,
  }) {
    return UpdateCheckResult(
      updateAvailable: true,
      currentVersion: currentVersion,
      latestVersion: latestVersion,
    );
  }

  /// Create result with update not available
  factory UpdateCheckResult.notAvailable({required Version currentVersion}) {
    return UpdateCheckResult(
      updateAvailable: false,
      currentVersion: currentVersion,
    );
  }

  /// Create error result
  factory UpdateCheckResult.error({
    required Version currentVersion,
    required String errorMessage,
  }) {
    return UpdateCheckResult(
      updateAvailable: false,
      currentVersion: currentVersion,
      errorMessage: errorMessage,
    );
  }
}

/// Version update check service
class VersionChecker {
  /// GitHub repository owner
  final String owner;

  /// GitHub repository name
  final String repo;

  /// HTTP client (injectable for testing)
  final http.Client? httpClient;

  /// Constructor
  VersionChecker({required this.owner, required this.repo, this.httpClient});

  /// Fetch all tags from GitHub
  ///
  /// Return: List of tag names (e.g., ["v1.0.0", "v1.1.0"])
  Future<List<String>> fetchTags() async {
    final client = httpClient ?? http.Client();
    try {
      final url = Uri.https('api.github.com', '/repos/$owner/$repo/tags');

      final response = await client.get(
        url,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch tags: ${response.statusCode} ${response.reasonPhrase}',
        );
      }

      final List<dynamic> tags = json.decode(response.body) as List<dynamic>;
      return tags.map((tag) => tag['name'] as String).toList();
    } finally {
      if (httpClient == null) {
        client.close();
      }
    }
  }

  /// Get latest version from tag list
  ///
  /// Pre-release versions are excluded
  Version? getLatestVersion(List<String> tags) {
    if (tags.isEmpty) {
      return null;
    }

    Version? latestVersion;

    for (final tag in tags) {
      try {
        final version = Version.parse(tag);

        // Exclude pre-release versions
        if (version.preRelease != null) {
          continue;
        }

        if (latestVersion == null || version.isNewerThan(latestVersion)) {
          latestVersion = version;
        }
      } catch (e) {
        // Ignore tags that cannot be parsed
        continue;
      }
    }

    return latestVersion;
  }

  /// Check for updates
  ///
  /// [currentVersion] Current version string
  /// Return: Update check result
  Future<UpdateCheckResult> checkForUpdates(String currentVersion) async {
    final current = Version.parse(currentVersion);

    try {
      final tags = await fetchTags();
      final latest = getLatestVersion(tags);

      if (latest == null) {
        return UpdateCheckResult.error(
          currentVersion: current,
          errorMessage: 'No valid versions found in repository',
        );
      }

      if (latest.isNewerThan(current)) {
        return UpdateCheckResult.available(
          currentVersion: current,
          latestVersion: latest,
        );
      }

      return UpdateCheckResult.notAvailable(currentVersion: current);
    } catch (e) {
      return UpdateCheckResult.error(
        currentVersion: current,
        errorMessage: e.toString(),
      );
    }
  }
}
