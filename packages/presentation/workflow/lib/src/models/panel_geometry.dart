import 'package:flutter/material.dart';

/// Model representing panel position and size
class PanelGeometry {
  const PanelGeometry({required this.position, required this.size});

  final Offset position;
  final Size size;

  /// Gets the rectangular area of the panel
  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

  /// Copy with new position
  PanelGeometry copyWithPosition(Offset newPosition) {
    return PanelGeometry(position: newPosition, size: size);
  }

  /// Copy with new size
  PanelGeometry copyWithSize(Size newSize) {
    return PanelGeometry(position: position, size: newSize);
  }

  /// Copy method
  PanelGeometry copyWith({Offset? position, Size? size}) {
    return PanelGeometry(
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

/// Enum representing docking state
enum DockingState {
  /// Not docked (floating state)
  floating,

  /// Docked to top edge
  top,

  /// Docked to bottom edge
  bottom,

  /// Docked to left edge
  left,

  /// Docked to right edge
  right,
}

/// Panel state including docking information
class PanelState {
  const PanelState({
    required this.geometry,
    this.dockingState = DockingState.floating,
    this.isVisible = false,
    this.isDragging = false,
    this.isResizing = false,
  });

  final PanelGeometry geometry;
  final DockingState dockingState;
  final bool isVisible;
  final bool isDragging;
  final bool isResizing;

  /// Whether the panel is docked
  bool get isDocked => dockingState != DockingState.floating;

  /// Copy method
  PanelState copyWith({
    PanelGeometry? geometry,
    DockingState? dockingState,
    bool? isVisible,
    bool? isDragging,
    bool? isResizing,
  }) {
    return PanelState(
      geometry: geometry ?? this.geometry,
      dockingState: dockingState ?? this.dockingState,
      isVisible: isVisible ?? this.isVisible,
      isDragging: isDragging ?? this.isDragging,
      isResizing: isResizing ?? this.isResizing,
    );
  }
}
