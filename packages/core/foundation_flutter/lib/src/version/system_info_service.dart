/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// A service for retrieving system information.
class SystemInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Gets the OS name.
  String getOSName() {
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  /// Gets the OS version.
  String getOSVersion() {
    return Platform.operatingSystemVersion;
  }

  /// Gets the architecture (asynchronous).
  Future<String> getArchitecture() async {
    try {
      if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        final guid = info.systemGUID;
        if (guid != null && guid.contains('arm')) {
          return 'ARM64 (Apple Silicon)';
        }
        return 'x86_64 (Intel)';
      } else if (Platform.isWindows) {
        await _deviceInfo.windowsInfo;
        // Returns x86_64 for Windows.
        return 'x86_64';
      } else if (Platform.isLinux) {
        final info = await _deviceInfo.linuxInfo;
        return info.machineId ?? 'unknown';
      }
    } catch (e) {
      // Returns unknown in case of error.
    }
    return 'unknown';
  }

  /// Gets the Flutter version (asynchronous).
  Future<String> getFlutterVersion() async {
    return 'unknown';
  }
}
