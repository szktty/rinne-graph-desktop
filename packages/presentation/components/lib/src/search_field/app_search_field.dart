/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart' as sf;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

import '../../presentation_components.dart';

/// A platform-adaptive search field widget with suggestions support.
class AppSearchField extends ConsumerWidget {
  const AppSearchField({
    this.onClear,
    this.suggestions,
    this.onSuggestionTap,
    this.onSubmit,
    this.hint = '',
    this.enabled = true,
    this.value,
    this.onSaved,
    this.onChange,
    this.disableZoom = false,
    super.key,
  });

  /// The list of suggestions to show.
  final List<String>? suggestions;

  /// Called when a suggestion is tapped.
  final void Function(String)? onSuggestionTap;

  /// Called when the search field is submitted.
  final void Function(String)? onSubmit;

  /// The hint text to show when the search field is empty.
  final String hint;

  /// Whether the search field is enabled.
  final bool enabled;

  /// The current value of the search field.
  final String? value;

  /// Called when the text changes.
  final void Function(String?)? onSaved;

  /// Called when the text changes in real-time.
  final void Function(String)? onChange;

  /// Called when the clear button is tapped.
  final VoidCallback? onClear;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildMaterial(context, ref);
  }

  Widget _buildMaterial(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final controller = TextEditingController(text: value);
    final bool hasText = value != null;

    // Set onChange callback
    controller.addListener(() {
      onChange?.call(controller.text);
    });

    return sf.SearchField(
      controller: controller,
      // Added
      suggestions:
          suggestions?.map((s) => sf.SearchFieldListItem(s)).toList() ?? [],
      suggestionsDecoration: sf.SuggestionDecoration(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0 * zoomScale,
          vertical: 4.0 * zoomScale,
        ),
        borderRadius: BorderRadius.circular(8.0 * borderScale),
      ),
      onSuggestionTap:
          onSuggestionTap == null
              ? null
              : (item) => onSuggestionTap?.call(item.searchKey),
      onSubmit: onSubmit,
      onSaved: onSaved,
      // Added
      searchInputDecoration: sf.SearchInputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          AppIcons.search,
          color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          size: 20.0 * zoomScale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0 * borderScale),
          borderSide: BorderSide(
            color: appColorScheme.base.divider,
            width: borderScale,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0 * borderScale),
          borderSide: BorderSide(
            color: appColorScheme.base.divider,
            width: borderScale,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0 * borderScale),
          borderSide: BorderSide(
            color: appColorScheme.appSpecific.graph.nodeBase,
            width: borderScale,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.0 * zoomScale,
          vertical: 8.0 * zoomScale,
        ),
        suffixIcon:
            hasText && onClear != null
                ? AppIconButton.circle(
                  icon: AppIcons.x,
                  iconSize: 16.0 * zoomScale,
                  iconColor: appColorScheme.base.foreground,
                  backgroundColor: appColorScheme.base.border,
                  constraints: BoxConstraints.tightFor(
                    width: 24.0 * zoomScale,
                    height: 24.0 * zoomScale,
                  ),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                  tooltip: 'Clear',
                )
                : null,
      ),
      enabled: enabled,
    );
  }
}
