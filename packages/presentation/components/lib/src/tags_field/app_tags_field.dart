import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:presentation_components/src/icons/app_icons.dart';

/// Label tag editing field
///
/// Provides a tag input field for editing entity labels and more.
/// Implemented using the textfield_tags package.
class AppTagsField extends ConsumerWidget {
  /// Constructor
  const AppTagsField({
    super.key,
    this.initialTags = const [],
    this.onTagsChanged,
    this.hintText = 'Enter a tag...',
    this.validator,
    this.textSeparators = const [' ', ','],
    this.maxTagLength = 50,
    this.minTagLength = 1,
    this.maxTags,
    this.tagBackgroundColor,
    this.tagTextColor,
    this.enabled = true,
    this.disableZoom = false,
  });

  /// Initial list of tags.
  final List<String> initialTags;

  /// Callback for when tags are changed.
  final void Function(List<String> tags)? onTagsChanged;

  /// Hint text.
  final String hintText;

  /// Validator function.
  final String? Function(String tag)? validator;

  /// Characters that separate tags.
  final List<String> textSeparators;

  /// Maximum tag length.
  final int maxTagLength;

  /// Minimum tag length.
  final int minTagLength;

  /// Maximum number of tags.
  final int? maxTags;

  /// Background color of the tag.
  final Color? tagBackgroundColor;

  /// Text color of the tag.
  final Color? tagTextColor;

  /// Whether it is enabled.
  final bool enabled;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the new color scheme provider that responds to theme mode changes
    final appColorScheme = ref.watch(appColorSchemeProvider);
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // Use StringTagController
    final controller = StringTagController();

    // Set initial tags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialTags.isNotEmpty) {
        for (final tag in initialTags) {
          controller.addTag(tag);
        }
      }
    });

    return TextFieldTags<String>(
      textfieldTagsController: controller,
      initialTags: initialTags,
      textSeparators: textSeparators,
      letterCase: LetterCase.normal,
      validator: validator,
      inputFieldBuilder: (context, inputFieldValues) {
        return Container(
          decoration: ShapeDecoration(
            // TODO: Add color for labels
            color: appColorScheme.uiAreas.sideBar.background,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 8 * zoomScale,
                cornerSmoothing: 0.6,
              ),
              side: BorderSide(
                color:
                    inputFieldValues.focusNode.hasFocus
                        // TODO: Prepare an appropriate theme color here as well
                        ? appColorScheme.base.background
                        : const Color(0x00000000),
                width: 1.0 * borderScale,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag display area
              if (controller.getTags?.isNotEmpty ?? false)
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.0 * zoomScale,
                    right: 8.0 * zoomScale,
                    top: 8.0 * zoomScale,
                    bottom: 4.0 * zoomScale,
                  ),
                  child: Wrap(
                    spacing: 8.0 * zoomScale,
                    runSpacing: 4.0 * zoomScale,
                    children: [
                      for (final tag in controller.getTags ?? [])
                        _buildTag(
                          context,
                          tag,
                          controller,
                          appColorScheme,
                          zoomScale,
                          borderScale,
                        ),
                    ],
                  ),
                ),

              // Input field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0 * zoomScale),
                child: TextField(
                  controller: inputFieldValues.textEditingController,
                  focusNode: inputFieldValues.focusNode,
                  enabled: enabled,
                  decoration: InputDecoration(
                    hintText:
                        controller.getTags?.isEmpty ?? true
                            ? hintText
                            : '+ Add tag',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0 * zoomScale,
                      horizontal: 8.0 * zoomScale,
                    ),
                    isDense: true,
                  ),
                  // TODO: style
                ),
              ),

              // Error message
              if (controller.getError != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0 * zoomScale,
                    bottom: 8.0 * zoomScale,
                    right: 16.0 * zoomScale,
                  ),
                  child: Text(
                    controller.getError!,
                    // TODO: style
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the tag widget
  Widget _buildTag(
    BuildContext context,
    String tag,
    StringTagController controller,
    AppColorScheme appColorScheme,
    double zoomScale,
    double borderScale,
  ) {
    final theme = Theme.of(context);
    // TODO: Prepare an appropriate theme color
    final actualTagColor =
        tagBackgroundColor ?? appColorScheme.appSpecific.metadata.tagText;
    final actualTextColor = tagTextColor ?? theme.colorScheme.onPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0 * zoomScale,
        vertical: 4.0 * zoomScale,
      ),
      decoration: ShapeDecoration(
        color: actualTagColor.withValues(alpha: 0.2),
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16 * zoomScale,
            cornerSmoothing: 0.6,
          ),
          side: BorderSide(
            color: actualTagColor.withValues(alpha: 0.3),
            width: 1.0 * borderScale,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: theme.textTheme.bodySmall?.copyWith(color: actualTextColor),
          ),
          if (enabled)
            GestureDetector(
              onTap: () {
                controller.removeTag(tag);
                if (onTagsChanged != null) {
                  onTagsChanged!(controller.getTags ?? []);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 4.0 * zoomScale),
                child: Icon(
                  AppIcons.x,
                  size: 14.0 * zoomScale,
                  color: actualTagColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
