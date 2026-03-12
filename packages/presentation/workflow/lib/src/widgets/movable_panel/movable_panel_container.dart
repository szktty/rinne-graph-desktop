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
import '../../models/panel_geometry.dart';

/// Generic panel component for App applications
class AppPanel extends ConsumerStatefulWidget {
  const AppPanel({
    super.key,
    required this.child,
    required this.initialPosition,
    required this.initialSize,
    this.minSize = const Size(280, 160),
    this.maxSize,
    this.onPositionChanged,
    this.onSizeChanged,
    this.onDraggingChanged,
    this.canMove = true,
    this.canResize = true,
    this.canDock = true,
    this.canClose = true,
    this.dockingThreshold = 20.0,
    this.title = 'Panel',
    this.onClose,
  });

  final Widget child;
  final Offset initialPosition;
  final Size initialSize;
  final Size minSize;
  final Size? maxSize;
  final void Function(Offset)? onPositionChanged;
  final void Function(Size)? onSizeChanged;
  final void Function(bool)? onDraggingChanged;
  final bool canMove;
  final bool canResize;
  final bool canDock;
  final bool canClose;
  final double dockingThreshold;
  final String title;
  final VoidCallback? onClose;

  @override
  ConsumerState<AppPanel> createState() => _AppPanelState();
}

class _AppPanelState extends ConsumerState<AppPanel> {
  late Offset position;
  late Size size;
  bool isDragging = false;
  bool isResizing = false;
  DockingState dockingState = DockingState.floating;
  Offset dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
    size = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size.width,
      height: size.height,
      child: FondePhysicalModelVariants.panel(
        isDragging: isDragging,
        animationDuration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isDragging
                      ? appColorScheme.base.border
                      : appColorScheme.base.border,
            ),
          ),
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  _buildTitleBar(context, appColorScheme),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: widget.child,
                    ),
                  ),
                ],
              ),
              // Resize handle
              if (widget.canResize) _buildResizeHandle(context, appColorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context, AppColorScheme appColorScheme) {
    return GestureDetector(
      onPanStart:
          widget.canMove ? (details) => _handleDragStart(details) : null,
      onPanUpdate:
          widget.canMove ? (details) => _handleDragUpdate(details) : null,
      onPanEnd: widget.canMove ? (details) => _handleDragEnd(context) : null,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: appColorScheme.uiAreas.panel.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: appColorScheme.base.foreground,
                ),
              ),
            ),
            if (widget.canClose && widget.onClose != null)
              IconButton(
                onPressed: widget.onClose,
                icon: Icon(Icons.close, color: appColorScheme.base.foreground),
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResizeHandle(
    BuildContext context,
    AppColorScheme appColorScheme,
  ) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onPanStart: (details) => _handleResizeStart(),
        onPanUpdate: (details) => _handleResizeUpdate(details),
        onPanEnd: (details) => _handleResizeEnd(),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: appColorScheme.base.foreground.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Icon(
            Icons.drag_handle,
            size: 12,
            color: appColorScheme.base.foreground,
          ),
        ),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
      // Calculate click position within the panel by subtracting panel position from global position
      dragOffset = details.globalPosition - position;
    });
    widget.onDraggingChanged?.call(true);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Calculate panel position by subtracting offset within the panel from global position
    final newPosition = details.globalPosition - dragOffset;
    setState(() {
      position = newPosition;
    });
    widget.onPositionChanged?.call(newPosition);
  }

  void _handleDragEnd(BuildContext context) {
    setState(() {
      isDragging = false;
    });
    widget.onDraggingChanged?.call(false);

    if (widget.canDock) {
      _checkDocking(context);
    }
  }

  void _handleResizeStart() {
    setState(() {
      isResizing = true;
    });
  }

  void _handleResizeUpdate(DragUpdateDetails details) {
    final newWidth = (size.width + details.delta.dx).clamp(
      widget.minSize.width,
      widget.maxSize?.width ?? double.infinity,
    );
    final newHeight = (size.height + details.delta.dy).clamp(
      widget.minSize.height,
      widget.maxSize?.height ?? double.infinity,
    );
    final newSize = Size(newWidth, newHeight);
    setState(() {
      size = newSize;
    });
    widget.onSizeChanged?.call(newSize);
  }

  void _handleResizeEnd() {
    setState(() {
      isResizing = false;
    });
  }

  void _checkDocking(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final threshold = widget.dockingThreshold;

    DockingState newDockingState = DockingState.floating;
    Offset newPosition = position;

    // Check top edge
    if (position.dy <= threshold) {
      newDockingState = DockingState.top;
      newPosition = Offset(position.dx, 0);
    }
    // Check bottom edge
    else if (position.dy + size.height >= screenSize.height - threshold) {
      newDockingState = DockingState.bottom;
      newPosition = Offset(position.dx, screenSize.height - size.height);
    }
    // Check left edge
    else if (position.dx <= threshold) {
      newDockingState = DockingState.left;
      newPosition = Offset(0, position.dy);
    }
    // Check right edge
    else if (position.dx + size.width >= screenSize.width - threshold) {
      newDockingState = DockingState.right;
      newPosition = Offset(screenSize.width - size.width, position.dy);
    }

    if (newDockingState != DockingState.floating || newPosition != position) {
      setState(() {
        dockingState = newDockingState;
        if (newPosition != position) {
          position = newPosition;
        }
      });
      if (newPosition != position) {
        widget.onPositionChanged?.call(newPosition);
      }
    }
  }
}
