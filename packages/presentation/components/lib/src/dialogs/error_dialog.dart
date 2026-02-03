import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

/// Data structure for error dialog
class ErrorDialogData {
  /// Constructor
  const ErrorDialogData({required this.message, this.details});

  /// User-friendly error message
  final String message;

  /// Technical details (optional)
  final String? details;

  /// Whether error data exists
  bool get hasError => message.isNotEmpty;

  /// Whether error details exist
  bool get hasDetails => details != null && details!.isNotEmpty;

  /// Factory constructor representing no error state
  static const ErrorDialogData none = ErrorDialogData(message: '');

  /// Factory constructor for simple error message only
  factory ErrorDialogData.message(String message) {
    return ErrorDialogData(message: message);
  }

  /// Factory constructor with message and details
  factory ErrorDialogData.withDetails(String message, String details) {
    return ErrorDialogData(message: message, details: details);
  }

  /// Factory constructor to create error data from Exception
  factory ErrorDialogData.fromException(
    Exception exception, {
    String? context,
  }) {
    final message = context ?? 'An error occurred';
    final details = exception.toString();
    return ErrorDialogData(message: message, details: details);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorDialogData &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          details == other.details;

  @override
  int get hashCode => message.hashCode ^ details.hashCode;

  @override
  String toString() => 'ErrorDialogData(message: $message, details: $details)';
}

/// Dialog to display warning information
class AppWarningDialog extends StatelessWidget {
  /// Constructor
  const AppWarningDialog({
    super.key,
    required this.message,
    required this.warningItems,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel = 'Execute',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  /// Warning message
  final String message;

  /// List of warning items
  final List<String> warningItems;

  /// Callback when confirm button is pressed
  final VoidCallback? onConfirm;

  /// Callback when cancel button is pressed
  final VoidCallback? onCancel;

  /// Label for confirm button
  final String confirmLabel;

  /// Label for cancel button
  final String cancelLabel;

  /// Whether this is a destructive operation
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      minWidth: 400,
      maxWidth: 600,
      // Remove minHeight to adjust dynamically based on content
      showDivider: false,
      footer: Padding(
        padding: const EdgeInsets.all(AppSpacingValues.xl),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton.cancel(
              label: cancelLabel,
              onPressed: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
            ),
            const SizedBox(width: 12),
            isDestructive
                ? AppButton.destructive(
                  label: confirmLabel,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                )
                : AppButton.primary(
                  label: confirmLabel,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon area (left side)
          Column(
            children: [
              const SizedBox(height: 4), // Adjust icon to align with title
              Icon(Icons.warning_amber_rounded, size: 24, color: Colors.orange),
            ],
          ),

          const SizedBox(width: 16),

          // Content area (right side)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message
                AppText(message, variant: AppTextVariant.bodyText),

                const SizedBox(height: 12),

                // Warning items list
                ...warningItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppText(item, variant: AppTextVariant.bodyText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog to display error information
class AppErrorDialog extends ConsumerWidget {
  /// Constructor
  const AppErrorDialog({
    super.key,
    required this.message,
    this.details,
    this.onOkPressed,
  });

  /// Error message
  final String message;

  /// Detailed error information (optional)
  final String? details;

  /// Callback when OK button is pressed
  final VoidCallback? onOkPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppDialog(
      minWidth: 400,
      maxWidth: 600,
      // Remove minHeight to adjust dynamically based on content
      showDivider: false,
      footer: Padding(
        padding: const EdgeInsets.all(AppSpacingValues.xl),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Copy button for error details (only if details exist)
            if (details != null)
              AppIconButton(
                icon: AppIcons.copy,
                onPressed: () => _copyErrorDetails(context),
                tooltip: 'Copy error details',
              ),
            const SizedBox(width: 8),
            AppButton.primary(
              label: 'OK',
              onPressed: () {
                Navigator.of(context).pop();
                onOkPressed?.call();
              },
            ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon area (left side)
          Column(
            children: [
              const SizedBox(height: 4), // Adjust icon to align with title
              AppIcon(
                AppIcons.error,
                size: AppIconSize.large,
                color: AppIconColor.error,
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Content area (right side)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message
                AppText(message, variant: AppTextVariant.bodyText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Copy error details along with system information
  void _copyErrorDetails(BuildContext context) {
    if (details == null) return;

    final systemInfo = _getSystemInfo();
    final appVersion = _getAppVersion();

    final copyContent = '''
Error details:
$details

System information:
- OS: ${systemInfo['operatingSystem']}
- Version: ${systemInfo['operatingSystemVersion']}
- Architecture: ${systemInfo['architecture']}

Application information:
- Version: $appVersion
''';

    Clipboard.setData(ClipboardData(text: copyContent));

    // TODO: Notify copy completion
    // Use method other than ScaffoldMessenger. It crashes.
    // showToast?
  }

  /// Get system information
  Map<String, String> _getSystemInfo() {
    return {
      'operatingSystem': Platform.operatingSystem,
      'operatingSystemVersion': Platform.operatingSystemVersion,
      'architecture': _getArchitecture(),
    };
  }

  /// Get architecture information
  String _getArchitecture() {
    // Limited ways to get architecture in Dart
    // For actual implementation, recommend using package_info_plus
    return 'unknown';
  }

  /// Get app version
  String _getAppVersion() {
    // For actual implementation, use package_info_plus to get version info
    return '1.0.0';
  }
}

/// Helper function to show error dialog
Future<void> showAppErrorDialog(
  BuildContext context, {
  required String message,
  String? details,
  VoidCallback? onOkPressed,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AppErrorDialog(
          message: message,
          details: details,
          onOkPressed: onOkPressed,
        ),
  );
}

/// Helper function to show warning dialog
Future<bool?> showAppWarningDialog(
  BuildContext context, {
  required String message,
  required List<String> warningItems,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String confirmLabel = 'Execute',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AppWarningDialog(
          message: message,
          warningItems: warningItems,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: isDestructive,
        ),
  );
}

/// Helper function to show error dialog using ErrorDialogData
Future<void> showAppErrorDialogFromData(
  BuildContext context, {
  required ErrorDialogData errorData,
  VoidCallback? onOkPressed,
}) {
  if (!errorData.hasError) {
    // Do nothing if there is no error
    return Future.value();
  }

  return showAppErrorDialog(
    context,
    message: errorData.message,
    details: errorData.details,
    onOkPressed: onOkPressed,
  );
}
