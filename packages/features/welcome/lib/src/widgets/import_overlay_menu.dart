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

/// Overlay menu item for import button.
class ImportMenuItem {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const ImportMenuItem({
    required this.label,
    required this.onPressed,
    required this.icon,
  });
}

/// Overlay menu widget for import button.
///
/// Displays three import options: Stack, CSV, and JSON.
class ImportOverlayMenu extends ConsumerStatefulWidget {
  final List<ImportMenuItem> items;

  const ImportOverlayMenu({super.key, required this.items});

  @override
  ConsumerState<ImportOverlayMenu> createState() => _ImportOverlayMenuState();
}

class _ImportOverlayMenuState extends ConsumerState<ImportOverlayMenu> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _showOverlay() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final appColorScheme = ref.read(effectiveColorSchemeProvider);

    // Calculate overlay menu size
    const double itemHeight = 40.0;
    const double padding = 8.0;
    final overlayHeight = (widget.items.length * itemHeight) + (padding * 2);

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: _removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                // Transparent area covering the entire screen
                Positioned.fill(child: Container(color: Colors.transparent)),
                // Overlay menu body
                Positioned(
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0, size.height + 4),
                    child: GestureDetector(
                      onTap: () {}, // Menu taps should not propagate to parent
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 200,
                          height: overlayHeight,
                          decoration: BoxDecoration(
                            color: appColorScheme.uiAreas.sideBar.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: appColorScheme.base.border,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(padding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  widget.items.map((item) {
                                    return _ImportMenuItemWidget(
                                      item: item,
                                      onTap: () {
                                        item.onPressed();
                                        _removeOverlay();
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AppIconButton(
        onPressed: _showOverlay,
        icon: Icons.upload_file,
        iconSize: 24,
        tooltip: 'Import Stack',
      ),
    );
  }
}

/// Widget for import menu item.
class _ImportMenuItemWidget extends ConsumerStatefulWidget {
  final ImportMenuItem item;
  final VoidCallback onTap;

  const _ImportMenuItemWidget({required this.item, required this.onTap});

  @override
  ConsumerState<_ImportMenuItemWidget> createState() =>
      _ImportMenuItemWidgetState();
}

class _ImportMenuItemWidgetState extends ConsumerState<_ImportMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color:
                _isHovered
                    ? appColorScheme.interactive.dropdown.itemBackground.hover
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                widget.item.icon,
                size: 16,
                color: appColorScheme.appSpecific.metadata.propertyValue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  widget.item.label,
                  variant: AppTextVariant.bodyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
