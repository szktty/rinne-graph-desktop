import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:features_settings/features_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manager for startup settings
class StartupManager {
  StartupManager({required this.arguments, required this.ref});

  final List<String> arguments;
  final WidgetRef ref;

  /// Determines which stack to open at startup
  Future<StartupStackResult> determineStartupStack() async {
    // 1. Check command line arguments
    final stackFromArgs = _getStackFromCommandLine();
    if (stackFromArgs != null) {
      debugPrint('Stack specified from command line: $stackFromArgs');
      return StartupStackResult(
        stackPath: stackFromArgs,
        source: StartupStackSource.commandLine,
      );
    }

    // 2. Check startup settings
    final startupSettings = ref.read(startupSettingsProvider);
    if (startupSettings.autoOpenLastStack &&
        startupSettings.lastOpenedStackPath != null) {
      debugPrint(
        'Auto-opening last opened stack: ${startupSettings.lastOpenedStackPath}',
      );
      return StartupStackResult(
        stackPath: startupSettings.lastOpenedStackPath!,
        source: StartupStackSource.lastOpened,
      );
    }

    // 3. Default (no stack)
    debugPrint('No startup stack specified');
    return const StartupStackResult(
      stackPath: null,
      source: StartupStackSource.none,
    );
  }

  /// Gets stack path from command line arguments
  String? _getStackFromCommandLine() {
    for (int i = 0; i < arguments.length; i++) {
      if (arguments[i] == '--stack' && i + 1 < arguments.length) {
        return arguments[i + 1];
      }
    }
    return null;
  }

  /// Opens a stack
  Future<Stack?> openStack(String stackPath) async {
    try {
      final file = File(stackPath);
      if (!await file.exists()) {
        debugPrint('Stack file not found: $stackPath');
        return null;
      }

      // Get stack directory
      final stackDir = file.parent;

      // Load stack
      final metadataService = StackMetadataService();
      final (info, settings) = await metadataService.loadMetadata(stackDir);

      if (info == null) {
        throw Exception('Failed to load stack metadata');
      }

      final stack = Stack(
        directory: stackDir,
        info: info,
        settings: settings ?? const StackSettings(),
      );

      return stack;
    } catch (e) {
      debugPrint('Failed to open stack: $e');
      return null;
    }
  }
}

/// Startup stack information
class StartupStackResult {
  const StartupStackResult({required this.stackPath, required this.source});

  final String? stackPath;
  final StartupStackSource source;

  bool get hasStack => stackPath != null;
}

/// Source of the startup stack
enum StartupStackSource {
  /// Specified from command line arguments
  commandLine,

  /// Last opened stack (from settings)
  lastOpened,

  /// No stack
  none,
}
