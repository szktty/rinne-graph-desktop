/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';

import 'package:core_stack_common/core_stack_common.dart';
import 'package:core_stack_flutter/src/service/asset_stack_locator_service.dart';

/// Service for managing stack discovery and information retrieval
class StackService {
  StackService({
    StackLocatorService? locator,
    StackMetadataService? metadataLoader,
  }) : _locator = locator ?? StackLocatorService(),
       _metadataLoader = metadataLoader ?? StackMetadataService();
  final StackLocatorService _locator;
  final StackMetadataService _metadataLoader;

  /// Retrieves a list of valid stacks from the specified root directory.
  ///
  /// A valid stack refers to a stack where the `.stack` directory exists,
  /// and loading and parsing of `meta/info.json` was successful.
  /// `settings.json` is optional (a stack is considered valid even if it does not exist).
  ///
  /// [rootDirectory] The directory to start the search from.
  /// [maxDepth] The maximum depth for recursive search passed to `findStacks`.
  Stream<Stack> listAvailableStacks(
    Directory rootDirectory, {
    int? maxDepth,
  }) async* {
    print(
      '[StackService.listAvailableStacks] Starting for ${rootDirectory.path} (maxDepth: $maxDepth)',
    );
    await for (final stackDir in _locator.findStacks(
      rootDirectory,
      maxDepth: maxDepth,
    )) {
      print(
        '[StackService.listAvailableStacks] Found potential stack directory: ${stackDir.path}',
      );
      final (info, settings) = await _metadataLoader.loadMetadata(stackDir);
      // The essential condition is that info is not null (info.json was successfully loaded)
      if (info != null) {
        print(
          '[StackService.listAvailableStacks] Yielding Stack object for: ${stackDir.path}',
        );
        yield Stack(
          directory: stackDir,
          info: info,
          // Use default values if settings is null
          settings: settings ?? const StackSettings(),
        );
      } else {
        // Stacks whose info.json cannot be read are considered invalid and skipped
        print(
          '[StackService.listAvailableStacks] Skipping invalid stack (info was null): ${stackDir.path}',
        );
      }
    }
    print(
      '[StackService.listAvailableStacks] Finished for ${rootDirectory.path}',
    );
  }

  /// Retrieves a list of stacks from asset stack templates.
  ///
  /// [stackManifest] A list of stack template manifest information.
  Stream<Stack> listAvailableAssetStackTemplates(
    List<AssetStackTemplateManifest> stackManifest,
  ) async* {
    print(
      '[StackService.listAvailableAssetStackTemplates] Starting for ${stackManifest.length} asset stack templates',
    );

    final assetLocator = AssetStackTemplateLocatorService();
    await for (final assetSource in assetLocator
        .findManifestBasedAssetStackTemplates(stackManifest)) {
      print(
        '[StackService.listAvailableAssetStackTemplates] Found potential asset stack template: ${assetSource.identifier}',
      );

      final (info, settings) = await assetSource.loadMetadata();
      print(
        '[StackService.listAvailableAssetStackTemplates] Metadata loaded for ${assetSource.identifier}: info=${info != null}, settings=${settings != null}',
      );

      // The essential condition is that info is not null (info.json was successfully loaded)
      if (info != null) {
        print(
          '[StackService.listAvailableAssetStackTemplates] Yielding Stack object for: ${assetSource.identifier}',
        );

        // Create a virtual directory for asset stack template based stacks
        final virtualDirectory = Directory(assetSource.identifier);

        yield Stack(
          directory: virtualDirectory,
          info: info,
          // Use default values if settings is null
          settings: settings ?? const StackSettings(),
          isAssetBased: true,
        );
      } else {
        // Asset stack templates whose info.json cannot be read are considered invalid and skipped
        print(
          '[StackService.listAvailableAssetStackTemplates] Skipping invalid asset stack template (info was null): ${assetSource.identifier}',
        );
      }
    }

    print(
      '[StackService.listAvailableAssetStackTemplates] Finished processing asset stack templates',
    );
  }

  /// Old method name for backward compatibility
  @Deprecated('Use listAvailableAssetStackTemplates instead')
  Stream<Stack> listAvailableAssetStacks(
    List<AssetStackTemplateManifest> stackManifest,
  ) async* {
    yield* listAvailableAssetStackTemplates(stackManifest);
  }
}
