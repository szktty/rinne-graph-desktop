/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_samples/core_samples.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:path/path.dart' as p;

// Model classes for the welcome screen.

/// A class that wraps CoreStack as StackData.
class CoreStackWrapper implements StackData {
  final core_stack.Stack originalStack;

  CoreStackWrapper(this.originalStack);

  @override
  String get id => originalStack.directory.path;

  @override
  String get name => originalStack.info.name;

  @override
  String? get thumbnailUrl {
    // If a thumbnail image file name is set, construct the local file path.
    final thumbnailFileName = originalStack.info.thumbnail;
    if (thumbnailFileName == null || thumbnailFileName.isEmpty) {
      return null;
    }

    // Construct the thumbnail image file path in the meta/ directory.
    final metaDir = p.join(originalStack.directory.path, 'meta');
    final thumbnailPath = p.join(metaDir, thumbnailFileName);

    // Check if the file exists (synchronous).
    // Only supports local files within the stack.
    final thumbnailFile = File(thumbnailPath);
    if (thumbnailFile.existsSync()) {
      return thumbnailPath;
    }

    return null;
  }

  @override
  List<String> get categories => []; // TODO: Implement categories

  @override
  int get nodeCount => 0; // TODO: Implement node count

  @override
  int get linkCount => 0; // TODO: Implement link count

  @override
  String get updatedAt => originalStack.info.lastModifiedAt.toIso8601String();

  @override
  bool get isFavorite => false; // TODO: Implement favorite status

  @override
  Map<String, dynamic> get metadata => {}; // TODO: Implement metadata
}

/// A wrapper that adapts StackTemplateManifest to the StackData interface.
class StackTemplateWrapper implements StackData {
  final StackTemplateManifest templateManifest;

  StackTemplateWrapper(this.templateManifest);

  @override
  String get id => 'template_${templateManifest.id}';

  @override
  String get name => templateManifest.displayName;

  @override
  String? get thumbnailUrl => null; // No thumbnail for templates.

  @override
  List<String> get categories => [
    templateManifest.category,
    ...templateManifest.tags,
  ];

  @override
  int get nodeCount => 0; // Actual count is unknown as it's a template.

  @override
  int get linkCount => 0; // Actual count is unknown as it's a template.

  @override
  String get updatedAt => DateTime.now().toIso8601String(); // Template is fixed.

  @override
  bool get isFavorite => false; // Templates are not subject to favorites.

  @override
  Map<String, dynamic> get metadata => {
    'description': templateManifest.description,
    'tags': templateManifest.tags,
    'category': templateManifest.category,
    'fullAssetPath': templateManifest.fullAssetPath,
    'isTemplate': true,
  };
}

/// Common constants for the welcome screen.
class WelcomeConstants {
  // Page state management (constants).
  static const int stacksPerPage = 6; // 3 columns x 2 rows
  static const int gridColumns = 3; // Number of columns
  static const int gridRows = 2; // Number of rows
}
