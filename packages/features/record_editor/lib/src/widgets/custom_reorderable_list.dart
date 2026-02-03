import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// InheritedWidget to communicate drag state to child widgets
class _DragStateWidget extends InheritedWidget {
  final bool isDragging;

  const _DragStateWidget({required this.isDragging, required super.child});

  @override
  bool updateShouldNotify(_DragStateWidget oldWidget) {
    return isDragging != oldWidget.isDragging;
  }
}

/// ReorderableListView with animation disabled for swapping properties during drag
/// Only the dragged property moves, other properties do not move
class CustomReorderableList extends StatefulWidget {
  /// Constructor
  const CustomReorderableList({
    super.key,
    required this.children,
    required this.onReorder,
    this.proxyDecorator,
    this.onReorderStart,
    this.onReorderEnd,
    this.buildDefaultDragHandles = true,
    this.dragStartBehavior = DragStartBehavior.down,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.getPropertyName,
  });

  /// InheritedWidget to determine if dragging
  static bool isDragging(BuildContext context) {
    final _DragStateWidget? dragState =
        context.dependOnInheritedWidgetOfExactType<_DragStateWidget>();
    return dragState?.isDragging ?? false;
  }

  /// List of child widgets
  final List<Widget> children;

  /// Callback when reordering
  final void Function(int oldIndex, int newIndex) onReorder;

  /// Decoration of item during drag
  final Widget Function(Widget child, int index, Animation<double> animation)?
  proxyDecorator;

  /// Callback when drag starts
  final void Function(int index)? onReorderStart;

  /// Callback when drag ends
  final void Function(int index)? onReorderEnd;

  /// Whether to build default drag handles
  final bool buildDefaultDragHandles;

  /// Drag start behavior
  final DragStartBehavior dragStartBehavior;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Whether to shrink list to child height
  final bool shrinkWrap;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Callback to get property name
  final String Function(Widget child)? getPropertyName;

  @override
  State<CustomReorderableList> createState() => _CustomReorderableListState();
}

class _CustomReorderableListState extends State<CustomReorderableList>
    with TickerProviderStateMixin {
  // Index of dragging item
  int? _dragIndex;

  // Insert position after drag
  int? _insertIndex;

  // Current mouse position
  Offset? _currentMousePosition;

  // Animation for dragged widget
  late AnimationController _dragController;
  late Animation<double> _dragAnimation;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _dragAnimation = CurvedAnimation(
      parent: _dragController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  // Method to update mouse position
  void _updateMousePosition(PointerMoveEvent event) {
    if (_dragIndex != null) {
      setState(() {
        _currentMousePosition = event.position;
      });
    }
  }

  // Removed unnecessary methods

  // Method to build divider
  Widget _buildDivider({
    required String key,
    required double position,
    int? index,
  }) {
    // Show divider if dragging and mouse position is near divider
    bool showDivider = false;

    // If mouse position exists, show divider if distance is within threshold
    if (_currentMousePosition != null && _insertIndex != null) {
      // Show only divider at insert position
      if ((index == null && _insertIndex == 0) || // First divider
          (index != null && index + 1 == _insertIndex)) {
        // Divider after item
        final double distance = (_currentMousePosition!.dy - position).abs();
        showDivider =
            distance < 50; // Show divider within 50 pixels (expanded range)
      }
      // If mouse position exists, show divider if distance is within threshold
      else if (_currentMousePosition != null) {
        final double distance = (_currentMousePosition!.dy - position).abs();
        showDivider =
            distance < 50; // Show divider within 50 pixels (expanded range)
      }
    }

    return Container(
      key: ValueKey(key),
      height: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color:
          showDivider
              ? Theme.of(context).colorScheme.primary
              : Colors
                  .transparent, // Always reserve space with transparent color
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add drag handles to each item
    final List<Widget> items = [];

    // Removed unnecessary variables

    // List to hold boundary positions of each item
    final List<double> itemBoundaries = [];

    // Add top edge of first item
    final RenderObject? firstRenderObject = _findRenderObject(0);
    if (firstRenderObject != null) {
      final RenderBox firstBox = firstRenderObject as RenderBox;
      final Offset firstPosition = firstBox.localToGlobal(Offset.zero);
      itemBoundaries.add(firstPosition.dy);
    }

    // Add bottom edge of each item
    for (int i = 0; i < widget.children.length; i++) {
      final RenderObject? renderObject = _findRenderObject(i);
      if (renderObject == null) continue;

      final RenderBox childBox = renderObject as RenderBox;
      final Offset childPosition = childBox.localToGlobal(Offset.zero);
      final Size childSize = childBox.size;

      itemBoundaries.add(childPosition.dy + childSize.height);
    }

    // Add first divider (before first item)
    if (itemBoundaries.isNotEmpty) {
      items.add(
        _buildDivider(
          key: 'divider_first',
          position: itemBoundaries[0],
          // Do not pass index for first divider
        ),
      );
    }

    // Add each item and divider after it
    for (int index = 0; index < widget.children.length; index++) {
      final child = widget.children[index];

      // Add item (including dragged item)
      items.add(child);

      // Add divider after item (also after last item)
      if (index < itemBoundaries.length - 1) {
        items.add(
          _buildDivider(
            key: 'divider_after_$index',
            position: itemBoundaries[index + 1],
            index: index, // Pass index
          ),
        );
      }
    }

    // If not dragging, wrap each item with Draggable and add
    if (_dragIndex == null) {
      items.clear(); // Clear existing items

      for (int index = 0; index < widget.children.length; index++) {
        final child = widget.children[index];

        // Add DragTarget before first item
        if (index == 0) {
          items.add(
            DragTarget<int>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  key: ValueKey('divider_first'),
                  height: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color:
                      candidateData.isNotEmpty
                          ? Theme.of(context).colorScheme.primary
                          : Colors
                              .transparent, // Always reserve space with transparent color
                );
              },
              onWillAcceptWithDetails: (details) {
                final data = details.data;
                return data != 0;
              },
              onAcceptWithDetails: (details) {
                final draggedIndex = details.data;
                // Move dragged item to first position
                debugPrint('Reordering from $draggedIndex to 0');
                widget.onReorder(draggedIndex, 0);
              },
            ),
          );
        }

        // Add normal item
        items.add(
          Listener(
            onPointerMove: _dragIndex != null ? _updateMousePosition : null,
            child: Draggable<int>(
              onDragCompleted: () {
                debugPrint('onDragCompleted');
              },
              onDraggableCanceled: (velocity, offset) {
                debugPrint('onDraggableCanceled');
                // If drag is canceled, perform same processing as onDragEnd
                final int oldIndex = _dragIndex ?? 0;

                // If insert position is not set, calculate from mouse position
                int newIndex = _insertIndex ?? oldIndex;

                if (_currentMousePosition != null && _dragIndex != null) {
                  // Find item closest to mouse position
                  double minDistance = double.infinity;
                  int closestIndex = oldIndex;

                  for (int i = 0; i < widget.children.length; i++) {
                    if (i == _dragIndex) continue;

                    final RenderObject? renderObject = _findRenderObject(i);
                    if (renderObject == null) continue;

                    final RenderBox childBox = renderObject as RenderBox;
                    final Offset childPosition = childBox.localToGlobal(
                      Offset.zero,
                    );
                    final Size childSize = childBox.size;

                    // Center position of item
                    final double centerY =
                        childPosition.dy + childSize.height / 2;
                    final double distance =
                        (_currentMousePosition!.dy - centerY).abs();

                    if (distance < minDistance) {
                      minDistance = distance;
                      closestIndex = i;
                    }
                  }

                  // Determine if mouse position is in upper or lower half of item
                  final RenderObject? renderObject = _findRenderObject(
                    closestIndex,
                  );
                  if (renderObject != null) {
                    final RenderBox childBox = renderObject as RenderBox;
                    final Offset childPosition = childBox.localToGlobal(
                      Offset.zero,
                    );
                    final Size childSize = childBox.size;

                    final bool isInUpperHalf =
                        _currentMousePosition!.dy <
                        (childPosition.dy + childSize.height / 2);

                    if (_dragIndex! < closestIndex) {
                      // If item is below dragged item
                      newIndex =
                          isInUpperHalf ? closestIndex : closestIndex + 1;
                    } else {
                      // If item is above dragged item
                      newIndex =
                          isInUpperHalf ? closestIndex : closestIndex + 1;
                    }
                  }
                }

                // Adjust index to be within range
                newIndex = newIndex.clamp(0, widget.children.length - 1);

                // Reorder only if position changed
                if (oldIndex != newIndex) {
                  // Use destination index as-is for both down and up moves

                  // Call onReorder callback
                  debugPrint('Reordering from $oldIndex to $newIndex');
                  widget.onReorder(oldIndex, newIndex);
                }

                _dragController.reverse().then((_) {
                  setState(() {
                    _dragIndex = null;
                    _insertIndex = null;
                    _currentMousePosition = null;
                  });
                });

                if (widget.onReorderEnd != null) {
                  widget.onReorderEnd!(oldIndex);
                }
              },
              key: child.key,
              data: index,
              dragAnchorStrategy: (draggable, context, position) {
                return const Offset(0, 0);
              },
              feedback: Builder(
                builder: (context) {
                  // Widget displayed during drag (follows mouse)
                  // Display only property name with app-specific theme
                  final theme = Theme.of(context);
                  final colorScheme = theme.colorScheme;

                  // Get property name
                  String propertyName = "Property";

                  // Use getPropertyName callback if specified
                  if (widget.getPropertyName != null) {
                    propertyName = widget.getPropertyName!(child);
                  }
                  // If no callback, try to extract property name from child's Key
                  else if (child.key is ValueKey) {
                    final keyValue = (child.key as ValueKey).value;
                    if (keyValue is String) {
                      propertyName = keyValue;
                    }
                  }

                  Widget feedbackWidget = Material(
                    elevation: 4.0,
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.primary.withValues(
                            alpha: 128,
                          ), // Equivalent to 0.5
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.drag_indicator,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            propertyName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  // Apply proxyDecorator if specified
                  if (widget.proxyDecorator != null) {
                    feedbackWidget = widget.proxyDecorator!(
                      feedbackWidget,
                      index,
                      _dragAnimation,
                    );
                  }

                  return feedbackWidget;
                },
              ),
              // Widget displayed at original position during drag
              // Transparent but maintains original size and appearance
              childWhenDragging: Opacity(
                opacity: 0.3, // Semi-transparent (indicates dragging)
                child: child,
              ),
              onDragStarted: () {
                debugPrint('onDragStarted: $index');
                setState(() {
                  _dragIndex = index;
                  _insertIndex = index;
                  _currentMousePosition = null; // Initialize
                });

                _dragController.forward(from: 0.0);

                if (widget.onReorderStart != null) {
                  widget.onReorderStart!(index);
                }
              },
              onDragUpdate: (details) {
                debugPrint('onDragUpdate: ${details.globalPosition}');
                // Update mouse position
                _updateMousePosition(
                  PointerMoveEvent(position: details.globalPosition),
                );

                // Calculate insert position
                int? newInsertIndex;

                for (int i = 0; i < widget.children.length; i++) {
                  if (i == _dragIndex) continue;

                  // Get position of each item
                  final RenderObject? renderObject = _findRenderObject(i);
                  if (renderObject == null) continue;

                  final RenderBox childBox = renderObject as RenderBox;
                  final Offset childPosition = childBox.localToGlobal(
                    Offset.zero,
                  );
                  final Size childSize = childBox.size;

                  final Rect childRect = Rect.fromLTWH(
                    childPosition.dx,
                    childPosition.dy,
                    childSize.width,
                    childSize.height,
                  );

                  // Determine if pointer is in upper or lower half of item
                  if (childRect.contains(details.globalPosition)) {
                    // Check if pointer position is in upper half of item
                    final bool isInUpperHalf =
                        details.globalPosition.dy <
                        (childPosition.dy + childSize.height / 2);

                    // If item is above dragged item
                    if (i < _dragIndex!) {
                      // If in upper half, insert before item
                      newInsertIndex = isInUpperHalf ? i : i + 1;
                    }
                    // If item is below dragged item
                    else {
                      // If in upper half, insert before item
                      // If in lower half, insert after item
                      newInsertIndex = isInUpperHalf ? i : i + 1;
                    }
                    break;
                  }
                }

                // Handle moving to beginning or end of list
                final RenderObject? firstRenderObject = _findRenderObject(0);
                final RenderObject? lastRenderObject = _findRenderObject(
                  widget.children.length - 1,
                );

                if (firstRenderObject != null) {
                  final RenderBox firstBox = firstRenderObject as RenderBox;
                  final Offset firstPosition = firstBox.localToGlobal(
                    Offset.zero,
                  );

                  // If dragged above beginning of list
                  if (details.globalPosition.dy < firstPosition.dy &&
                      _dragIndex != 0) {
                    newInsertIndex = 0;
                  }
                }

                if (lastRenderObject != null &&
                    _dragIndex != widget.children.length - 1) {
                  final RenderBox lastBox = lastRenderObject as RenderBox;
                  final Offset lastPosition = lastBox.localToGlobal(
                    Offset.zero,
                  );
                  final Size lastSize = lastBox.size;

                  // If dragged below end of list
                  if (details.globalPosition.dy >
                      lastPosition.dy + lastSize.height) {
                    newInsertIndex = widget.children.length;
                  }
                }

                // Update only if insert position changed
                if (newInsertIndex != null && newInsertIndex != _insertIndex) {
                  setState(() {
                    _insertIndex = newInsertIndex;
                  });
                }
              },
              onDragEnd: (details) {
                debugPrint('onDragEnd: ${details.offset}');
                // Processing when drag ends
                final int oldIndex = _dragIndex ?? 0;

                // If insert position is not set, calculate from mouse position
                int newIndex = _insertIndex ?? oldIndex;

                if (_currentMousePosition != null && _dragIndex != null) {
                  // Find item closest to mouse position
                  double minDistance = double.infinity;
                  int closestIndex = oldIndex;

                  for (int i = 0; i < widget.children.length; i++) {
                    if (i == _dragIndex) continue;

                    final RenderObject? renderObject = _findRenderObject(i);
                    if (renderObject == null) continue;

                    final RenderBox childBox = renderObject as RenderBox;
                    final Offset childPosition = childBox.localToGlobal(
                      Offset.zero,
                    );
                    final Size childSize = childBox.size;

                    // Center position of item
                    final double centerY =
                        childPosition.dy + childSize.height / 2;
                    final double distance =
                        (_currentMousePosition!.dy - centerY).abs();

                    if (distance < minDistance) {
                      minDistance = distance;
                      closestIndex = i;
                    }
                  }

                  // Determine if mouse position is in upper or lower half of item
                  final RenderObject? renderObject = _findRenderObject(
                    closestIndex,
                  );
                  if (renderObject != null) {
                    final RenderBox childBox = renderObject as RenderBox;
                    final Offset childPosition = childBox.localToGlobal(
                      Offset.zero,
                    );
                    final Size childSize = childBox.size;

                    final bool isInUpperHalf =
                        _currentMousePosition!.dy <
                        (childPosition.dy + childSize.height / 2);

                    if (_dragIndex! < closestIndex) {
                      // If item is below dragged item
                      newIndex =
                          isInUpperHalf ? closestIndex : closestIndex + 1;
                    } else {
                      // If item is above dragged item
                      newIndex =
                          isInUpperHalf ? closestIndex : closestIndex + 1;
                    }
                  }
                }

                // Adjust index to be within range
                newIndex = newIndex.clamp(0, widget.children.length - 1);

                // Reorder only if position changed
                if (oldIndex != newIndex) {
                  // Use destination index as-is for both down and up moves

                  // Call onReorder callback
                  debugPrint('Reordering from $oldIndex to $newIndex');
                  widget.onReorder(oldIndex, newIndex);
                }

                _dragController.reverse().then((_) {
                  setState(() {
                    _dragIndex = null;
                    _insertIndex = null;
                    _currentMousePosition = null;
                  });
                });

                if (widget.onReorderEnd != null) {
                  widget.onReorderEnd!(oldIndex);
                }
              },
              child: child,
            ),
          ),
        );

        // Add DragTarget after item
        items.add(
          DragTarget<int>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                key: ValueKey('divider_after_$index'),
                height: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color:
                    candidateData.isNotEmpty
                        ? Theme.of(context).colorScheme.primary
                        : Colors
                            .transparent, // Always reserve space with transparent color
              );
            },
            onWillAcceptWithDetails: (details) {
              final data = details.data;
              return data != index && data != index + 1;
            },
            onAcceptWithDetails: (details) {
              final draggedIndex = details.data;
              // Move dragged item after this position
              int newIndex = index + 1;

              // Use destination index as-is for both down and up moves
              // Use destination index as-is for both down and up moves

              debugPrint('Reordering from $draggedIndex to $newIndex');
              widget.onReorder(draggedIndex, newIndex);
            },
          ),
        );
      }
    }

    return _DragStateWidget(
      isDragging: _dragIndex != null,
      child: Listener(
        onPointerMove: _dragIndex != null ? _updateMousePosition : null,
        child: ListView(
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          padding: widget.padding,
          children: items,
        ),
      ),
    );
  }

  // Get RenderObject of child widget
  RenderObject? _findRenderObject(int index) {
    if (index < 0 || index >= widget.children.length) return null;

    // Get RenderObject of child widget using GlobalKey
    final Widget child = widget.children[index];
    final Key? key = child.key;

    if (key == null) return null;

    // Search for RenderObject from BuildContext
    try {
      final BuildContext? childContext = _findChildContext(key);
      if (childContext == null) return null;
      return childContext.findRenderObject();
    } catch (e) {
      return null;
    }
  }

  // Search for BuildContext corresponding to key
  BuildContext? _findChildContext(Key key) {
    BuildContext? result;

    void visitor(Element element) {
      if (element.widget.key == key) {
        result = element;
        return;
      }
      element.visitChildren(visitor);
    }

    // Recursively search from root element
    (context as Element).visitChildren(visitor);

    return result;
  }
}
