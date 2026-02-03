import 'dart:io';

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
}
