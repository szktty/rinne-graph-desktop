import 'dart:async';

import 'package:core_samples/core_samples.dart';
import 'package:core_stack_flutter/src/service/stack_source.dart';

/// Service for searching stack templates from assets
class AssetStackTemplateLocatorService {
  /// Searches for manifest-based asset stack templates (for stack exchange format).
  ///
  /// [stackManifest] A list of stack template manifest information.
  Stream<ManifestBasedAssetStackTemplateSource>
  findManifestBasedAssetStackTemplates(
    List<AssetStackTemplateManifest> stackManifest,
  ) async* {
    print(
      '[AssetStackTemplateLocatorService.findManifestBasedAssetStackTemplates] Start searching ${stackManifest.length} manifest-based asset stack templates',
    );

    for (final manifest in stackManifest) {
      try {
        final fullAssetPath = manifest.fullAssetPath;

        // Check for manifest file existence
        final manifestInstaller = StackTemplateInstaller();
        final hasManifest = await manifestInstaller.hasManifestFile(
          fullAssetPath,
        );

        if (!hasManifest) {
          print(
            '[AssetStackTemplateLocatorService.findManifestBasedAssetStackTemplates] No manifest file found for: $fullAssetPath',
          );
          continue;
        }

        print(
          '[AssetStackTemplateLocatorService.findManifestBasedAssetStackTemplates] Found valid manifest-based asset stack template: $fullAssetPath',
        );

        yield ManifestBasedAssetStackTemplateSource(
          fullAssetPath,
          manifest.displayName,
        );
      } catch (e) {
        print(
          '[AssetStackTemplateLocatorService.findManifestBasedAssetStackTemplates] Skipping invalid asset stack template ${manifest.fullAssetPath}: $e',
        );
        // Skip if asset template does not exist
        continue;
      }
    }

    print(
      '[AssetStackTemplateLocatorService.findManifestBasedAssetStackTemplates] Finished searching manifest-based asset stack templates',
    );
  }
}

/// Asset stack template manifest information
class AssetStackTemplateManifest {
  const AssetStackTemplateManifest({
    required this.fullAssetPath,
    required this.displayName,
    this.description,
    this.tags = const <String>[],
  });

  /// Creates template manifest from JSON
  factory AssetStackTemplateManifest.fromJson(Map<String, dynamic> json) {
    return AssetStackTemplateManifest(
      fullAssetPath: json['fullAssetPath'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Full path of the asset template (e.g., 'packages/core_samples/assets/team')
  final String fullAssetPath;

  /// Display name of the stack template
  final String displayName;

  /// Description of the stack template (optional)
  final String? description;

  /// Tags of the stack template
  final List<String> tags;

  /// Converts template manifest to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullAssetPath': fullAssetPath,
      'displayName': displayName,
      if (description != null) 'description': description,
      'tags': tags,
    };
  }
}
