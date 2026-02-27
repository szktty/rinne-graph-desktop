/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/version_checker.dart';

/// Startup update check result
class StartupUpdateCheckResult {
  final bool updateAvailable;
  final String? latestVersion;
  final String? errorMessage;

  StartupUpdateCheckResult({
    required this.updateAvailable,
    this.latestVersion,
    this.errorMessage,
  });
}

/// Startup update check provider
final startupUpdateCheckProvider = FutureProvider<StartupUpdateCheckResult>((
  ref,
) async {
  try {
    // Get current app version
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    // Check GitHub releases
    final checker = VersionChecker(
      owner: 'szktty',
      repo: 'rinne_graph_desktop',
    );
    final result = await checker.checkForUpdates(currentVersion);

    return StartupUpdateCheckResult(
      updateAvailable: result.updateAvailable,
      latestVersion: result.latestVersion?.toString(),
      errorMessage: result.errorMessage,
    );
  } catch (e) {
    return StartupUpdateCheckResult(
      updateAvailable: false,
      errorMessage: e.toString(),
    );
  }
});
