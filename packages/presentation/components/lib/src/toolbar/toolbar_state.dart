import 'package:flutter/widgets.dart';

/// Data structure for a toolbar item.
class ToolbarItemData {
  const ToolbarItemData({required this.id, required this.icon, this.tooltip});

  final String id;
  final Widget icon;
  final String? tooltip;
}

/// Model representing the state of the toolbar.
class ToolbarState {
  const ToolbarState({this.selectedTool, this.enabledTools = const {}});

  final String? selectedTool;
  final Set<String> enabledTools;

  ToolbarState copyWith({
    String? Function()? selectedTool,
    Set<String> Function()? enabledTools,
  }) {
    return ToolbarState(
      selectedTool: selectedTool != null ? selectedTool() : this.selectedTool,
      enabledTools: enabledTools != null ? enabledTools() : this.enabledTools,
    );
  }
}
