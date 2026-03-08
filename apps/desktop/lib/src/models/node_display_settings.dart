/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:presentation_components/presentation_components.dart';

/// Enum defining the display content of a node
enum NodeDisplayContent {
  /// Display label only
  labelOnly('Label only'),

  /// Display label + icon
  labelWithIcon('Label + Icon'),

  /// Display icon only
  iconOnly('Icon only');

  const NodeDisplayContent(this.displayName);

  /// Display name
  final String displayName;
}

/// Enum defining the size of a node
enum NodeSize {
  /// Small size (60px)
  small(60.0, 'S'),

  /// Medium size (90px)
  medium(90.0, 'M'),

  /// Large size (120px)
  large(120.0, 'L'),

  /// Extra large size (150px)
  extraLarge(150.0, 'XL');

  const NodeSize(this.diameter, this.displayName);

  /// Node diameter (px)
  final double diameter;

  /// Display name
  final String displayName;
}

/// Class to manage the visual data of a node
class NodeVisualData {
  /// Icon data
  final IconData? icon;

  /// Thumbnail image ID
  final UniqueId? thumbnailId;

  /// Thumbnail image URL (for external images)
  final String? thumbnailUrl;

  const NodeVisualData({this.icon, this.thumbnailId, this.thumbnailUrl});

  /// Get default icon (generic processing based on user-defined labels)
  ///
  /// Since labels are user-defined, infer and return an appropriate
  /// default icon based on common keywords
  static IconData getDefaultIconForLabels(Set<String> labels) {
    if (labels.isEmpty) {
      return FondeIcons.circle;
    }

    // Convert labels to lowercase and check for common keywords
    final lowerLabels = labels.map((label) => label.toLowerCase()).toSet();

    // Person-related
    if (lowerLabels.any(
      (label) =>
          label.contains('person') ||
          label.contains('user') ||
          label.contains('actor') ||
          label.contains('director'),
    )) {
      return FondeIcons.circle;
    }

    // Document-related
    if (lowerLabels.any(
      (label) =>
          label.contains('document') ||
          label.contains('file') ||
          label.contains('note'),
    )) {
      return FondeIcons.fileText;
    }

    // Project/folder-related
    if (lowerLabels.any(
      (label) => label.contains('project') || label.contains('folder'),
    )) {
      return FondeIcons.folder;
    }

    // Task/work-related
    if (lowerLabels.any(
      (label) => label.contains('task') || label.contains('todo'),
    )) {
      return FondeIcons.check;
    }

    // Link/relation-related
    if (lowerLabels.any(
      (label) => label.contains('link') || label.contains('relation'),
    )) {
      return FondeIcons.link;
    }

    // Default to circle icon
    return FondeIcons.circle;
  }

  /// Create empty NodeVisualData
  static const NodeVisualData empty = NodeVisualData();

  /// Create a copy
  NodeVisualData copyWith({
    IconData? icon,
    UniqueId? thumbnailId,
    String? thumbnailUrl,
  }) {
    return NodeVisualData(
      icon: icon ?? this.icon,
      thumbnailId: thumbnailId ?? this.thumbnailId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeVisualData &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          thumbnailId == other.thumbnailId &&
          thumbnailUrl == other.thumbnailUrl;

  @override
  int get hashCode =>
      icon.hashCode ^ thumbnailId.hashCode ^ thumbnailUrl.hashCode;
}
