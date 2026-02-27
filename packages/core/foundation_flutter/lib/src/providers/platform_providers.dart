/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'platform_providers.g.dart';

/// Provider that supplies platform information.
@riverpod
bool isMacOSPlatform(Ref ref) => Platform.isMacOS;

/// Class for managing platform information.
@riverpod
PlatformInfo platformInfo(Ref ref) {
  return PlatformInfo();
}

/// Class representing platform information.
class PlatformInfo {
  /// Whether it is macOS.
  bool get isMacOS => Platform.isMacOS;

  /// Whether it is Windows.
  bool get isWindows => Platform.isWindows;

  /// Whether it is Linux.
  bool get isLinux => Platform.isLinux;

  /// Whether it is a desktop platform.
  bool get isDesktop => isMacOS || isWindows || isLinux;

  /// Whether it is a mobile platform.
  bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Whether it is a web platform.
  bool get isWeb => !isDesktop && !isMobile;

  /// The name of the platform.
  String get platformName {
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }
}
