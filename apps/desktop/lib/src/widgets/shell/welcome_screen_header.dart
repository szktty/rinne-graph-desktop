import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:core_themes/core_themes.dart' as core_themes;

import 'package:desktop/src/widgets/shell/welcome_screen_helpers.dart';

/// Header section for the welcome screen.
class WelcomeScreenHeader extends ConsumerWidget {
  const WelcomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(core_themes.effectiveColorSchemeProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: buildVersionInfoHelper(ref),
          ),
          const SizedBox(height: 16),
          AppText(
            'Welcome to RinneGraph',
            variant: AppTextVariant.textHeading1,
            color: appColorScheme.uiAreas.sideBar.activeItemText,
          ),
          const SizedBox(height: 12),
          AppText(
            'Everything is linked',
            variant: AppTextVariant.textHeading4,
            color: appColorScheme.uiAreas.sideBar.activeItemText,
          ),
        ],
      ),
    );
  }
}
