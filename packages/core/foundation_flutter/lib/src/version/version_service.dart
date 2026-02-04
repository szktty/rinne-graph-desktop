import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'system_info_service.dart';

part 'version_service.g.dart';

/// Model representing version information.
class VersionInfo {
  final String stage;
  final int major;
  final int year;
  final int month;
  final int day;
  final int build;
  final String commitHash;
  final String buildDate;
  final String flutterVersion;

  VersionInfo({
    required this.stage,
    required this.major,
    required this.year,
    required this.month,
    required this.day,
    required this.build,
    required this.commitHash,
    required this.buildDate,
    required this.flutterVersion,
  });

  /// Generates VersionInfo from JSON.
  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      stage: json['stage'] as String? ?? 'Unknown',
      major: json['major'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      day: json['day'] as int? ?? 0,
      build: json['build'] as int? ?? 0,
      commitHash: json['commitHash'] as String? ?? 'unknown',
      buildDate: json['buildDate'] as String? ?? 'unknown',
      flutterVersion: json['flutterVersion'] as String? ?? 'unknown',
    );
  }

  /// Gets the technical version string (e.g., 0.251125.1+a1b2c3d).
  String getTechnicalVersion() {
    return '$major.$year$month$day.$build+$commitHash';
  }

  /// Gets the display version string (e.g., Alpha Build 25.11.25.1 (a1b2c3d)).
  String getDisplayVersion() {
    return '$stage Build $year.$month.$day.$build ($commitHash)';
  }
}

/// A service that manages application version information.
class VersionService {
  /// Loads version information from asset files.
  Future<VersionInfo> getVersionInfo() async {
    try {
      final jsonString = await rootBundle.loadString('assets/version.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return VersionInfo.fromJson(json);
    } catch (e) {
      // In debug mode, this is a fatal error because it means the developer
      // forgot to run `scripts/generate_version.sh`.
      assert(
        false,
        'Failed to load version.json. '
        'Please run `scripts/generate_version.sh` before running the app.',
      );
      // If the file is not found, return default values.
      return VersionInfo(
        stage: 'Unknown',
        major: 0,
        year: 0,
        month: 0,
        day: 0,
        build: 0,
        commitHash: 'unknown',
        buildDate: 'unknown',
        flutterVersion: 'unknown',
      );
    }
  }

  /// Gets the technical version string.
  Future<String> getTechnicalVersionString() async {
    final info = await getVersionInfo();
    return info.getTechnicalVersion();
  }

  /// Gets the display version string.
  Future<String> getDisplayVersionString() async {
    final info = await getVersionInfo();
    return info.getDisplayVersion();
  }
}

/// Provider that supplies an instance of VersionService.
@riverpod
VersionService versionService(Ref ref) {
  return VersionService();
}

/// Provider that asynchronously retrieves version information.
@riverpod
Future<VersionInfo> versionInfo(Ref ref) async {
  final service = ref.read(versionServiceProvider);
  return await service.getVersionInfo();
}

/// Provider that asynchronously retrieves the technical version string.
@riverpod
Future<String> technicalVersionString(Ref ref) async {
  final service = ref.read(versionServiceProvider);
  return await service.getTechnicalVersionString();
}

/// Provider that asynchronously retrieves the display version string.
@riverpod
Future<String> displayVersionString(Ref ref) async {
  final service = ref.read(versionServiceProvider);
  return await service.getDisplayVersionString();
}

/// System information service provider.
@riverpod
SystemInfoService systemInfoService(Ref ref) {
  return SystemInfoService();
}

/// Provider that retrieves system information.
@riverpod
Future<SystemInfo> systemInfo(Ref ref) async {
  final service = ref.read(systemInfoServiceProvider);
  final architecture = await service.getArchitecture();
  final flutterVersion = await service.getFlutterVersion();

  return SystemInfo(
    osName: service.getOSName(),
    osVersion: service.getOSVersion(),
    architecture: architecture,
    flutterVersion: flutterVersion,
  );
}

/// Provider that retrieves the system information string for bug reports.
@riverpod
Future<String> bugReportSystemInfo(Ref ref) async {
  final version = await ref.watch(displayVersionStringProvider.future);
  final systemInfoData =
      await ref.watch(systemInfoProvider.future) as SystemInfo?;

  if (systemInfoData == null) {
    return 'Version: $version\nSystem Info: Unknown';
  }

  return 'Version: $version\n'
      'OS: ${systemInfoData.osName} ${systemInfoData.osVersion}\n'
      'Architecture: ${systemInfoData.architecture}\n'
      'Flutter: ${systemInfoData.flutterVersion}';
}

/// Model representing system information.
class SystemInfo {
  final String osName;
  final String osVersion;
  final String architecture;
  final String flutterVersion;

  SystemInfo({
    required this.osName,
    required this.osVersion,
    required this.architecture,
    required this.flutterVersion,
  });
}
