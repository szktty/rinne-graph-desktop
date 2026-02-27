/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:core_themes/core_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import '../services/version_checker.dart';

/// Function to display the update check dialog
Future<void> showUpdateCheckDialog(BuildContext context) async {
  // Wrap with MaterialApp to provide MaterialLocalizations
  await showAppDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tap
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UpdateCheckDialog(),
    ),
  );
}

/// Update check dialog
class UpdateCheckDialog extends ConsumerStatefulWidget {
  /// Constructor
  const UpdateCheckDialog({super.key});

  @override
  ConsumerState<UpdateCheckDialog> createState() => _UpdateCheckDialogState();
}

class _UpdateCheckDialogState extends ConsumerState<UpdateCheckDialog> {
  bool isChecking = true;
  bool updateAvailable = false;
  String message = 'Checking for updates...';
  String? errorMessage;
  String? latestVersion;

  @override
  void initState() {
    super.initState();
    debugPrint('[UpdateCheckDialog] Building');
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    try {
      final checker = VersionChecker(
        owner: 'szktty',
        repo: 'rinne_graph_desktop',
      );
      final result = await checker.checkForUpdates('1.0.0');

      if (!mounted) return;

      setState(() {
        isChecking = false;
        if (result.errorMessage != null) {
          errorMessage = result.errorMessage;
          message = 'Failed to check for updates';
        } else if (result.updateAvailable) {
          updateAvailable = true;
          latestVersion = result.latestVersion.toString();
          message = 'A new version is available!';
        } else {
          message = 'You are using the latest version';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isChecking = false;
        errorMessage = e.toString();
        message = 'Failed to check for updates';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final displayVersionAsync = ref.watch(displayVersionStringProvider);

    debugPrint('[UpdateCheckDialog] Built');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        AppText(
          'Check for updates',
          variant: AppTextVariant.sectionTitlePrimary,
        ),
        const SizedBox(height: 16),

        // Current version display
        displayVersionAsync.when(
          data:
              (version) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Current version: $version',
                    variant: AppTextVariant.bodyText,
                    color: colorScheme.base.foreground.withAlpha(179),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          loading:
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Current version: Loading...',
                    variant: AppTextVariant.bodyText,
                    color: colorScheme.base.foreground.withAlpha(179),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          error: (error, stack) => const SizedBox.shrink(),
        ),

        // Message
        AppText(message, variant: AppTextVariant.bodyText),
        const SizedBox(height: 24),

        // Progress bar (displayed only while checking)
        if (isChecking) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 24),
        ],

        // Error message (displayed only on error)
        if (errorMessage != null) ...[
          AppText(
            'Error: $errorMessage',
            variant: AppTextVariant.bodyText,
            color: colorScheme.status.error,
          ),
          const SizedBox(height: 24),
        ],

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isChecking)
              // Cancel button (displayed only while checking)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const AppText(
                  'Cancel',
                  variant: AppTextVariant.bodyText,
                ),
              )
            else if (updateAvailable && latestVersion != null)
            // Update button (when update is available)
            ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const AppText('Later', variant: AppTextVariant.bodyText),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  final url = Uri.parse(
                    'https://github.com/szktty/rinne-graph-desktop/releases',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const AppText(
                  'Download',
                  variant: AppTextVariant.bodyText,
                ),
              ),
            ] else
              // OK button (displayed after check is complete)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const AppText('OK', variant: AppTextVariant.bodyText),
              ),
          ],
        ),
      ],
    );
  }
}
