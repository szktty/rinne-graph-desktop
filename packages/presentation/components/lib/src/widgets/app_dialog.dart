import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'app_rectangle_border.dart';
import 'app_physical_model.dart';
import 'app_divider.dart';
import 'app_icon_button.dart';
import '../spacing/app_padding.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_text.dart';
import '../icons/app_icons.dart';

/// Enum representing dialog importance
enum DialogImportance {
  /// Critical dialog (28px) - errors, warnings, destructive actions
  critical,

  /// Standard dialog (16px Bold) - settings, forms, general actions
  standard,

  /// Utility dialog (16px Bold) - filters, search, auxiliary functions
  utility,
}

/// Common Dialog for App app
///
/// Provides unified dialog style across the application.
/// Theme colors are obtained via AppThemeData capsule,
/// not directly accessing Flutter standard ColorScheme or Theme.of.
class AppDialog extends ConsumerWidget {
  /// Header title (large font size)
  final String? title;

  /// Subtitle (normal font size)
  final String? subtitle;

  /// Child widget
  final Widget child;

  /// Footer widget (fixed at bottom, outside scrollable area)
  final Widget? footer;

  /// Dialog width
  final double? width;

  /// Dialog height
  final double? height;

  /// Dialog height as ratio to window size
  /// Value range 0.0-1.0 (e.g., 0.8 = 80% of window height)
  /// Takes precedence over height parameter
  final double? heightRatio;

  /// Dialog maximum width
  final double? maxWidth;

  /// Dialog maximum height
  final double? maxHeight;

  /// Dialog minimum width
  final double? minWidth;

  /// Dialog minimum height
  final double? minHeight;

  /// Dialog inner padding
  final EdgeInsetsGeometry? padding;

  /// Vertical space between header and divider (default: 8px)
  final double? headerBottomSpacing;

  /// Divider horizontal padding (default: 0px)
  final double? dividerHorizontalPadding;

  /// Dialog shadow height
  final double elevation;

  /// Dialog corner radius
  final double? cornerRadius;

  /// Dialog corner smoothing
  final double? cornerSmoothing;

  /// Dialog background color (auto-fetched from theme if not specified)
  final Color? backgroundColor;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Whether to show close button in top right
  final bool showCloseButton;

  /// Callback when close button is pressed
  /// If not specified, Navigator.of(context).pop() is executed
  final VoidCallback? onClose;

  /// Dialog importance (affects title font size)
  final DialogImportance importance;

  /// Whether to show divider below header (default: true)
  final bool showDivider;

  /// Constructor
  const AppDialog({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.width,
    this.height,
    this.heightRatio,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.padding,
    this.headerBottomSpacing,
    this.dividerHorizontalPadding,
    this.elevation = 8.0,
    this.cornerRadius,
    this.cornerSmoothing,
    this.backgroundColor,
    this.disableZoom = false,
    this.showCloseButton = false,
    this.onClose,
    this.importance = DialogImportance.standard,
    this.showDivider = true,
  });

  /// Get title variant based on importance
  AppTextVariant _getTitleVariant() {
    return switch (importance) {
      DialogImportance.critical => AppTextVariant.dialogTitleCritical,
      DialogImportance.standard => AppTextVariant.dialogTitleStandard,
      DialogImportance.utility => AppTextVariant.dialogTitleUtility,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme colors using core_themes API
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    // Get shape from appRectangleBorderProvider
    final shape = ref.watch(appRectangleBorderProvider);

    // Determine dialog background color
    final effectiveBackgroundColor =
        backgroundColor ?? appColorScheme.uiAreas.dialog.background;

    // Get window size using MediaQuery
    final screenSize = MediaQuery.of(context).size;

    // If heightRatio is specified, calculate height based on it
    final effectiveHeight =
        heightRatio != null ? screenSize.height * heightRatio! : height;

    // Apply zoom scaling to dimensional values
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final scaledWidth = width != null ? width! * zoomScale : null;
    final scaledHeight =
        effectiveHeight != null ? effectiveHeight * zoomScale : null;
    final scaledMaxWidth = maxWidth != null ? maxWidth! * zoomScale : null;
    final scaledMaxHeight = maxHeight != null ? maxHeight! * zoomScale : null;
    final scaledMinWidth = minWidth != null ? minWidth! * zoomScale : null;
    final scaledMinHeight = minHeight != null ? minHeight! * zoomScale : null;

    // Scale padding if provided
    EdgeInsetsGeometry? scaledPadding;
    if (padding != null) {
      final resolvedPadding = padding!.resolve(TextDirection.ltr);
      scaledPadding = EdgeInsets.fromLTRB(
        resolvedPadding.left * zoomScale,
        resolvedPadding.top * zoomScale,
        resolvedPadding.right * zoomScale,
        resolvedPadding.bottom * zoomScale,
      );
    }

    debugPrint('scaledHeight: $scaledHeight');
    final hasFooter = footer != null;

    return Dialog(
      elevation:
          0, // Set elevation to 0 to control shadow with AppPhysicalModel
      backgroundColor: Colors.transparent, // Make background transparent
      shape: shape,
      child: AppPhysicalModelVariants.popover(
        color: effectiveBackgroundColor,
        borderRadius: shape.borderRadius,
        disableZoom: disableZoom,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content area (scrollable if height is specified)
            Flexible(
              child:
                  scaledHeight != null
                      ? ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: scaledMaxWidth ?? double.infinity,
                          maxHeight:
                              scaledMaxHeight ??
                              (screenSize.height *
                                  0.9), // Limit to 90% of screen
                          minWidth: scaledMinWidth ?? 0.0,
                          minHeight: scaledMinHeight ?? 0.0,
                        ),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: scaledWidth,
                            height: scaledHeight,
                            child: _buildDialogContent(
                              scaledPadding,
                              effectiveHeight,
                            ),
                          ),
                        ),
                      )
                      : Container(
                        width: scaledWidth,
                        constraints: BoxConstraints(
                          maxWidth: scaledMaxWidth ?? double.infinity,
                          minWidth: scaledMinWidth ?? 0.0,
                        ),
                        child: _buildDialogContent(
                          scaledPadding,
                          effectiveHeight,
                        ),
                      ),
            ),
            // Fixed footer area (outside scrollable area)
            if (hasFooter)
              Container(
                width: scaledWidth,
                constraints: BoxConstraints(
                  maxWidth: scaledMaxWidth ?? double.infinity,
                  minWidth: scaledMinWidth ?? 0.0,
                ),
                child: footer!,
              ),
          ],
        ),
      ),
    );
  }

  /// Build dialog content
  Widget _buildDialogContent(
    EdgeInsetsGeometry? scaledPadding,
    double? effectiveHeight,
  ) {
    final hasHeader = title != null;
    final hasSubtitle = subtitle != null;
    final hasHeaderContent = hasHeader || hasSubtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize:
          effectiveHeight != null ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (hasHeaderContent) ..._buildHeader(),
        if (hasHeaderContent) ..._buildDividerSection(),
        // If height is specified use Expanded, otherwise place directly
        effectiveHeight != null
            ? Expanded(
              child:
                  scaledPadding != null
                      ? AppPadding(
                        padding: scaledPadding,
                        disableZoom: disableZoom,
                        child: child,
                      )
                      : AppPadding.xxxl(disableZoom: disableZoom, child: child),
            )
            : scaledPadding != null
            ? AppPadding(
              padding: scaledPadding,
              disableZoom: disableZoom,
              child: child,
            )
            : AppPadding.xxxl(disableZoom: disableZoom, child: child),
      ],
    );
  }

  /// Build header section
  List<Widget> _buildHeader() {
    // TODO: zoom
    const iconSize = 20.0;
    return [
      AppPadding.only(
        left: AppSpacingValues.xxxl,
        right: AppSpacingValues.xxxl,
        top: AppSpacingValues.lg, // Changed from xxxl(32px) to lg(16px)
        disableZoom: disableZoom,
        child: Consumer(
          builder: (context, ref, child) {
            final appColorScheme = ref.watch(effectiveColorSchemeProvider);
            return Stack(
              children: [
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      AppText(
                        title!,
                        variant: _getTitleVariant(),
                        color: appColorScheme.base.foreground,
                      ),
                    if (title != null && subtitle != null)
                      const AppSpacing.sm(),
                    if (subtitle != null)
                      AppText(
                        subtitle!,
                        variant: AppTextVariant.bodyText,
                        color: appColorScheme.base.foreground,
                      ),
                  ],
                ),
                // Close button
                if (showCloseButton)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: AppIconButton.minimal(
                      icon: AppIcons.x,
                      onPressed: () {
                        if (onClose != null) {
                          onClose!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      tooltip: 'Close',
                      iconSize: iconSize,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ];
  }

  /// Build divider section
  List<Widget> _buildDividerSection() {
    final horizontalPadding = dividerHorizontalPadding ?? 0.0;
    final bottomSpacing = headerBottomSpacing ?? AppSpacingValues.lg;

    return [
      // Control spacing between header and divider
      bottomSpacing > 1
          ? SizedBox(height: bottomSpacing)
          : const SizedBox.shrink(),
      // Show divider only if showDivider is true
      if (showDivider)
        AppDivider(
          indent: horizontalPadding,
          endIndent: horizontalPadding,
          disableZoom: disableZoom,
        ),
    ];
  }
}

/// Function to show AppDialog
///
/// Calls showDialog with app-specific default values.
/// Common dialog options like barrierDismissible, barrierColor, useSafeArea
/// can be customized.
///
/// Either [child] or [builder] must be specified.
/// Using [builder] allows dynamic construction of dialog content.
///
/// padding: 32px (xxxl) is applied by default for desktop optimization
Future<T?> showAppDialog<T>({
  required BuildContext context,
  String? title,
  String? subtitle,
  Widget? child,
  WidgetBuilder? builder,
  Widget? footer,
  double? width,
  double? height,
  double? heightRatio,
  double? maxWidth,
  double? maxHeight,
  double? minWidth,
  double? minHeight,
  EdgeInsetsGeometry? padding = AppPaddingValues.xl,
  double? headerBottomSpacing,
  double? dividerHorizontalPadding,
  double elevation = 8.0,
  double? cornerRadius,
  double? cornerSmoothing,
  Color? backgroundColor,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,

  /// Set to true to not darken background
  bool noDarkBackground = false,

  /// Whether to show close button in top right
  bool showCloseButton = false,

  /// Callback when close button is pressed
  VoidCallback? onClose,

  /// Dialog importance (affects title font size)
  DialogImportance importance = DialogImportance.standard,

  /// Whether to show divider below header (default: true)
  bool showDivider = true,
}) {
  // Either child or builder is required
  assert(
    child != null || builder != null,
    'Either child or builder must be provided',
  );
  assert(
    !(child != null && builder != null),
    'Cannot provide both child and builder',
  );

  // Capture child widget to avoid naming conflicts
  final dialogChild = child;
  // Save theme and pass to dialog
  final theme = Theme.of(context);

  // Make background transparent if not darkening
  final effectiveBarrierColor =
      noDarkBackground ? Colors.transparent : barrierColor;

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: effectiveBarrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    traversalEdgeBehavior: traversalEdgeBehavior,
    builder:
        (dialogContext) => Theme(
          data: theme, // Explicitly pass parent context theme
          child: Consumer(
            builder: (context, ref, _) {
              final accessibilityConfig = ref.watch(
                accessibilityConfigProvider,
              );
              final zoomScale = accessibilityConfig.zoomScale;

              // Get window size using MediaQuery
              final screenSize = MediaQuery.of(context).size;

              // If heightRatio is specified, calculate height based on it
              final effectiveHeight =
                  heightRatio != null
                      ? screenSize.height * heightRatio
                      : height;

              // Apply zoom scaling to dialog function parameters
              final scaledWidth = width != null ? width * zoomScale : null;
              final scaledHeight =
                  effectiveHeight != null ? effectiveHeight * zoomScale : null;
              final scaledMaxWidth =
                  maxWidth != null ? maxWidth * zoomScale : null;
              final scaledMaxHeight =
                  maxHeight != null ? maxHeight * zoomScale : null;
              final scaledMinWidth =
                  minWidth != null ? minWidth * zoomScale : null;
              final scaledMinHeight =
                  minHeight != null ? minHeight * zoomScale : null;
              final scaledElevation = elevation * zoomScale;
              final scaledCornerRadius =
                  cornerRadius != null ? cornerRadius * zoomScale : null;

              // Scale padding (desktop optimization: default is xxxl=32px)
              EdgeInsetsGeometry? scaledPadding;
              // padding has non-null default value so always processed
              final resolvedPadding = padding!.resolve(TextDirection.ltr);
              scaledPadding = EdgeInsets.fromLTRB(
                resolvedPadding.left * zoomScale,
                resolvedPadding.top * zoomScale,
                resolvedPadding.right * zoomScale,
                resolvedPadding.bottom * zoomScale,
              );

              // Build dynamically if builder is specified, otherwise use child
              final effectiveChild =
                  builder != null ? builder(context) : dialogChild!;

              return AppDialog(
                title: title,
                subtitle: subtitle,
                footer: footer,
                width: scaledWidth,
                height: scaledHeight,
                heightRatio: heightRatio,
                maxWidth: scaledMaxWidth,
                maxHeight: scaledMaxHeight,
                minWidth: scaledMinWidth,
                minHeight: scaledMinHeight,
                padding: scaledPadding,
                headerBottomSpacing: headerBottomSpacing,
                dividerHorizontalPadding: dividerHorizontalPadding,
                elevation: scaledElevation,
                cornerRadius: scaledCornerRadius,
                cornerSmoothing: cornerSmoothing,
                backgroundColor: backgroundColor,
                showCloseButton: showCloseButton,
                onClose: onClose,
                importance: importance,
                showDivider: showDivider,
                child: effectiveChild,
              );
            },
          ),
        ),
  );
}
