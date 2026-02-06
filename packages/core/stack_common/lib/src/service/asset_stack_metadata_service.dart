import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;

import '../model.dart';

/// Service for loading stack metadata from Flutter assets.
class AssetStackMetadataService {
  /// Asynchronously loads metadata from the asset bundle.
  Future<(StackInfo?, StackSettings?)> loadMetadata(String assetPath) async {
    print(
      '[AssetStackMetadataService.loadMetadata] Start loading metadata for asset: $assetPath',
    );

    final infoAssetPath = p.join(assetPath, 'meta', 'info.json');
    final settingsAssetPath = p.join(assetPath, 'meta', 'settings.json');

    StackInfo? stackInfo;
    StackSettings? stackSettings;

    // Load info.json from assets
    try {
      final content = await rootBundle.loadString(infoAssetPath);
      final json = jsonDecode(content) as Map<String, dynamic>;
      stackInfo = StackInfo.fromJson(json);
      print(
        '[AssetStackMetadataService.loadMetadata] Successfully loaded info.json for asset: $assetPath',
      );
    } catch (e, stackTrace) {
      print(
        '[AssetStackMetadataService.loadMetadata] Error loading/parsing info.json for asset: $assetPath: $e',
      );
      print(stackTrace);
      stackInfo = null;
    }

    // Load settings.json from assets
    try {
      final content = await rootBundle.loadString(settingsAssetPath);
      final json = jsonDecode(content) as Map<String, dynamic>;
      stackSettings = StackSettings.fromJson(json);
      print(
        '[AssetStackMetadataService.loadMetadata] Successfully loaded settings.json for asset: $assetPath',
      );
    } catch (e, stackTrace) {
      print(
        '[AssetStackMetadataService.loadMetadata] Error loading/parsing settings.json for asset: $assetPath: $e',
      );
      print(stackTrace);
      stackSettings = null;
    }

    print(
      '[AssetStackMetadataService.loadMetadata] Finished loading metadata for asset: $assetPath. Info: ${stackInfo != null}, Settings: ${stackSettings != null}',
    );
    return (stackInfo, stackSettings);
  }
}
