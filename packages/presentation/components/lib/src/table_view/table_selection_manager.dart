/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/foundation.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// Class managing table selection state
///
/// This class provides the following features:
/// - Management of single and multiple selections
/// - Integration with PlutoGrid's selection API
/// - Notification of selection state changes
///
/// Example usage:
/// ```dart
/// final manager = TableSelectionManager<MyData>(
///   allowMultiSelect: false,
///   data: myDataList,
///   plutoStateManager: stateManager,
///   plutoRows: plutoRows,
/// );
///
/// manager.addListener(() {
///   print('Selection changed: ${manager.selectedItems}');
/// });
///
/// manager.selectRow(0);
/// ```
class TableSelectionManager<T> extends ChangeNotifier {
  /// Whether to allow multiple selections
  final bool allowMultiSelect;

  /// Table data
  final List<T> data;

  /// PlutoGrid state management object
  final PlutoGridStateManager plutoStateManager;

  /// PlutoGrid row data
  final List<PlutoRow> plutoRows;

  /// Whether to enable debug logs
  final bool enableDebugLogs;

  /// Prefix for debug logs
  final String debugPrefix;

  // Internal state
  final List<T> _selectedItems = [];
  final Set<int> _selectedIndices = {};
  List<T>? _selectedItemsCache;

  TableSelectionManager({
    required this.allowMultiSelect,
    required this.data,
    required this.plutoStateManager,
    required this.plutoRows,
    this.enableDebugLogs = false,
    this.debugPrefix = 'TableSelectionManager',
  });

  /// List of currently selected items (read-only)
  List<T> get selectedItems {
    _selectedItemsCache ??= List.unmodifiable(_selectedItems);
    return _selectedItemsCache!;
  }

  /// Set of currently selected indices (read-only)
  Set<int> get selectedIndices => Set.unmodifiable(_selectedIndices);

  /// Number of selected items
  int get selectedCount => _selectedItems.length;

  /// Whether anything is selected
  bool get hasSelection => _selectedItems.isNotEmpty;

  /// Whether the specified index is selected
  bool isSelected(int index) {
    return _selectedIndices.contains(index);
  }

  /// Whether the specified item is selected
  bool isItemSelected(T item) {
    return _selectedItems.contains(item);
  }

  /// Selects a row
  ///
  /// [index]: Index of the row to select
  /// [notify]: Whether to send change notifications (default: true)
  void selectRow(int index, {bool notify = true}) {
    if (!_isValidIndex(index)) {
      _debugLog('Invalid index for selection: $index');
      return;
    }

    _debugLog('Selecting row: $index');

    if (!allowMultiSelect) {
      // For single selection: clear existing selection
      _clearSelectionInternal(notify: false);
    }

    // Select new row
    // Update PlutoGrid selection state
    _updatePlutoGridSelection();

    if (notify) {
      _invalidateCache();
      notifyListeners();
    }
  }

  /// Toggles the selection state of a row
  ///
  /// [notify]: Whether to send change notifications (default: true)
  void toggleRow(int index, {bool notify = true}) {
    if (!_isValidIndex(index)) {
      _debugLog('Invalid index for toggle: $index');
      return;
    }

    if (isSelected(index)) {
      _removeSelectionInternal(index, notify: false);
    } else {
      if (!allowMultiSelect) {
        // For single selection: clear existing selection
        _clearSelectionInternal(notify: false);
      }
      _addSelectionInternal(index, notify: false);
    }

    // Update PlutoGrid selection state
    _updatePlutoGridSelection();

    if (notify) {
      _invalidateCache();
      notifyListeners();
    }
  }

  /// [notify]: Whether to send change notifications (default: true)
  void clearSelection({bool notify = true}) {
    if (_selectedItems.isEmpty) {
      return; // Already cleared
    }

    _debugLog('Clearing all selections');
    _clearSelectionInternal(notify: false);
    _updatePlutoGridSelection();

    if (notify) {
      _invalidateCache();
      notifyListeners();
    }
  }

  /// Selects all rows (multi-selection mode only)
  ///
  /// [notify]: Whether to send change notifications (default: true)
  void selectAll({bool notify = true}) {
    if (!allowMultiSelect) {
      _debugLog('selectAll called but multi-select is disabled');
      return;
    }

    _debugLog('Selecting all rows');
    _clearSelectionInternal(notify: false);

    for (int i = 0; i < data.length; i++) {
      _addSelectionInternal(i, notify: false);
    }

    _updatePlutoGridSelection();

    if (notify) {
      _invalidateCache();
      notifyListeners();
    }
  }

  /// Internally adds a selection
  void _addSelectionInternal(int index, {bool notify = true}) {
    if (_selectedIndices.add(index)) {
      _selectedItems.add(data[index]);
      _debugLog('Added selection: $index');
    }
  }

  /// Internally removes a selection
  void _removeSelectionInternal(int index, {bool notify = true}) {
    if (_selectedIndices.remove(index)) {
      _selectedItems.remove(data[index]);
      _debugLog('Removed selection: $index');
    }
  }

  /// Internally clears all selections
  void _clearSelectionInternal({bool notify = true}) {
    _selectedItems.clear();
    _selectedIndices.clear();
  }

  // Update PlutoGrid selection state
  void _updatePlutoGridSelection() {
    try {
      if (allowMultiSelect) {
        // For multiple selection: update checkedRows
        _updateCheckedRows();
      } else {
        // For single selection: update currentSelectingPosition
        _updateCurrentSelectingPosition();
      }

      // Prompt PlutoGrid to redraw
      plutoStateManager.notifyListeners();
    } catch (e, stackTrace) {
      _debugLog('Error updating PlutoGrid selection: $e');
      if (enableDebugLogs) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  /// Updates checkedRows (for multi-selection)
  void _updateCheckedRows() {
    // Clear existing checked state
    final existingCheckedRows = plutoStateManager.checkedRows.toList();
    for (final row in existingCheckedRows) {
      plutoStateManager.setRowChecked(row, false);
    }

    // Set new selection state
    for (final index in _selectedIndices) {
      if (index < plutoRows.length) {
        plutoStateManager.setRowChecked(plutoRows[index], true);
      }
    }
  }

  /// Updates currentSelectingPosition (for single selection)
  void _updateCurrentSelectingPosition() {
    if (_selectedIndices.isNotEmpty) {
      final index = _selectedIndices.first;
      final cellPosition = PlutoGridCellPosition(columnIdx: 0, rowIdx: index);
      plutoStateManager.setCurrentSelectingPosition(cellPosition: cellPosition);
    } else {
      plutoStateManager.setCurrentSelectingPosition(cellPosition: null);
    }
  }

  /// Checks if index is valid
  bool _isValidIndex(int index) {
    return index >= 0 && index < data.length && index < plutoRows.length;
  }

  /// Invalidates the cache
  void _invalidateCache() {
    _selectedItemsCache = null;
  }

  /// Outputs debug logs
  void _debugLog(String message) {
    if (enableDebugLogs) {
      debugPrint('[$debugPrefix] $message');
    }
  }

  @override
  void dispose() {
    _selectedItems.clear();
    _selectedIndices.clear();
    _selectedItemsCache = null;
    super.dispose();
  }
}
