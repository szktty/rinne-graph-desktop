/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_stack_common/core_stack_common.dart' as stack_common;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

/// Data class for stack information dialog.
class StackInfoData {
  const StackInfoData({
    required this.stackName,
    required this.statisticsInfo,
    required this.createdAt,
    required this.lastModifiedAt,
    this.error,
  });

  final String stackName;
  final stack_common.StackStatisticsInfo statisticsInfo;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final String? error;

  bool get hasError => error != null || statisticsInfo.hasError;

  int get nodeCount => statisticsInfo.nodeCount;
  int get linkCount => statisticsInfo.linkCount;
  int get databaseSize => statisticsInfo.databaseSize;
  String get formattedDatabaseSize => statisticsInfo.formattedDatabaseSize;
}

/// Stack information dialog.
class StackInfoDialog extends ConsumerStatefulWidget {
  const StackInfoDialog({
    super.key,
    required this.stack,
    required this.onStackNameChanged,
  });

  final core_stack.Stack stack;
  final ValueChanged<String> onStackNameChanged;

  @override
  ConsumerState<StackInfoDialog> createState() => _StackInfoDialogState();
}

class _StackInfoDialogState extends ConsumerState<StackInfoDialog> {
  late TextEditingController _nameController;
  StackInfoData? _stackInfo;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.stack.info.name);
    _loadStackInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Loads stack information asynchronously.
  Future<void> _loadStackInfo() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final stackInfo = await _fetchStackInfo();
      setState(() {
        _stackInfo = stackInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _loadError = 'Failed to retrieve stack information: $e';
        _isLoading = false;
      });
    }
  }

  /// Retrieves stack information.
  Future<StackInfoData> _fetchStackInfo() async {
    try {
      // StackStatisticsServiceを使用してスタック統計情報を取得
      final statisticsService = stack_common.StackStatisticsService();
      final statisticsInfo = await statisticsService.getStackStatistics(
        widget.stack,
      );

      return StackInfoData(
        stackName: widget.stack.info.name,
        statisticsInfo: statisticsInfo,
        createdAt: widget.stack.info.createdAt,
        lastModifiedAt: widget.stack.info.lastModifiedAt,
      );
    } catch (e) {
      // エラーが発生した場合は空の統計情報とエラーメッセージを返す
      final emptyStatistics = stack_common.StackStatisticsInfo(
        nodeCount: 0,
        linkCount: 0,
        databaseSize: 0,
        error: 'Failed to retrieve stack information: $e',
      );

      return StackInfoData(
        stackName: widget.stack.info.name,
        statisticsInfo: emptyStatistics,
        createdAt: widget.stack.info.createdAt,
        lastModifiedAt: widget.stack.info.lastModifiedAt,
        error: 'Failed to retrieve stack information: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    return AppDialog(
      title: widget.stack.info.name,
      minWidth: 500,
      maxWidth: 600,
      showDivider: true,
      footer: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.base.border, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(FondeSpacingValues.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FondeButton.cancel(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              FondeButton.primary(label: 'OK', onPressed: _handleOk),
            ],
          ),
        ),
      ),
      child: _buildContent(colorScheme),
    );
  }

  Widget _buildContent(AppColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Error message (overall error)
        if (_loadError != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.status.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.status.error),
            ),
            child: Row(
              children: [
                FondeIcon(
                  FondeIcons.error,
                  size: FondeIconSize.medium,
                  color: FondeIconColor.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    _loadError!,
                    variant: AppTextVariant.bodyText,
                    color: colorScheme.status.error,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Edit stack name
        _buildSection(
          title: 'Stack Name',
          child: FondeTextField(
            controller: _nameController,
            hintText: 'Enter stack name',
          ),
        ),

        const SizedBox(height: 20),

        // Database Information
        _buildSection(
          title: 'Database Information',
          child: _buildDatabaseInfo(colorScheme),
        ),

        const SizedBox(height: 20),

        // Update Information
        _buildSection(title: 'Update Information', child: _buildUpdateInfo()),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, variant: AppTextVariant.bodyText),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDatabaseInfo(AppColorScheme colorScheme) {
    if (_stackInfo == null) {
      return _buildErrorItem('取得に失敗しました', colorScheme);
    }

    final info = _stackInfo!;

    return Column(
      children: [
        _buildInfoRow(
          label: 'Number of Nodes',
          value: info.hasError ? null : '${info.nodeCount}',
          error: info.hasError ? '取得に失敗しました' : null,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          label: 'Number of Links',
          value: info.hasError ? null : '${info.linkCount}',
          error: info.hasError ? '取得に失敗しました' : null,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          label: 'File Size',
          value: info.hasError ? null : info.formattedDatabaseSize,
          error: info.hasError ? '取得に失敗しました' : null,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildUpdateInfo() {
    return Column(
      children: [
        _buildInfoRow(
          label: 'Creation Date',
          value: _formatDateTime(widget.stack.info.createdAt),
          colorScheme: ref.watch(effectiveColorSchemeProvider),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          label: 'Last Modified Date',
          value: _formatDateTime(widget.stack.info.lastModifiedAt),
          colorScheme: ref.watch(effectiveColorSchemeProvider),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    String? value,
    String? error,
    required AppColorScheme colorScheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: AppText(
            label,
            variant: AppTextVariant.bodyText,
            color: colorScheme.base.foreground,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              error != null
                  ? _buildErrorItem(error, colorScheme)
                  : AppText(
                    value ?? '',
                    variant: AppTextVariant.bodyText,
                    color: colorScheme.base.foreground,
                  ),
        ),
      ],
    );
  }

  Widget _buildErrorItem(String error, AppColorScheme colorScheme) {
    return Row(
      children: [
        FondeIcon(
          FondeIcons.error,
          size: FondeIconSize.small,
          color: FondeIconColor.error,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: AppText(
            error,
            variant: AppTextVariant.bodyText,
            color: colorScheme.status.error,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _handleOk() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.stack.info.name) {
      widget.onStackNameChanged(newName);
    }
    Navigator.of(context).pop();
  }
}

/// Stack information dialog.を表示するヘルパー関数
Future<void> showStackInfoDialog({
  required BuildContext context,
  required core_stack.Stack stack,
  required ValueChanged<String> onStackNameChanged,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => StackInfoDialog(
          stack: stack,
          onStackNameChanged: onStackNameChanged,
        ),
  );
}
