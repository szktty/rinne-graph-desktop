import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that manages the initialization of the entire application (Riverpod version)
class AppInitializer extends ConsumerWidget {
  const AppInitializer({
    required this.initializations,
    required this.child,
    this.loadingBuilder,
    this.errorBuilder,
    super.key,
  });

  /// List of packages that require initialization
  final List<PackageInitialization> initializations;

  /// Widget to display after initialization is complete
  final Widget child;

  /// Builder for the widget to display during initialization
  final Widget Function(BuildContext)? loadingBuilder;

  /// Builder for the widget to display when an error occurs
  final Widget Function(BuildContext, List<AsyncError>)? errorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In Riverpod, initialization is managed by providers, so
    // this widget only functions as a wrapper
    try {
      // Execute initialization process
      for (final init in initializations) {
        init.initialize?.call(ref);
      }

      // Load debug settings and update the logger
      _initializeDebugSettings(ref);

      return child;
    } catch (error, stackTrace) {
      final asyncError = AsyncError(error, stackTrace);
      return MaterialApp(
        home:
            errorBuilder?.call(context, [asyncError]) ??
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          '$error\n$stackTrace',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    }
  }

  /// デバッグ設定を初期化する
  void _initializeDebugSettings(WidgetRef ref) {
    try {
      // Monitor debug logging settings and update the logger
      ref.listen(debugLoggingProvider, (previous, next) {
        debugLogger.setEnabled(next);
        debugLog('Debug logging is ${next ? 'enabled' : 'disabled'}');
      });

      // Apply debug logging settings in initial state
      final debugLogging = ref.read(debugLoggingProvider);
      debugLogger.setEnabled(debugLogging);

      if (debugLogging) {
        debugLog('App initialization: Debug logging is enabled');
      }
    } catch (e) {
      // Even if debug settings initialization fails, app startup continues
      debugPrint('Failed to initialize debug settings: $e');
    }
  }
}
