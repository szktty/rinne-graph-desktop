import 'dart:async';
import 'dart:io';

import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_graph_common/core_graph_common.dart';
import 'package:core_samples/core_samples.dart';
import 'package:core_stack_common/core_stack_common.dart' hide StackService;
import 'package:core_stack_flutter/src/service/stack_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stack_providers.g.dart';

/// Validate stack validity
///
/// [stack] Stack to validate
/// Return value: true if stack is valid, false if invalid
Future<bool> _validateStack(Stack stack) async {
  try {
    debugPrint(
      '[stack_providers] Stack validation started: ${stack.info.name}',
    );

    // Check basic directory structure
    final stackDir = stack.directory;
    if (!await stackDir.exists()) {
      debugPrint(
        '[stack_providers] Stack validation failed: Directory does not exist: ${stackDir.path}',
      );
      return false;
    }

    // Check meta directory
    final metaDir = Directory(p.join(stackDir.path, 'meta'));
    if (!await metaDir.exists()) {
      debugPrint(
        '[stack_providers] Stack validation failed: meta directory does not exist: ${metaDir.path}',
      );
      return false;
    }

    // Check data directory
    final dataDir = Directory(p.join(stackDir.path, 'data'));
    if (!await dataDir.exists()) {
      debugPrint(
        '[stack_providers] Stack validation failed: data directory does not exist: ${dataDir.path}',
      );
      return false;
    }

    // Check database file
    final dbFile = File(p.join(stackDir.path, 'data', 'graph.db'));
    if (!await dbFile.exists()) {
      debugPrint(
        '[stack_providers] Stack validation failed: Database file does not exist: ${dbFile.path}',
      );
      return false;
    }

    // Validate database file
    try {
      final validationResult = await DatabaseValidator.validateDatabase(
        dbFile.path,
      );
      if (!validationResult.isValid) {
        debugPrint(
          '[stack_providers] Stack validation failed: Database is invalid: ${validationResult.description}',
        );
        return false;
      }

      if (!validationResult.isInitialized) {
        debugPrint(
          '[stack_providers] Stack validation warning: Database is not initialized: ${validationResult.description}',
        );
        // Treat as warning if not initialized, consider as valid
      }

      debugPrint(
        '[stack_providers] Stack validation succeeded: ${stack.info.name}',
      );
      return true;
    } catch (e) {
      debugPrint(
        '[stack_providers] Stack validation error: Database validation failed: $e',
      );
      // Treat as warning if database validation fails, consider as valid
      return true;
    }
  } catch (e) {
    debugPrint('[stack_providers] Stack validation error: $e');
    return false;
  }
}

/// Provider to asynchronously get path to application documents directory
@riverpod
Future<Directory> documentsDirectory(DocumentsDirectoryRef ref) async {
  debugPrint('[stack_providers] documentsDirectory executing');
  final fileSystemService = FileSystemService();
  final dir = await fileSystemService.getApplicationDocumentsDirectory();
  debugPrint('[stack_providers] documentsDirectory got directory: ${dir.path}');
  return dir;
}

/// Provider to provide root directory for stack search
@riverpod
Future<Directory> stackSearchDirectory(StackSearchDirectoryRef ref) async {
  debugPrint('[stack_providers] stackSearchDirectory executing');
  final fileSystemService = FileSystemService();
  final stacksDir = await fileSystemService.getStacksDirectory();

  // Create Stacks directory if it does not exist
  if (!await stacksDir.exists()) {
    await stacksDir.create(recursive: true);
    debugPrint('[stack_providers] Created Stacks directory: ${stacksDir.path}');
  }

  debugPrint(
    '[stack_providers] stackSearchDirectory got directory: ${stacksDir.path}',
  );
  return stacksDir;
}

/// Provider to asynchronously get scratch stack directory
@riverpod
Future<Directory> scratchesDirectory(ScratchesDirectoryRef ref) async {
  debugPrint('[stack_providers] scratchesDirectory executing');
  final fileSystemService = FileSystemService();
  final docsDir = await fileSystemService.getApplicationDocumentsDirectory();

  final scratchesDir = Directory(p.join(docsDir.path, 'Scratches'));

  if (!await scratchesDir.exists()) {
    await scratchesDir.create(recursive: true);
  }

  debugPrint(
    '[stack_providers] scratchesDirectory got directory: ${scratchesDir.path}',
  );
  return scratchesDir;
}

/// Provider to asynchronously get sample stacks directory
@riverpod
Future<Directory> samplesDirectory(SamplesDirectoryRef ref) async {
  debugPrint('[stack_providers] samplesDirectory executing');
  final fileSystemService = FileSystemService();
  final samplesDir = await fileSystemService.getSamplesDirectory();

  if (!await samplesDir.exists()) {
    await samplesDir.create(recursive: true);
    debugPrint(
      '[stack_providers] Created Samples directory: ${samplesDir.path}',
    );
  }

  debugPrint(
    '[stack_providers] samplesDirectory got directory: ${samplesDir.path}',
  );
  return samplesDir;
}

/// Ensure all sample stacks from built-in templates are instantiated
/// in the Samples directory. Idempotent: skips templates that already
/// have a matching sample stack (by sampleTemplateId).
Future<void> _ensureSampleStacksInstantiated(Directory samplesDir) async {
  // Discover existing sample stacks
  final stackService = StackService();
  final existingStream = stackService.listAvailableStacks(
    samplesDir,
    maxDepth: 5,
  );
  final existingTemplateIds = <String>{};
  await for (final stack in existingStream) {
    final templateId = stack.info.sampleTemplateId;
    if (templateId != null) {
      existingTemplateIds.add(templateId);
    }
  }

  // Get all available templates
  final templates = StackTemplateService.getAvailableStackTemplates();
  debugPrint(
    '[stack_providers] _ensureSampleStacksInstantiated: '
    '${existingTemplateIds.length} existing, ${templates.length} templates',
  );

  // Generate missing sample stacks
  for (final template in templates) {
    if (existingTemplateIds.contains(template.id)) {
      continue;
    }

    debugPrint(
      '[stack_providers] Generating sample stack: ${template.id} (${template.displayName})',
    );
    final result = await StackTemplateService.generateStackFromTemplate(
      template: template,
      outputDirectory: samplesDir,
      isSample: true,
    );
    if (result != null) {
      debugPrint(
        '[stack_providers] Successfully generated sample stack: $result',
      );
    } else {
      debugPrint(
        '[stack_providers] Failed to generate sample stack: ${template.id}',
      );
    }
  }
}

/// Provider to provide list of sample stacks as List<Stack>
@riverpod
Future<List<Stack>> sampleStacksList(SampleStacksListRef ref) async {
  debugPrint('[stack_providers] sampleStacksList executing');

  // Watch refreshStacksTrigger to create dependency
  ref.watch(refreshStacksTriggerProvider);

  try {
    final samplesDir = await ref.watch(samplesDirectoryProvider.future);
    debugPrint(
      '[stack_providers] sampleStacksList got samplesDir: ${samplesDir.path}',
    );

    // Ensure all sample stacks are instantiated before listing
    await _ensureSampleStacksInstantiated(samplesDir);

    final stackService = StackService();
    final stackStream = stackService.listAvailableStacks(
      samplesDir,
      maxDepth: 5,
    );
    final stacks = <Stack>[];

    await for (final stack in stackStream) {
      final isValid = await _validateStack(stack);
      if (isValid) {
        stacks.add(stack);
        debugPrint(
          '[stack_providers] sampleStacksList: collected ${stacks.length} sample stacks',
        );
      } else {
        debugPrint(
          '[stack_providers] sampleStacksList: skipping invalid sample stack: ${stack.info.name} @ ${stack.directory.path}',
        );
      }
    }

    debugPrint(
      '[stack_providers] sampleStacksList: returning ${stacks.length} sample stacks',
    );
    return stacks;
  } catch (e) {
    debugPrint('[stack_providers] sampleStacksList error: $e');
    return <Stack>[];
  }
}

/// Provider to trigger stack list update
@riverpod
class RefreshStacksTrigger extends _$RefreshStacksTrigger {
  @override
  int build() {
    debugPrint('[stack_providers] RefreshStacksTrigger build: 0');
    return 0;
  }

  void trigger() {
    final newCount = state + 1;
    debugPrint(
      '[stack_providers] RefreshStacksTrigger: Updating count from $state to $newCount',
    );
    state = newCount;
  }
}

/// Provider to provide list of available stacks (Stream<Stack>)
@riverpod
Stream<Stack> availableStacksStream(AvailableStacksStreamRef ref) async* {
  debugPrint('[stack_providers] availableStacksStream executing');

  // Watch refreshStacksTrigger to create dependency
  ref.watch(refreshStacksTriggerProvider);
  debugPrint(
    '[stack_providers] availableStacksStream subscribed to refresh trigger',
  );

  try {
    final searchDir = await ref.watch(stackSearchDirectoryProvider.future);
    debugPrint(
      '[stack_providers] availableStacksStream got searchDir: ${searchDir.path}',
    );

    final stackService = StackService();
    final stackStream = stackService.listAvailableStacks(
      searchDir,
      maxDepth: 5,
    );

    await for (final stack in stackStream) {
      debugPrint(
        '[stack_providers] availableStacksStream yielding stack: ${stack.info.name}',
      );
      yield stack;
    }
  } catch (e) {
    debugPrint('[stack_providers] availableStacksStream error: $e');
    // Return empty stream on error
  }
}

/// Provider to provide list of available stacks as List<Stack>
/// Archived stacks are excluded
@riverpod
Future<List<Stack>> availableStacksList(AvailableStacksListRef ref) async {
  debugPrint('[stack_providers] availableStacksList executing');

  // Watch refreshStacksTrigger to create dependency
  ref.watch(refreshStacksTriggerProvider);
  debugPrint(
    '[stack_providers] availableStacksList subscribed to refresh trigger',
  );

  try {
    final searchDir = await ref.watch(stackSearchDirectoryProvider.future);
    debugPrint(
      '[stack_providers] availableStacksList got searchDir: ${searchDir.path}',
    );

    final stackService = StackService();
    final stackStream = stackService.listAvailableStacks(
      searchDir,
      maxDepth: 5,
    );
    final stacks = <Stack>[];

    await for (final stack in stackStream) {
      // Perform stack validation
      final isValid = await _validateStack(stack);
      if (!isValid) {
        debugPrint(
          '[stack_providers] availableStacksList: skipping invalid stack: ${stack.info.name} @ ${stack.directory.path}',
        );
        continue;
      }

      // Exclude archived stacks
      if (!stack.isArchived) {
        stacks.add(stack);
        debugPrint(
          '[stack_providers] availableStacksList: collected ${stacks.length} stacks (excluding archived)',
        );
      } else {
        debugPrint(
          '[stack_providers] availableStacksList: skipping archived stack: ${stack.info.name}',
        );
      }
    }

    debugPrint(
      '[stack_providers] availableStacksList: returning ${stacks.length} stacks',
    );
    return stacks;
  } catch (e) {
    debugPrint('[stack_providers] availableStacksList error: $e');
    return <Stack>[];
  }
}

/// Provider to provide list of all stacks (including archived) as List<Stack>
@riverpod
Future<List<Stack>> allStacksList(AllStacksListRef ref) async {
  debugPrint('[stack_providers] allStacksList executing');

  // Watch refreshStacksTrigger to create dependency
  ref.watch(refreshStacksTriggerProvider);
  debugPrint('[stack_providers] allStacksList subscribed to refresh trigger');

  try {
    final searchDir = await ref.watch(stackSearchDirectoryProvider.future);
    debugPrint(
      '[stack_providers] allStacksList got searchDir: ${searchDir.path}',
    );

    final stackService = StackService();
    final stackStream = stackService.listAvailableStacks(
      searchDir,
      maxDepth: 5,
    );
    final stacks = <Stack>[];

    await for (final stack in stackStream) {
      // Perform stack validation
      final isValid = await _validateStack(stack);
      if (isValid) {
        stacks.add(stack);
        debugPrint(
          '[stack_providers] allStacksList: collected ${stacks.length} stacks (including archived)',
        );
      } else {
        debugPrint(
          '[stack_providers] allStacksList: skipping invalid stack: ${stack.info.name} @ ${stack.directory.path}',
        );
      }
    }

    debugPrint(
      '[stack_providers] allStacksList: returning ${stacks.length} stacks',
    );
    return stacks;
  } catch (e) {
    debugPrint('[stack_providers] allStacksList error: $e');
    return <Stack>[];
  }
}

/// Provider to provide actions for stack creation, deletion, etc.
@riverpod
class StackActions extends _$StackActions {
  @override
  void build() {
    // No initial state needed
  }

  /// Manually refresh stack list
  void triggerRefresh() {
    ref.read(refreshStacksTriggerProvider.notifier).trigger();
  }

  /// Create stack from specified stack template
  Future<bool> createSampleStackFromManifest(
    StackTemplateManifest manifest,
  ) async {
    debugPrint(
      '[stack_providers] Stack template generation started: ${manifest.id} (${manifest.displayName})',
    );
    try {
      final searchDir = await ref.read(samplesDirectoryProvider.future);
      debugPrint('[stack_providers] Output directory: ${searchDir.path}');

      final success = await createStackFromManifestBased(manifest, searchDir);

      if (success) {
        debugPrint(
          '[stack_providers] Stack template generation succeeded: ${manifest.id}',
        );
        // Trigger refresh
        debugPrint('[stack_providers] Triggering stack list refresh');
        triggerRefresh();
        return true;
      } else {
        debugPrint(
          '[stack_providers] Stack template generation failed: ${manifest.id}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('[stack_providers] Stack template generation error: $e');
      return false;
    }
  }

  /// Create stack from stack template manifest (for stack exchange format)
  Future<bool> createStackFromManifestBased(
    StackTemplateManifest manifest,
    Directory searchDir,
  ) async {
    try {
      // Generate stack from stack template using StackTemplateInstaller
      final stackPath = await StackTemplateService.generateStackFromTemplate(
        template: manifest,
        outputDirectory: searchDir,
      );

      if (stackPath != null) {
        debugPrint(
          '[stack_providers] Successfully created manifest-based stack at: $stackPath',
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('[stack_providers] Error creating manifest-based stack: $e');
      return false;
    }
  }

  /// Create custom stack
  Future<Stack?> createCustomStack({
    required String name,
    required String description,
    required bool isScratch,
    required List<String> tags,
  }) async {
    debugPrint(
      '[stack_providers] StackActions.createCustomStack executing: name=$name',
    );
    try {
      final searchDir = await ref.read(stackSearchDirectoryProvider.future);
      final scratchesDir = await ref.read(scratchesDirectoryProvider.future);

      // TODO: Implement custom stack creation logic
      debugPrint(
        '[stack_providers] StackActions.createCustomStack: TODO - implement logic',
      );

      // Trigger refresh
      triggerRefresh();
      return null; // TODO: Return created stack
    } catch (e) {
      debugPrint('[stack_providers] StackActions.createCustomStack error: $e');
      return null;
    }
  }

  /// Create scratch stack
  Future<Stack?> createScratchStack() async {
    debugPrint('[stack_providers] StackActions.createScratchStack executing');
    try {
      final scratchesDir = await ref.read(scratchesDirectoryProvider.future);

      // TODO: Implement scratch stack creation logic
      debugPrint(
        '[stack_providers] StackActions.createScratchStack: TODO - implement logic',
      );

      // Trigger refresh
      triggerRefresh();
      return null; // TODO: Return created stack
    } catch (e) {
      debugPrint('[stack_providers] StackActions.createScratchStack error: $e');
      return null;
    }
  }
}

/// Provider to manage currently open active stack
///
/// This provider manages the currently active stack across the entire application.
/// When a stack is set, related services and providers are notified.
@Riverpod(keepAlive: true)
class ActiveStack extends _$ActiveStack {
  @override
  Stack? build() => null;

  /// Set active stack
  void setStack(Stack? stack) {
    debugPrint(
      '[ActiveStack] Setting active stack: ${stack?.directory.path ?? "null"}',
    );
    state = stack;
  }

  /// Clear active stack
  void clearStack() {
    debugPrint('[ActiveStack] Clearing active stack');
    state = null;
  }
}
