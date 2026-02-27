/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:core_stack_flutter/core_stack.dart';
import '../models/stack_template_manifest.dart';
import '../service/stack_template_service.dart';

/// Provider that provides a list of stack template manifests
final stackTemplateManifestsProvider = Provider<List<StackTemplateManifest>>((
  ref,
) {
  return StackTemplateService.getAvailableStackTemplates();
});

/// Provider that provides a list of asset stack template manifests
final assetStackTemplateManifestsProvider =
    Provider<List<AssetStackTemplateManifest>>((ref) {
      return StackTemplateService.getAssetStackTemplateManifests();
    });

/// Provider that provides a list of asset stack template-based stacks
final assetStackTemplatesProvider = FutureProvider<List<Stack>>((ref) async {
  final manifests = ref.watch(assetStackTemplateManifestsProvider);
  final stackService = StackService();

  final stacks = <Stack>[];
  await for (final stack in stackService.listAvailableAssetStackTemplates(
    manifests,
  )) {
    stacks.add(stack);
  }

  return stacks;
});

/// Provider that provides a list of all user stacks
/// Includes archived stacks
///
/// Note: This provider does not include stack templates.
/// Please use assetStackTemplatesProvider for stack templates separately.
final allAvailableStacksProvider = FutureProvider<List<Stack>>((ref) async {
  // Get a list of all user stacks (including archived ones)
  final userStacks = await ref.watch(allStacksListProvider.future);

  debugPrint(
    '[allAvailableStacksProvider] User stacks: ${userStacks.length} items',
  );

  for (final stack in userStacks) {
    debugPrint(
      '[allAvailableStacksProvider] User stack: ${stack.info.name} @ ${stack.directory.path}',
    );
  }

  debugPrint(
    '[allAvailableStacksProvider] Result: Returning ${userStacks.length} user stacks',
  );
  return userStacks;
});

/// Provider that provides stack templates by category
final stackTemplatesByCategoryProvider =
    Provider.family<List<StackTemplateManifest>, String>((ref, category) {
      return StackTemplateService.getStackTemplatesByCategory(category);
    });

/// Provider that gets stack templates by ID
final stackTemplateByIdProvider =
    Provider.family<StackTemplateManifest?, String>((ref, id) {
      return StackTemplateService.getStackTemplateById(id);
    });

// Provider aliases for backward compatibility
@Deprecated('Use stackTemplateManifestsProvider instead')
final sampleStackManifestsProvider = stackTemplateManifestsProvider;

@Deprecated('Use assetStackTemplateManifestsProvider instead')
final assetStackManifestsProvider = assetStackTemplateManifestsProvider;

@Deprecated('Use assetStackTemplatesProvider instead')
final assetStacksProvider = assetStackTemplatesProvider;

@Deprecated('Use stackTemplatesByCategoryProvider instead')
final sampleStacksByCategoryProvider = stackTemplatesByCategoryProvider;

@Deprecated('Use stackTemplateByIdProvider instead')
final sampleStackByIdProvider = stackTemplateByIdProvider;
