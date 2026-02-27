/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:core_themes/core_themes.dart';
import '../typography/app_text_style_builder.dart';
import '../typography/app_text.dart';
import 'app_pluto_grid_wrapper.dart';

/// App-specific table view component
///
/// Wrapper based on `pluto_grid` package with App-specific requirements added
/// Includes column reordering and resizing functionality
class AppTableView<T> extends StatefulWidget {
  /// Table data
  final List<T> data;

  /// Table column definitions
  final List<AppTableColumn<T>> columns;

  /// Function to get primary key of data
  final String Function(T) keyExtractor;

  /// Callback when row is selected
  final void Function(List<T>)? onRowsSelected;

  /// Callback when row is double-tapped
  final void Function(T)? onRowDoubleTap;

  /// Whether to allow multiple selection
  final bool allowMultiSelect;

  /// Whether to allow column reordering
  final bool allowColumnReordering;

  /// Whether to allow column resizing
  final bool allowColumnResizing;

  /// Callback when column order is changed
  final void Function(int oldIndex, int newIndex)? onColumnReorder;

  /// Callback when column width is changed
  final void Function(int index, double newWidth)? onColumnResize;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  const AppTableView({
    super.key,
    required this.data,
    required this.columns,
    required this.keyExtractor,
    this.onRowsSelected,
    this.onRowDoubleTap,
    this.allowMultiSelect = false, // Changed default to single selection
    this.allowColumnReordering = true, // Enable column reordering
    this.allowColumnResizing = true, // Enable column resizing
    this.onColumnReorder,
    this.onColumnResize,
    this.disableZoom = false,
  });

  /// Constructor to create from existing TableColumn list
  AppTableView.fromTableColumns({
    super.key,
    required this.data,
    required List<dynamic> tableColumns,
    required this.keyExtractor,
    this.onRowsSelected,
    this.onRowDoubleTap,
    this.allowMultiSelect = false, // Changed default to single selection
    this.allowColumnReordering = true, // Enable column reordering
    this.allowColumnResizing = true, // Enable column resizing
    this.onColumnReorder,
    this.onColumnResize,
    this.disableZoom = false,
  }) : columns =
           tableColumns
               .map((col) => AppTableColumn.fromTableColumn<T>(col))
               .toList();

  @override
  State<AppTableView<T>> createState() => _AppTableViewState<T>();
}

class _AppTableViewState<T> extends State<AppTableView<T>> {
  List<T> _selectedRows = [];
  PlutoGridStateManager? _stateManager;
  late List<PlutoColumn> _plutoColumns;
  late List<PlutoRow> _plutoRows;

  @override
  void initState() {
    super.initState();
    _buildPlutoData();
  }

  @override
  void didUpdateWidget(AppTableView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns || widget.data != oldWidget.data) {
      _buildPlutoData();
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Build data for use in PlutoGrid
  void _buildPlutoData() {
    // Build PlutoColumn
    _plutoColumns =
        widget.columns.map((appColumn) {
          return PlutoColumn(
            title: appColumn.title,
            field: appColumn.id,
            type: PlutoColumnType.text(),
            width: appColumn.width,
            minWidth: appColumn.minWidth ?? 50.0,
            enableColumnDrag: widget.allowColumnReordering,
            enableSorting: appColumn.sortable,
            enableContextMenu: false,
            enableDropToResize: widget.allowColumnResizing,
            renderer: (rendererContext) {
              final rowIndex = rendererContext.rowIdx;
              if (rowIndex < widget.data.length) {
                final item = widget.data[rowIndex];
                final isSelected = _selectedRows.any(
                  (selectedItem) =>
                      widget.keyExtractor(selectedItem) ==
                      widget.keyExtractor(item),
                );

                // Build cell content
                final cellContent = appColumn.cellBuilder(item, isSelected);

                // Use PlutoGrid's standard row selection mechanism
                // Don't use AppGestureDetector as it conflicts with row selection
                return cellContent;
              }
              return const SizedBox.shrink();
            },
          );
        }).toList();

    // Build PlutoRow
    _plutoRows =
        widget.data.asMap().entries.map((entry) {
          final item = entry.value;
          final key = widget.keyExtractor(item);

          final cells = <String, PlutoCell>{};
          for (final column in widget.columns) {
            cells[column.id] = PlutoCell(
              value: key,
            ); // Actual value displayed in renderer
          }

          return PlutoRow(key: ValueKey(key), cells: cells);
        }).toList();

    debugPrint(
      '[AppTableView] Built Pluto data: ${_plutoRows.length} rows, ${_plutoColumns.length} columns',
    );
  }

  void _onSelectionChanged(List<T> items) {
    debugPrint(
      '[AppTableView] _onSelectionChanged called with ${items.length} items',
    );
    debugPrint(
      '[AppTableView] Selection changed: ${items.map((item) => widget.keyExtractor(item)).join(', ')}',
    );
    debugPrint(
      '[AppTableView] onRowsSelected callback: ${widget.onRowsSelected != null ? 'exists' : 'null'}',
    );

    setState(() {
      _selectedRows = items;
    });

    if (widget.onRowsSelected != null) {
      debugPrint('[AppTableView] Calling onRowsSelected callback');
      widget.onRowsSelected!(items);
    } else {
      debugPrint('[AppTableView] onRowsSelected callback is null, not calling');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[AppTableView] Building AppTableView');
    return Consumer(
      builder: (context, ref, child) {
        // Get App color scheme and accessibility config via core_themes
        final appColorScheme = ref.watch(effectiveColorSchemeProvider);
        final accessibilityConfig = ref.watch(accessibilityConfigProvider);
        final zoomScale =
            widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
        final borderScale =
            widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

        return Container(
          decoration: BoxDecoration(
            color: appColorScheme.appSpecific.table.background,
            border: Border.all(
              color: appColorScheme.appSpecific.table.border,
              width: 1.0 * borderScale,
            ),
          ),
          child: AppPlutoGridWrapper(
            columns: _plutoColumns,
            rows: _plutoRows,
            mode:
                widget.allowMultiSelect
                    ? PlutoGridMode.multiSelect
                    : PlutoGridMode.select,
            configuration: _buildPlutoGridConfiguration(
              context,
              ref,
              appColorScheme,
              zoomScale,
            ),
            onLoaded: _handlePlutoGridLoaded,
            onChanged: _handlePlutoGridChanged,
            onRowTapped: _handleRowTapped,
            onRowDoubleTapped: _handleRowDoubleTapped,
            enableDebugLogs: true,
            debugPrefix: 'AppTableView',
          ),
        );
      },
    );
  }

  /// Build PlutoGrid configuration
  PlutoGridConfiguration _buildPlutoGridConfiguration(
    BuildContext context,
    WidgetRef ref,
    AppColorScheme appColorScheme,
    double zoomScale,
  ) {
    return PlutoGridConfiguration(
      columnSize: PlutoGridColumnSizeConfig(
        autoSizeMode:
            PlutoAutoSizeMode.scale, // Expand columns to fill parent view
        resizeMode:
            widget.allowColumnResizing
                ? PlutoResizeMode
                    .pushAndPull // Adjust other columns when resizing
                : PlutoResizeMode.none,
      ),
      enterKeyAction: PlutoGridEnterKeyAction.none,
      enableMoveDownAfterSelecting: false,
      enableMoveHorizontalInEditing: false,
      style: PlutoGridStyleConfig(
        enableColumnBorderVertical: false,
        enableColumnBorderHorizontal: true,
        enableCellBorderVertical: false,
        enableCellBorderHorizontal: true,
        enableRowColorAnimation: false,
        oddRowColor: appColorScheme.appSpecific.table.oddRowBackground,
        evenRowColor: appColorScheme.appSpecific.table.evenRowBackground,
        gridBackgroundColor: appColorScheme.appSpecific.table.background,
        rowColor: appColorScheme.appSpecific.table.oddRowBackground,
        activatedColor: appColorScheme.appSpecific.table.selectedRowBackground,
        checkedColor: appColorScheme.appSpecific.table.activeRowBackground,
        borderColor: appColorScheme.appSpecific.table.border,
        gridBorderColor: appColorScheme.appSpecific.table.border,
        activatedBorderColor: appColorScheme.appSpecific.table.activeBorder,
        inactivatedBorderColor: appColorScheme.appSpecific.table.border,
        columnTextStyle: _buildHeaderTextStyle(context, ref, appColorScheme),
        cellTextStyle: _buildCellTextStyle(context, ref, appColorScheme),
      ),
      scrollbar: PlutoGridScrollbarConfig(
        isAlwaysShown: true,
        scrollbarThickness: 8.0 * zoomScale,
        scrollbarThicknessWhileDragging: 10.0 * zoomScale,
      ),
    );
  }

  /// Handle PlutoGrid load completion
  void _handlePlutoGridLoaded(PlutoGridOnLoadedEvent event) {
    _stateManager = event.stateManager;
    debugPrint('[AppTableView] PlutoGrid loaded');

    if (_stateManager != null) {
      // Disable column filter
      _stateManager!.setConfiguration(
        _stateManager!.configuration.copyWith(
          columnFilter: PlutoGridColumnFilterConfig(filters: const []),
        ),
      );

      // Set selection mode
      _stateManager!.setSelectingMode(PlutoGridSelectingMode.row);

      debugPrint('[AppTableView] Configuration applied');
    }
  }

  /// Handle PlutoGrid data change
  void _handlePlutoGridChanged(PlutoGridOnChangedEvent event) {
    debugPrint('[AppTableView] Data changed');
  }

  /// Handle row tap (called from AppPlutoGridWrapper)
  void _handleRowTapped(int rowIndex, Offset tapPosition) {
    debugPrint('[AppTableView] Row $rowIndex tapped at $tapPosition');

    if (rowIndex >= 0 && rowIndex < widget.data.length) {
      final item = widget.data[rowIndex];
      _handleRowSelection(rowIndex, item);
    }
  }

  /// Handle row double tap (called from AppPlutoGridWrapper)
  void _handleRowDoubleTapped(int rowIndex, Offset tapPosition) {
    debugPrint('[AppTableView] Row $rowIndex double tapped at $tapPosition');

    if (rowIndex >= 0 && rowIndex < widget.data.length) {
      final item = widget.data[rowIndex];
      if (widget.onRowDoubleTap != null) {
        widget.onRowDoubleTap!(item);
      }
    }
  }

  /// Build header text style
  TextStyle _buildHeaderTextStyle(
    BuildContext context,
    WidgetRef ref,
    AppColorScheme appColorScheme,
  ) {
    return AppTextStyleBuilder.buildTextStyleWithColor(
      variant: AppTextVariant.tableHeader,
      context: context,
      ref: ref,
      color: appColorScheme.appSpecific.table.headerText,
      fontWeight: FontWeight.w500,
      disableZoom: widget.disableZoom,
    );
  }

  /// Build cell text style
  /// Conforms to AppTextVariant.tableCell and applies table-specific color
  TextStyle _buildCellTextStyle(
    BuildContext context,
    WidgetRef ref,
    AppColorScheme appColorScheme,
  ) {
    return AppTextStyleBuilder.buildTextStyleWithColor(
      variant: AppTextVariant.tableCell,
      context: context,
      ref: ref,
      color: appColorScheme.appSpecific.table.cellText,
      fontWeight: FontWeight.w400, // Cell uses Regular weight
      disableZoom: widget.disableZoom,
    );
  }

  /// Execute row selection handling
  void _handleRowSelection(int rowIndex, T item) {
    debugPrint('[AppTableView] Handling row selection: $rowIndex');

    if (_stateManager == null || rowIndex >= _plutoRows.length) {
      debugPrint('[AppTableView] Invalid state or row index');
      return;
    }

    final targetRow = _plutoRows[rowIndex];

    if (widget.allowMultiSelect) {
      // Multi-select: toggle current selection state
      if (_stateManager!.checkedRows.contains(targetRow)) {
        _stateManager!.setRowChecked(targetRow, false);
      } else {
        _stateManager!.setRowChecked(targetRow, true);
      }

      // Get all selected rows
      final selectedRows =
          _stateManager!.checkedRows
              .map((row) => _plutoRows.indexOf(row))
              .where((index) => index >= 0 && index < widget.data.length)
              .map((index) => widget.data[index])
              .toList();

      debugPrint('[AppTableView] Multi-select: ${selectedRows.length} items');
      _onSelectionChanged(selectedRows);
    } else {
      // Single-select: clear existing selection then select new row
      debugPrint('[AppTableView] Single-select mode');

      // Clear all existing checkedRows
      final existingCheckedRows = _stateManager!.checkedRows.toList();
      for (final row in existingCheckedRows) {
        _stateManager!.setRowChecked(row, false);
      }

      // Set currentSelectingPosition (for visual selection display)
      final cellPosition = PlutoGridCellPosition(
        columnIdx: 0,
        rowIdx: rowIndex,
      );
      _stateManager!.setCurrentSelectingPosition(cellPosition: cellPosition);

      debugPrint('[AppTableView] Single-select: 1 item');
      _onSelectionChanged([item]);
    }

    // Trigger PlutoGrid redraw
    _stateManager!.notifyListeners();
  }
}

/// App-specific table column definition
/// Column definition class for use with pluto_grid
class AppTableColumn<T> {
  /// Column ID
  final String id;

  /// Column title
  final String title;

  /// Column width
  final double width;

  /// Minimum width
  final double? minWidth;

  /// Maximum width
  final double? maxWidth;

  /// Function to build cell content
  final Widget Function(T item, bool isSelected) cellBuilder;

  /// Whether sortable
  final bool sortable;

  /// Whether resizable
  final bool resizable;

  /// Whether frozen column
  final bool frozen;

  const AppTableColumn({
    required this.id,
    required this.title,
    required this.width,
    required this.cellBuilder,
    this.minWidth,
    this.maxWidth,
    this.sortable = false,
    this.resizable = true,
    this.frozen = false,
  });

  /// Create a copy
  AppTableColumn<T> copyWith({
    String? id,
    String? title,
    double? width,
    double? minWidth,
    double? maxWidth,
    Widget Function(T item, bool isSelected)? cellBuilder,
    bool? sortable,
    bool? resizable,
    bool? frozen,
  }) {
    return AppTableColumn<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      sortable: sortable ?? this.sortable,
      resizable: resizable ?? this.resizable,
      frozen: frozen ?? this.frozen,
    );
  }

  /// Convert from existing TableColumn to AppTableColumn
  static AppTableColumn<T> fromTableColumn<T>(dynamic tableColumn) {
    return AppTableColumn<T>(
      id: tableColumn.id,
      title: tableColumn.title,
      width: tableColumn.width,
      cellBuilder: tableColumn.cellBuilder,
      sortable: tableColumn.sortable ?? false,
      resizable: tableColumn.resizable ?? true,
    );
  }
}
