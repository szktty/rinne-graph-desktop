/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';
import 'package:core_stack_flutter/core_stack.dart';
import '../models/stack_template_manifest.dart';
import 'stack_template_installer.dart';

/// Stack template management service
class StackTemplateService {
  /// Gets a list of available stack template manifests
  static List<StackTemplateManifest> getAvailableStackTemplates() {
    return [
      const StackTemplateManifest(
        id: 'meiji_sample',
        displayName: 'Bakumatsu Ryoma Relationship Chart',
        fullAssetPath: 'packages/core_samples/assets/meiji',
        description:
            'Template data for Bakumatsu historical figures centered around Sakamoto Ryoma',
        tags: ['template', 'history', 'japan', 'meiji', 'ryoma'],
        category: 'history',
        language: 'ja',
      ),
      const StackTemplateManifest(
        id: 'graph_of_the_gods',
        displayName: 'Graph of the Gods',
        fullAssetPath: 'packages/core_samples/assets/graph_of_the_gods',
        description:
            'The example graph used in the JanusGraph documentation to illustrate the core features of a graph database.',
        tags: ['sample', 'janusgraph', 'mythology', 'graph', 'english'],
        category: 'mythology',
        language: 'en',
      ),
      const StackTemplateManifest(
        id: 'graph_of_the_gods_ja',
        displayName: 'ギリシャ神のグラフ',
        fullAssetPath: 'packages/core_samples/assets/graph_of_the_gods_ja',
        description:
            'JanusGraphのドキュメントで使用されている、グラフデータベースの主要機能を示すためのサンプルグラフ。',
        tags: ['サンプル', 'janusgraph', '神話', 'グラフ', '日本語'],
        category: 'mythology',
        language: 'ja',
      ),
      const StackTemplateManifest(
        id: 'crime_and_punish_ja',
        displayName: '罪と罰',
        fullAssetPath: 'packages/core_samples/assets/crime_and_punish_ja',
        description:
            'ドストエフスキーの小説『罪と罰』の登場人物・場面・場所の関係図。全六篇＋エピローグを収録。',
        tags: ['サンプル', '文学', '小説', 'ロシア', 'ドストエフスキー', '日本語'],
        category: 'literature',
        language: 'ja',
      ),
      const StackTemplateManifest(
        id: 'crime_and_punish_en',
        displayName: 'Crime and Punishment',
        fullAssetPath: 'packages/core_samples/assets/crime_and_punish_en',
        description:
            "A knowledge graph of characters, scenes, and locations from Dostoevsky's novel 'Crime and Punishment'. Covers all six parts and the epilogue.",
        tags: ['sample', 'literature', 'novel', 'russian', 'dostoevsky', 'english'],
        category: 'literature',
        language: 'en',
      ),
    ];
  }

  /// Converts to a list of AssetStackTemplateManifest
  static List<AssetStackTemplateManifest> getAssetStackTemplateManifests() {
    return getAvailableStackTemplates()
        .map((template) => template.toAssetStackTemplateManifest())
        .toList();
  }

  /// Gets stack templates by category
  static List<StackTemplateManifest> getStackTemplatesByCategory(
    String category,
  ) {
    return getAvailableStackTemplates()
        .where((template) => template.category == category)
        .toList();
  }

  /// Gets stack template by ID
  static StackTemplateManifest? getStackTemplateById(String id) {
    try {
      return getAvailableStackTemplates().firstWhere(
        (template) => template.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  /// Generates a stack from a stack template using a manifest-based API
  ///
  /// [template] The manifest of the stack template to generate
  /// [outputDirectory] Output directory
  /// [stackName] Name of the stack to generate (retrieved from template if omitted)
  ///
  /// Returns: The directory path of the generated stack, or null if failed
  static Future<String?> generateStackFromTemplate({
    required StackTemplateManifest template,
    required Directory outputDirectory,
    String? stackName,
    bool isSample = false,
  }) async {
    final installer = StackTemplateInstaller();
    return installer.generateStackFromTemplate(
      templateAssetPath: template.fullAssetPath,
      outputDirectory: outputDirectory,
      stackName: stackName ?? template.displayName,
      isSample: isSample,
      sampleTemplateId: isSample ? template.id : null,
    );
  }

  // Old method name for backward compatibility
  @Deprecated('Use getAvailableStackTemplates instead')
  static List<StackTemplateManifest> getAvailableSampleStacks() {
    return getAvailableStackTemplates();
  }

  @Deprecated('Use getAssetStackTemplateManifests instead')
  static List<AssetStackTemplateManifest> getAssetStackManifests() {
    return getAssetStackTemplateManifests();
  }

  @Deprecated('Use getStackTemplatesByCategory instead')
  static List<StackTemplateManifest> getSampleStacksByCategory(
    String category,
  ) {
    return getStackTemplatesByCategory(category);
  }

  @Deprecated('Use getStackTemplateById instead')
  static StackTemplateManifest? getSampleStackById(String id) {
    return getStackTemplateById(id);
  }

  /// Old method name for backward compatibility
  ///
  /// [manifest] The manifest of the sample stack to generate
  /// [outputDirectory] Output directory
  /// [stackName] Name of the stack to generate (retrieved from manifest if omitted)
  ///
  /// Returns: The directory path of the generated stack, or null if failed
  @Deprecated('Use generateStackFromTemplate instead')
  static Future<String?> createStackFromManifest({
    required StackTemplateManifest manifest,
    required Directory outputDirectory,
    String? stackName,
  }) async {
    return generateStackFromTemplate(
      template: manifest,
      outputDirectory: outputDirectory,
      stackName: stackName,
    );
  }

  /// Checks for the existence of a template manifest file
  ///
  /// [template] The manifest of the stack template to check
  ///
  /// Returns: true if the template manifest file exists
  static Future<bool> hasTemplateManifestFile(
    StackTemplateManifest template,
  ) async {
    final installer = StackTemplateInstaller();
    return installer.hasManifestFile(template.fullAssetPath);
  }

  /// Gets metadata from the template manifest file
  ///
  /// [template] The manifest of the stack template to retrieve
  ///
  /// Returns: The metadata of the template manifest, or null if failed
  static Future<Map<String, dynamic>?> getTemplateManifestMetadata(
    StackTemplateManifest template,
  ) async {
    final installer = StackTemplateInstaller();
    return installer.getManifestMetadata(template.fullAssetPath);
  }

  // Old method name for backward compatibility
  @Deprecated('Use hasTemplateManifestFile instead')
  static Future<bool> hasManifestFile(StackTemplateManifest template) async {
    return hasTemplateManifestFile(template);
  }

  @Deprecated('Use getTemplateManifestMetadata instead')
  static Future<Map<String, dynamic>?> getManifestMetadata(
    StackTemplateManifest template,
  ) async {
    return getTemplateManifestMetadata(template);
  }
}
