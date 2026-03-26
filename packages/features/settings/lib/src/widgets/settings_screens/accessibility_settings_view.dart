/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

class AccessibilitySettingsView extends ConsumerWidget {
  const AccessibilitySettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityCtrl = ref.watch(fondeAccessibilityConfigProvider);
    final accessibilityConfig = accessibilityCtrl.config;

    return FondePanel(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(24.0),
      borderSide: BorderSide.none,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Accessibility Settings',
            variant: AppTextVariant.pageTitleSmall,
            color: appColorScheme.base.foreground,
          ),
          const SizedBox(height: 8),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Only zoom scale setting
            FondeFormList(
              child: FondeFormItemColumn(
                label: 'Zoom Scale',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrease button (with border)
                    FondeIconButton(
                      icon: FondeIcons.arrowLeft,
                      iconSize: 16.0,
                      backgroundColor: appColorScheme.uiAreas.panel.background,
                      border: BorderSide(
                        color: appColorScheme.base.border,
                        width: 1.0,
                      ),
                      onPressed: () {
                        final newZoom =
                            (accessibilityConfig.zoomScale - 0.1).clamp(
                              0.5,
                              2.0,
                            );
                        ref
                            .read(fondeAccessibilityConfigProvider.notifier)
                            .updateConfig(
                              accessibilityConfig.copyWith(zoomScale: newZoom),
                            );
                      },
                    ),
                    const SizedBox(width: 8),
                    // Display scale
                    SizedBox(
                      width: 60,
                      child: AppText(
                        '${(accessibilityConfig.zoomScale * 100).round()}%',
                        variant: AppTextVariant.bodyText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Increase button (with border)
                    FondeIconButton(
                      icon: FondeIcons.arrowRight,
                      iconSize: 16.0,
                      backgroundColor: appColorScheme.uiAreas.panel.background,
                      border: BorderSide(
                        color: appColorScheme.base.border,
                        width: 1.0,
                      ),
                      onPressed: () {
                        final newZoom =
                            (accessibilityConfig.zoomScale + 0.1).clamp(
                              0.5,
                              2.0,
                            );
                        ref
                            .read(fondeAccessibilityConfigProvider.notifier)
                            .updateConfig(
                              accessibilityConfig.copyWith(zoomScale: newZoom),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
