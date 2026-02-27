/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

/// A function that displays the About dialog
Future<void> showAboutDialog(BuildContext context) async {
  await showAppDialog(
    context: context,
    title: 'About RinneGraph',
    barrierDismissible: true,
    width: 500,
    height: 320,
    showCloseButton: true,
    child: const AboutDialogContent(),
  );
}

/// The content of the About dialog
class AboutDialogContent extends ConsumerStatefulWidget {
  const AboutDialogContent({super.key});

  @override
  ConsumerState<AboutDialogContent> createState() => _AboutDialogContentState();
}

class _AboutDialogContentState extends ConsumerState<AboutDialogContent> {
  bool _copied = false;

  Future<void> _copySystemInfo(String systemInfo) async {
    await Clipboard.setData(ClipboardData(text: systemInfo));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final displayVersionAsync = ref.watch(displayVersionStringProvider);
    final bugReportInfoAsync = ref.watch(bugReportSystemInfoProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Version information
        displayVersionAsync.when(
          data:
              (version) => AppText(
                'Version: $version',
                variant: AppTextVariant.bodyText,
              ),
          loading:
              () => AppText(
                'Version: Loading...',
                variant: AppTextVariant.bodyText,
              ),
          error:
              (error, stack) =>
                  AppText('Version: Unknown', variant: AppTextVariant.bodyText),
        ),
        const SizedBox(height: 16),

        // System information for bug reports (expandable)
        bugReportInfoAsync.when(
          data: (info) => _buildSystemInfoSection(colorScheme, info),
          loading:
              () => AppText(
                'System Info: Loading...',
                variant: AppTextVariant.bodyText,
              ),
          error:
              (error, stack) => AppText(
                'System Info: Unknown',
                variant: AppTextVariant.bodyText,
              ),
        ),
      ],
    );
  }

  /// Builds the system information section
  Widget _buildSystemInfoSection(
    AppColorScheme colorScheme,
    String systemInfo,
  ) {
    return AppExpansionTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText('System Report', variant: AppTextVariant.bodyText),
          const SizedBox(width: 8),
          // Copy icon button
          GestureDetector(
            onTap: _copied ? null : () => _copySystemInfo(systemInfo),
            child: Tooltip(
              message: _copied ? 'Copied!' : 'Copy to clipboard',
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  _copied ? Icons.check : Icons.content_copy,
                  size: 14,
                  color:
                      _copied
                          ? Colors.green
                          : colorScheme.base.foreground.withAlpha(179),
                ),
              ),
            ),
          ),
        ],
      ),
      initiallyExpanded: false,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.base.background.withAlpha(128),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: colorScheme.base.foreground.withAlpha(51),
            ),
          ),
          child: SelectableText(
            systemInfo,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: colorScheme.base.foreground.withAlpha(179),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
