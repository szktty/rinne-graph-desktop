import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppScrollView extends StatefulWidget {
  const AppScrollView({
    super.key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.padding,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.showScrollbar = true,
    this.scrollbarThickness = 8.0,
    this.scrollbarRadius = const Radius.circular(4),
  });

  final Widget child;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final bool showScrollbar;
  final double scrollbarThickness;
  final Radius scrollbarRadius;

  @override
  State<AppScrollView> createState() => _AppScrollViewState();
}

class _AppScrollViewState extends State<AppScrollView> {
  ScrollController? _internalController;

  ScrollController get _effectiveController {
    return widget.controller ?? _internalController!;
  }

  @override
  void initState() {
    super.initState();
    // Create internal controller only if no external controller is provided
    if (widget.controller == null) {
      _internalController = ScrollController();
    }
  }

  @override
  void dispose() {
    // Only dispose the internal controller we created
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController = _effectiveController;

    // Force primary to false when we have an explicit controller
    // This prevents conflicts with PrimaryScrollController
    final shouldUsePrimary =
        widget.controller == null && widget.primary != false;

    final scrollView = SingleChildScrollView(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller == null ? null : effectiveController,
      primary: shouldUsePrimary,
      physics:
          widget.physics ??
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: widget.padding,
      clipBehavior: widget.clipBehavior,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      child: widget.child,
    );

    if (!widget.showScrollbar) {
      return scrollView;
    }

    // Fix for "ScrollController has no ScrollPosition attached" error
    // When using primary controller, don't pass any controller to Scrollbar
    // This lets it automatically find the primary controller
    return Scrollbar(
      controller: shouldUsePrimary ? null : effectiveController,
      thumbVisibility: false,
      thickness: widget.scrollbarThickness,
      radius: widget.scrollbarRadius,
      child: scrollView,
    );
  }
}
