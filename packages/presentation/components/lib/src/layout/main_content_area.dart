import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart'; // Import ThemeConfig and effectiveColorSchemeProvider

/// A widget that displays the main content area of the application.
///
/// Applies the appropriate background color based on the theme settings.
class MainContentArea extends ConsumerWidget {
  /// The content to display.
  final Widget child;

  const MainContentArea({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the effective AppColorScheme
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Determine the background color of the main content area
    final backgroundColor = appColorScheme.base.background;

    // Add debug log
    // print(
    //   'MainContentArea: selected=${selectedThemeConfig.name}, '
    //   'brightness=$currentBrightness, '
    //   'bgColor=$backgroundColor, '
    //   'fallbackSurface=${Theme.of(context).colorScheme.surface}'
    // );

    return Container(color: backgroundColor, child: child);
  }
}
