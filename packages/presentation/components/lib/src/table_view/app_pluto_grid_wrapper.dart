import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// A wrapper providing a combination of PlutoGrid + AppGestureDetector
///
/// This component provides the following features:
/// - Fast tap detection (AppGestureDetector)
/// - Identification of row index from tap position
/// - Standard event control of PlutoGrid
///
/// Example usage:
/// ```dart
/// AppPlutoGridWrapper(
///   columns: columns,
///   rows: rows,
///   mode: PlutoGridMode.select,
///   onRowTapped: (rowIndex, position) {
///     print('Row $rowIndex tapped at $position');
///   },
/// )
/// ```
class AppPlutoGridWrapper extends StatefulWidget {
  /// Column definitions for PlutoGrid
  final List<PlutoColumn> columns;

  /// Row data for PlutoGrid
  final List<PlutoRow> rows;

  /// Mode of PlutoGrid
  final PlutoGridMode mode;

  /// Configuration of PlutoGrid
  final PlutoGridConfiguration configuration;

  /// Callback when PlutoGrid loading is complete
  final PlutoOnLoadedEventCallback? onLoaded;

  /// Callback when PlutoGrid data changes
  final PlutoOnChangedEventCallback? onChanged;

  /// Behavior settings for AppGestureDetector
  final HitTestBehavior gestureDetectorBehavior;

  /// Whether to enable fast tap detection
  final bool enableFastTapDetection;

  /// Callback when a row is tapped
  /// tapPosition: Tap position (local coordinates)
  final Function(int rowIndex, Offset tapPosition)? onRowTapped;

  /// Callback when a row is double-tapped
  /// rowIndex: Index of the double-tapped row
  /// tapPosition: Tap position (local coordinates)
  final Function(int rowIndex, Offset tapPosition)? onRowDoubleTapped;

  /// Standard selection event of PlutoGrid (usually disabled)
  final PlutoOnSelectedEventCallback? onPlutoSelected;

  /// Standard double-tap event of PlutoGrid (usually disabled)
  final PlutoOnRowDoubleTapEventCallback? onPlutoRowDoubleTap;

  /// Whether to enable debug logs
  final bool enableDebugLogs;

  /// Prefix for debug logs
  final String debugPrefix;

  const AppPlutoGridWrapper({
    super.key,
    required this.columns,
    required this.rows,
    required this.mode,
    required this.configuration,
    this.onLoaded,
    this.onChanged,
    this.gestureDetectorBehavior = HitTestBehavior.opaque,
    this.enableFastTapDetection = true,
    this.onRowTapped,
    this.onRowDoubleTapped,
    this.onPlutoSelected,
    this.onPlutoRowDoubleTap,
    this.enableDebugLogs = false,
    this.debugPrefix = 'AppPlutoGridWrapper',
  });

  @override
  State<AppPlutoGridWrapper> createState() => _AppPlutoGridWrapperState();
}

class _AppPlutoGridWrapperState extends State<AppPlutoGridWrapper> {
  PlutoGridStateManager? _stateManager;
  bool _tapProcessed =
      false; // Flag indicating whether a tap has been processed

  // For double-tap detection
  DateTime? _lastTapTime;
  static const Duration _doubleTapTimeout = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    if (widget.enableFastTapDetection) {
      // Use only Listener if fast tap detection is enabled
      return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handlePointerDown,
        onPointerUp: _handlePointerUp,
        child: _buildPlutoGrid(),
      );
    } else {
      // Use PlutoGrid's standard events if fast tap detection is disabled
      return _buildPlutoGrid();
    }
  }

  /// Builds the PlutoGrid
  Widget _buildPlutoGrid() {
    return PlutoGrid(
      columns: widget.columns,
      rows: widget.rows,
      mode: widget.mode,
      configuration: widget.configuration,
      onLoaded: _handleLoaded,
      onChanged: widget.onChanged,
      onSelected: widget.enableFastTapDetection ? null : widget.onPlutoSelected,
      onRowDoubleTap:
          widget.enableFastTapDetection ? null : widget.onPlutoRowDoubleTap,
    );
  }

  /// Handles PlutoGrid loading completion
  void _handleLoaded(PlutoGridOnLoadedEvent event) {
    _stateManager = event.stateManager;
    _debugLog('PlutoGrid loaded');
    widget.onLoaded?.call(event);
  }

  /// Handles pointer down (low-level event)
  void _handlePointerDown(PointerDownEvent event) {
    _tapProcessed = false;
    _debugLog('Pointer down at position: ${event.localPosition}');

    // Execute row selection process immediately on pointer down
    final rowIndex = _calculateRowIndexFromPosition(event.localPosition);
    if (rowIndex != null) {
      _debugLog('Row $rowIndex pointer down at ${event.localPosition}');
      widget.onRowTapped?.call(rowIndex, event.localPosition);
      _tapProcessed = true;
    } else {
      _debugLog(
        'Pointer down position outside valid rows: ${event.localPosition}',
      );
    }
  }

  /// Handles pointer up (low-level event)
  void _handlePointerUp(PointerUpEvent event) {
    _debugLog('Pointer up at position: ${event.localPosition}');

    // Double-tap detection
    final now = DateTime.now();
    final isDoubleTap =
        _lastTapTime != null &&
        now.difference(_lastTapTime!) < _doubleTapTimeout;

    if (isDoubleTap) {
      _debugLog('Double tap detected');
      final rowIndex = _calculateRowIndexFromPosition(event.localPosition);
      if (rowIndex != null) {
        _debugLog('Row $rowIndex double tapped at ${event.localPosition}');
        widget.onRowDoubleTapped?.call(rowIndex, event.localPosition);
      }
      _lastTapTime = null; // Reset after double-tap
      return;
    }

    _lastTapTime = now; // Record the time of a single tap

    if (_tapProcessed) {
      _debugLog('Selection already processed in pointer down');
      return;
    }

    // Backup processing if not handled by pointer down
    final rowIndex = _calculateRowIndexFromPosition(event.localPosition);
    if (rowIndex != null) {
      _debugLog('Backup: Row $rowIndex pointer up at ${event.localPosition}');
      widget.onRowTapped?.call(rowIndex, event.localPosition);
      _tapProcessed = true;
    }
  }

  /// Calculates row index from tap position
  ///
  /// Currently simplified implementation:
  /// - Considers header height
  /// - Assumes fixed row height
  /// - Scroll position not considered (to be implemented in Phase 2)
  int? _calculateRowIndexFromPosition(Offset localPosition) {
    if (_stateManager == null) {
      _debugLog('StateManager not available');
      return null;
    }

    try {
      // Get header height
      final headerHeight = _stateManager!.configuration.style.columnHeight;

      // Invalid if tap position is within the header
      if (localPosition.dy < headerHeight) {
        _debugLog(
          'Tap in header area: y=${localPosition.dy}, headerHeight=$headerHeight',
        );
        return null;
      }

      // Get row height (currently assuming a fixed value)
      final rowHeight = _stateManager!.configuration.style.rowHeight;

      // Relative position within the content area
      final contentY = localPosition.dy - headerHeight;

      // Calculate row index
      final rowIndex = (contentY / rowHeight).floor();

      // Boundary check
      if (rowIndex < 0 || rowIndex >= widget.rows.length) {
        _debugLog(
          'Row index out of bounds: $rowIndex (max: ${widget.rows.length - 1})',
        );
        return null;
      }

      _debugLog(
        'Calculated row index: $rowIndex (y=$contentY, rowHeight=$rowHeight)',
      );
      return rowIndex;
    } catch (e, stackTrace) {
      _debugLog('Error calculating row index: $e');
      if (widget.enableDebugLogs) {
        debugPrint('Stack trace: $stackTrace');
      }
      return null;
    }
  }

  /// Outputs debug logs
  void _debugLog(String message) {
    if (widget.enableDebugLogs) {
      debugPrint('[${widget.debugPrefix}] $message');
    }
  }
}
