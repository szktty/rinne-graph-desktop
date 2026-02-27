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
import '../text_field/app_text_field.dart';

/// A field for searching navigation items.
class NavigationSearchField extends ConsumerWidget {
  /// The text editing controller.
  final TextEditingController? controller;

  /// Callback for when the text changes.
  final ValueChanged<String>? onChanged;

  /// The hint text.
  final String? hintText;

  /// Whether to autofocus.
  final bool autofocus;

  /// The focus node.
  final FocusNode? focusNode;

  /// The search icon.
  final Icon? searchIcon;

  /// The padding.
  final EdgeInsets padding;

  /// The corner radius of the search field.
  final double borderRadius;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [NavigationSearchField].
  ///
  /// [controller] - The text editing controller.
  /// [onChanged] - Callback for when the text changes.
  /// [hintText] - The hint text.
  /// [autofocus] - Whether to autofocus.
  /// [focusNode] - The focus node.
  /// [searchIcon] - The search icon.
  /// [padding] - The padding.
  /// [borderRadius] - The corner radius of the search field.
  const NavigationSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search',
    this.autofocus = false,
    this.focusNode,
    this.searchIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 20,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final theme = Theme.of(context);
    final effectiveSearchIcon = searchIcon ?? const Icon(Icons.search);

    return Container(
      padding: padding * zoomScale,
      child: AppTextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        onChanged: onChanged,
        hintText: hintText,
        prefixIcon: effectiveSearchIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8 * zoomScale,
          horizontal: 12 * zoomScale,
        ),
        radius: borderRadius * zoomScale,
        borderColor: theme.dividerColor,
        activeBorderColor: theme.colorScheme.primary,
        backgroundColor: theme.cardColor,
      ),
    );
  }
}
