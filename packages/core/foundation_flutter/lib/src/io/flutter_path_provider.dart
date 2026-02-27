/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:core_foundation_common/core_foundation_common.dart';

/// PathProvider implementation for Flutter environment.
///
/// Uses the path_provider package to retrieve platform-specific paths.
class FlutterPathProvider implements PathProvider {
  static final FlutterPathProvider _instance = FlutterPathProvider._internal();

  factory FlutterPathProvider() {
    return _instance;
  }

  FlutterPathProvider._internal();

  @override
  Future<Directory> getApplicationDocumentsDirectory() async {
    return await path_provider.getApplicationDocumentsDirectory();
  }

  @override
  Future<Directory> getApplicationSupportDirectory() async {
    return await path_provider.getApplicationSupportDirectory();
  }

  @override
  Future<Directory> getTemporaryDirectory() async {
    return await path_provider.getTemporaryDirectory();
  }

  @override
  Future<Directory> getStacksDirectory() async {
    final userDir = await getUserSpecificDirectory();
    return Directory('${userDir.path}/Stacks');
  }

  @override
  Future<Directory> getSamplesDirectory() async {
    final userDir = await getUserSpecificDirectory();
    return Directory('${userDir.path}/Samples');
  }

  @override
  Future<Directory> getUserSpecificDirectory() async {
    Directory baseDir;

    if (Platform.isMacOS) {
      // macOS: Log home directory information
      final homeDir = Platform.environment['HOME'];
      debugPrint('🏠 macOS HOME環境変数: $homeDir');

      // Use path_provider even in a sandbox environment
      baseDir = await path_provider.getApplicationDocumentsDirectory();
      debugPrint('📁 path_provider結果: ${baseDir.path}');

      // Determine if in a sandbox environment
      if (homeDir != null && homeDir.contains('Library/Containers')) {
        debugPrint('📦 Running in macOS sandbox environment');
      } else if (homeDir != null) {
        debugPrint('🔓 Running in macOS non-sandbox environment');
      } else {
        debugPrint('❓ HOME environment variable could not be retrieved');
      }
    } else if (Platform.isIOS) {
      // iOS: Use path_provider (sandbox environment)
      baseDir = await path_provider.getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      // Android: Use external storage Documents directory
      try {
        baseDir =
            await path_provider.getExternalStorageDirectory() ??
            await path_provider.getApplicationDocumentsDirectory();
      } catch (e) {
        debugPrint('Failed to access external storage: $e');
        baseDir = await path_provider.getApplicationDocumentsDirectory();
      }
    } else if (Platform.isLinux) {
      // Linux: Follow XDG Base Directory Specification
      try {
        final documentsDir = xdg.getUserDirectory('DOCUMENTS');
        if (documentsDir != null) {
          baseDir = Directory(documentsDir.path);
        } else {
          baseDir = await path_provider.getApplicationDocumentsDirectory();
        }
      } catch (e) {
        debugPrint('Failed to get XDG directory: $e');
        baseDir = await path_provider.getApplicationDocumentsDirectory();
      }
    } else if (Platform.isWindows) {
      // Windows: Use path_provider
      baseDir = await path_provider.getApplicationDocumentsDirectory();
    } else {
      // Other platforms: Fallback
      baseDir = await path_provider.getApplicationDocumentsDirectory();
    }

    // Create RinneGraph-specific directory
    final appDir = Directory('${baseDir.path}/RinneGraph');
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
      debugPrint('📁 Created RinneGraph directory: ${appDir.path}');
    }

    return appDir;
  }
}
