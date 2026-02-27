/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

part 'metadata_providers.g.dart';

/// Definition of available metadata tabs
enum MetadataTab {
  labels('labels', 'Label Management')
  // For future expansion
  // propertyTypes('property_types', 'Property Type Management'),
  // entityTemplates('entity_templates', 'Entity Templates'),
  ;

  const MetadataTab(this.id, this.displayName);

  final String id;
  final String displayName;
}

/// Provider that manages the tab state for metadata management
@riverpod
class MetadataTabState extends _$MetadataTabState {
  @override
  String build() => 'labels'; // Default is label tab

  void selectTab(String tabId) {
    if (state != tabId) {
      state = tabId;
    }
  }

  bool isTabSelected(String tabId) => state == tabId;
}

/// Provider that provides a list of available metadata tabs
@riverpod
List<MetadataTab> availableMetadataTabs(Ref ref) {
  // Currently only label management
  return [MetadataTab.labels];
}

/// Notifier that manages the segment selection state for metadata management
class MetadataSegmentNotifier extends StateNotifier<int> {
  MetadataSegmentNotifier() : super(0); // Default is label (0)

  void selectSegment(int segmentIndex) {
    if (state != segmentIndex) {
      state = segmentIndex;
    }
  }

  bool isSegmentSelected(int segmentIndex) => state == segmentIndex;
}

/// Provider that manages the segment selection state for metadata management
final metadataSegmentStateProvider =
    StateNotifierProvider<MetadataSegmentNotifier, int>(
      (ref) => MetadataSegmentNotifier(),
    );
