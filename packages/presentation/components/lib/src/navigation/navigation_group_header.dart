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
import 'identifiable_navigation_item.dart';
import '../id/uuid_generator.dart';

/// A header element that represents a section.
class NavigationGroupHeader extends IdentifiableNavigationItem {
  /// The title of the header.
  final String title;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The padding.
  final EdgeInsets padding;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [NavigationGroupHeader].
  ///
  /// [id] - The unique identifier for the header.
  /// [title] - The title to display.
  /// [titleStyle] - The text style for the title.
  /// [padding] - The padding.
  const NavigationGroupHeader({
    required super.id,
    required this.title,
    this.titleStyle,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
    this.disableZoom = false,
    super.key,
  });

  /// A convenient constructor for creating a [NavigationGroupHeader] using a string ID.
  ///
  /// [idString] - The string to use as the header's ID.
  /// Other parameters are the same as the normal constructor.
  factory NavigationGroupHeader.withStringId({
    required String idString,
    required String title,
    TextStyle? titleStyle,
    EdgeInsets padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
    Key? key,
  }) {
    return NavigationGroupHeader(
      id: UuidGenerator.fromString(idString),
      title: title,
      titleStyle: titleStyle,
      padding: padding,
      disableZoom: false,
      key: key,
    );
  }

  /// A convenient constructor for creating a [NavigationGroupHeader] with a new random ID.
  ///
  /// Other parameters are the same as the normal constructor.
  factory NavigationGroupHeader.withNewId({
    required String title,
    TextStyle? titleStyle,
    EdgeInsets padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
    Key? key,
  }) {
    return NavigationGroupHeader(
      id: UuidGenerator().generate(),
      title: title,
      titleStyle: titleStyle,
      padding: padding,
      disableZoom: false,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final theme = Theme.of(context);
    final effectiveTitleStyle =
        titleStyle ??
        theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.secondary,
        );

    return Padding(
      padding: padding * zoomScale,
      child: Text(title, style: effectiveTitleStyle),
    );
  }
}
