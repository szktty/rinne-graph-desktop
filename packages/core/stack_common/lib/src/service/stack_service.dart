/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';

import 'package:core_graph_common/core_graph_common.dart';
import 'package:path/path.dart' as p;
import '../model.dart';
import 'stack_locator_service.dart';
import 'stack_metadata_service.dart';

/// Service for managing stack detection and information retrieval
class StackService {
  StackService({
    StackLocatorService? locator,
    StackMetadataService? metadataLoader,
  }) : _locator = locator ?? StackLocatorService(),
       _metadataLoader = metadataLoader ?? StackMetadataService();
  final StackLocatorService _locator;
  final StackMetadataService _metadataLoader;

  /// Gets a list of valid stacks from the specified root directory.
  ///
  /// A valid stack refers to a stack where the `.stack` directory exists,
  /// and `meta/info.json` has been successfully read and parsed.
  /// `settings.json` is optional (it is considered a valid stack even if it does not exist).
  ///
  /// [rootDirectory] The directory to start searching from.
  /// [maxDepth] Maximum depth for recursive search passed to `findStacks`.
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
      print(
        '[StackService.listAvailableStacks] Metadata loaded for ${stackDir.path}: info=${info != null}, settings=${settings != null}',
      );

      // It is a mandatory condition that info is not null (info.json loaded successfully)
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
        // Consider stacks where info.json cannot be read as invalid and skip them
        print(
          '[StackService.listAvailableStacks] Skipping invalid stack (info was null): ${stackDir.path}',
        );
      }
    }
    print(
      '[StackService.listAvailableStacks] Finished for ${rootDirectory.path}',
    );
  }

  /// Creates a new stack with the given name in the specified base directory.
  ///
  /// [baseDir] The directory where the new stack directory will be created.
  /// [name] The name of the new stack. A `.stack` extension will be appended.
  /// [description] and [tags] are written straight into the stack's metadata.
  Future<Stack> createStack(
    Directory baseDir,
    String name, {
    String? description,
    List<String> tags = const [],
  }) async {
    final stackDir = Directory(p.join(baseDir.path, '$name.stack'));
    if (await stackDir.exists()) {
      throw FileSystemException(
        'Stack directory already exists',
        stackDir.path,
      );
    }

    // Create all required directories
    final dataDir = Directory(p.join(stackDir.path, 'data'));
    await Directory(p.join(stackDir.path, 'meta')).create(recursive: true);
    await dataDir.create(recursive: true);
    await Directory(p.join(stackDir.path, 'assets')).create(recursive: true);
    await Directory(p.join(stackDir.path, 'datasets')).create(recursive: true);
    await Directory(p.join(stackDir.path, 'filters')).create(recursive: true);

    // Create the graph.db file
    final dbPath = p.join(dataDir.path, 'graph.db');
    await DatabaseCreator.createEmptyDatabase(dbPath);

    final now = DateTime.now();
    final info = StackInfo(
      name: name,
      createdAt: now,
      lastModifiedAt: now,
      version: '1.0',
      description: description,
      tags: tags,
    );
    const settings = StackSettings();

    await _metadataLoader.saveMetadata(stackDir, info, settings);

    return Stack(directory: stackDir, info: info, settings: settings);
  }

  /// Updates the metadata of an existing stack.
  ///
  /// [stack] The stack object containing the updated information.
  Future<void> updateStack(Stack stack) async {
    await _metadataLoader.saveMetadata(
      stack.directory,
      stack.info,
      stack.settings,
    );
  }
}
