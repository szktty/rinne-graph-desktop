import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import '../providers/welcome_providers.dart';

/// Service for batch stack operations for debugging
class DebugStackOperations {
  final WidgetRef _ref;

  DebugStackOperations(this._ref);

  /// Archives all stacks
  Future<DebugOperationResult> archiveAllStacks() async {
    debugLog('デバッグ操作: すべてのスタックをアーカイブ開始');

    try {
      // 全スタックのリストを取得（アーカイブ済みを除く）
      final stacks = await _ref.read(
        core_stack.availableStacksListProvider.future,
      );

      if (stacks.isEmpty) {
        debugLog('アーカイブ対象のスタックが見つかりません');
        return DebugOperationResult(
          success: true,
          message: 'アーカイブ対象のスタックがありません',
          processedCount: 0,
        );
      }

      int successCount = 0;
      int failureCount = 0;
      final errors = <String>[];

      for (final stack in stacks) {
        try {
          await _archiveStack(stack);
          successCount++;
          debugLog('スタックをアーカイブしました: ${stack.info.name}');
        } catch (e) {
          failureCount++;
          final errorMsg = 'スタック ${stack.info.name} のアーカイブに失敗: $e';
          errors.add(errorMsg);
          debugLog(errorMsg);
        }
      }

      // スタックリストを更新
      _ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();

      final message =
          'Processing complete: $successCount succeeded, $failureCount failed';
      debugLog('Debug operation complete: $message');

      return DebugOperationResult(
        success: failureCount == 0,
        message: message,
        processedCount: successCount,
        errors: errors,
      );
    } catch (e) {
      final errorMsg = 'An error occurred during archiving all stacks: $e';
      debugLog(errorMsg);
      return DebugOperationResult(
        success: false,
        message: errorMsg,
        processedCount: 0,
      );
    }
  }

  /// Deletes all stacks
  Future<DebugOperationResult> deleteAllStacks() async {
    debugLog('Debug operation: Starting to delete all stacks');

    try {
      // Get a list of all stacks (including archived ones)
      final stacks = await _ref.read(core_stack.allStacksListProvider.future);

      if (stacks.isEmpty) {
        debugLog('No stacks found to delete');
        return DebugOperationResult(
          success: true,
          message: 'No stacks to delete',
          processedCount: 0,
        );
      }

      // Classify deletion targets
      final userStacks = stacks.where((s) => !s.isAssetBased).toList();
      final assetStacks = stacks.where((s) => s.isAssetBased).toList();

      debugLog(
        'Deletion target analysis: Total ${stacks.length} items = User ${userStacks.length} items + Asset ${assetStacks.length} items',
      );

      for (final stack in userStacks) {
        debugLog(
          'Deletion target (user): ${stack.info.name} @ ${stack.directory.path}',
        );
      }

      for (final stack in assetStacks) {
        debugLog(
          'Not subject to deletion (asset): ${stack.info.name} @ ${stack.directory.path}',
        );
      }

      int successCount = 0;
      int failureCount = 0;
      final errors = <String>[];

      for (final stack in stacks) {
        try {
          await _deleteStack(stack);
          if (!stack.isAssetBased) {
            successCount++;
            debugLog(
              'Deleted stack: ${stack.info.name} @ ${stack.directory.path}',
            );
          }
        } catch (e) {
          failureCount++;
          final errorMsg = 'Failed to delete stack ${stack.info.name}: $e';
          errors.add(errorMsg);
          debugLog(errorMsg);
        }
      }

      // スタックリストを更新
      _ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();

      final message =
          'Processing complete: $successCount succeeded, $failureCount failed';
      debugLog('Debug operation complete: $message');

      return DebugOperationResult(
        success: failureCount == 0,
        message: message,
        processedCount: successCount,
        errors: errors,
      );
    } catch (e) {
      final errorMsg = 'An error occurred during deletion of all stacks: $e';
      debugLog(errorMsg);
      return DebugOperationResult(
        success: false,
        message: errorMsg,
        processedCount: 0,
      );
    }
  }

  /// Archives a single stack
  Future<void> _archiveStack(core_stack.Stack stack) async {
    if (stack.isAssetBased) {
      // Manage state with a provider for asset-based stacks
      _ref.read(assetStackArchiveStateProvider.notifier).update((state) {
        return {...state, stack.directory.path: true};
      });
    } else {
      // For normal stacks, save to file
      final updatedSettings = stack.settings.copyWith(
        customFields: {...stack.settings.customFields, 'isArchived': true},
      );

      // Save stack settings to file
      await _saveStackSettings(stack, updatedSettings);
    }
  }

  /// Deletes a single stack
  Future<void> _deleteStack(core_stack.Stack stack) async {
    if (stack.isAssetBased) {
      // Asset-based stacks cannot be deleted (warning only)
      debugLog(
        'Warning: Asset-based stacks cannot be deleted: ${stack.info.name}',
      );
      return;
    }

    // Physically delete the stack directory
    if (await stack.directory.exists()) {
      await stack.directory.delete(recursive: true);
    }
  }

  /// Saves stack settings to a file
  Future<void> _saveStackSettings(
    core_stack.Stack stack,
    core_stack.StackSettings settings,
  ) async {
    final settingsFile = File('${stack.directory.path}/meta/settings.json');

    // Create meta directory if it doesn't exist
    final metaDir = settingsFile.parent;
    if (!await metaDir.exists()) {
      await metaDir.create(recursive: true);
    }

    // Save settings to JSON file
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(settings.toJson());
    await settingsFile.writeAsString(jsonString);
  }
}

/// Result of a debug operation
class DebugOperationResult {
  final bool success;
  final String message;
  final int processedCount;
  final List<String> errors;

  const DebugOperationResult({
    required this.success,
    required this.message,
    required this.processedCount,
    this.errors = const [],
  });

  @override
  String toString() {
    return 'DebugOperationResult(success: $success, message: $message, processedCount: $processedCount, errors: ${errors.length})';
  }
}
