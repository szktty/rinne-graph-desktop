/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../filesystem/file_system_service.dart';

/// A class that defines package initialization.
class PackageInitialization {
  const PackageInitialization({required this.warmUps, this.initialize});

  /// Function that returns a list of providers that require warm-up.
  final List<AsyncValue<dynamic>> Function(WidgetRef) warmUps;

  /// Processing performed during initialization.
  /// This processing runs after warm-up is complete.
  final void Function(WidgetRef)? initialize;
}

/// Basic initialization definition for core_foundation package.
/// Responsible for initialization other than settings storage.
/// Can be safely used in sub-windows as well.
final coreFoundationBaseInitialization = PackageInitialization(
  warmUps: (ref) => [], // Add other initializations as needed
);

/// Full initialization definition for core_foundation package.
/// Initialization for the main window.
final coreFoundationInitialization = PackageInitialization(
  warmUps: (ref) => [...coreFoundationBaseInitialization.warmUps(ref)],
  initialize: (ref) async {
    // Initialize user-specific directories
    await _initializeUserSpecificDirectories();
  },
);

/// Initialize user-specific directories
///
/// Creates the necessary directory structure when the application starts.
/// Prevents application startup from being blocked even if an error occurs.
Future<void> _initializeUserSpecificDirectories() async {
  debugPrint('=== Starting user-specific directory initialization ===');

  try {
    final fileSystemService = FileSystemService();
    debugPrint('FileSystemService instance created');

    // Execute user-specific directory initialization
    debugPrint('Calling initializeUserSpecificDirectories()...');
    final success = await fileSystemService.initializeUserSpecificDirectories();

    if (success) {
      debugPrint('✅ Application directory initialization complete');

      // Output directory information for debugging
      final directoryInfo =
          await fileSystemService.getUserSpecificDirectoryInfo();
      debugPrint('📁 Initialized directories:');
      directoryInfo.forEach((key, value) {
        debugPrint('  📂 $key: $value');
      });

      // Check if directory actually exists
      debugPrint('🔍 Directory existence check:');
      for (final entry in directoryInfo.entries) {
        final dir = Directory(entry.value);
        final exists = await dir.exists();
        debugPrint('  ${exists ? "✅" : "❌"} ${entry.key}: $exists');
      }
    } else {
      debugPrint('❌ Application directory initialization failed');
    }
  } catch (e, stackTrace) {
    // Prevent app startup from being blocked even if an error occurs
    debugPrint('💥 An error occurred during directory initialization: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  debugPrint('=== User-specific directory initialization ended ===');
}
