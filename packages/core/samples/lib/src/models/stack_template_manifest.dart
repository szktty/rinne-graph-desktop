/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_stack_flutter/core_stack.dart';

/// Class for managing stack template manifest information
class StackTemplateManifest {
  const StackTemplateManifest({
    required this.id,
    required this.displayName,
    required this.fullAssetPath,
    this.description,
    this.tags = const [],
    this.category = 'template',
    this.language,
  });

  /// Unique identifier for the stack template
  final String id;

  /// Display name
  final String displayName;

  /// Full asset path for the asset template
  final String fullAssetPath;

  /// Description
  final String? description;

  /// Tags
  final List<String> tags;

  /// Category
  final String category;

  /// Language (ISO 639-1 code, e.g. 'en', 'ja')
  final String? language;

  /// Converts to AssetStackTemplateManifest
  AssetStackTemplateManifest toAssetStackTemplateManifest() {
    return AssetStackTemplateManifest(
      fullAssetPath: fullAssetPath,
      displayName: displayName,
      description: description,
      tags: tags,
    );
  }

  /// Creates a template manifest from JSON
  factory StackTemplateManifest.fromJson(Map<String, dynamic> json) {
    return StackTemplateManifest(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      fullAssetPath: json['fullAssetPath'] as String,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      category: json['category'] as String? ?? 'template',
      language: json['language'] as String?,
    );
  }

  /// Converts the template manifest to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'fullAssetPath': fullAssetPath,
      if (description != null) 'description': description,
      'tags': tags,
      'category': category,
      if (language != null) 'language': language,
    };
  }
}
