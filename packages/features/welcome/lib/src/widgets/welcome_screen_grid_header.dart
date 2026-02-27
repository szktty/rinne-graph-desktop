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
import 'package:features_welcome/src/providers/welcome_providers.dart';

import '../widgets/welcome_screen_helpers.dart';

/// Header section for the stack grid on the welcome screen.
class WelcomeScreenGridHeader extends ConsumerWidget {
  const WelcomeScreenGridHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(stackDisplayModeProvider);
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 0.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: AppText(
        getDisplayModeTitleHelper(displayMode),
        variant: AppTextVariant.bodyText,
        color: colorScheme.base.foreground,
      ),
    );
  }
}
