import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:plough/plough.dart' as plough;

import '../providers/link_creation_providers.dart';
import '../../../providers/graph_providers.dart';

class LinkCreationOverlay extends ConsumerStatefulWidget {
  const LinkCreationOverlay({super.key});

  @override
  ConsumerState<LinkCreationOverlay> createState() =>
      _LinkCreationOverlayState();
}

class _LinkCreationOverlayState extends ConsumerState<LinkCreationOverlay> {
  late TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linkCreationState = ref.watch(tapLinkCreationProvider);

    if (linkCreationState.step != LinkCreationStep.confirming) {
      return const SizedBox.shrink();
    }

    final sourceId = linkCreationState.sourceNodeId;
    final targetId = linkCreationState.targetNodeId;
    final ploughGraph = ref.watch(graphViewCacheProvider).ploughGraph;

    if (sourceId == null || targetId == null || ploughGraph == null) {
      return const SizedBox.shrink();
    }

    final sourceNode = ploughGraph.getNode(
      plough.GraphId(type: plough.GraphIdType.node, value: sourceId.value),
    );
    final targetNode = ploughGraph.getNode(
      plough.GraphId(type: plough.GraphIdType.node, value: targetId.value),
    );

    if (sourceNode == null ||
        targetNode == null ||
        sourceNode.geometry == null ||
        targetNode.geometry == null) {
      return const SizedBox.shrink();
    }

    final sourcePos = sourceNode.geometry!.bounds.center;
    final targetPos = targetNode.geometry!.bounds.center;
    final midPoint = (sourcePos + targetPos) / 2;

    const controlWidth = 250.0;
    const controlHeight = 150.0;

    return Stack(
      children: [
        CustomPaint(
          painter: _LinkPreviewPainter(start: sourcePos, end: targetPos),
          size: Size.infinite,
        ),
        Positioned(
          left: midPoint.dx - (controlWidth / 2),
          top: midPoint.dy - (controlHeight / 2),
          width: controlWidth,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Create Link'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                      labelText: 'Link Label',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _labelController.clear();
                          ref.read(tapLinkCreationProvider.notifier).cancel();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _createLink(sourceId, targetId),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createLink(
    core_graph.EntityId sourceId,
    core_graph.EntityId targetId,
  ) async {
    final label = _labelController.text;
    _labelController.clear();

    try {
      final storage = ref.read(activeStackGraphStorageProvider);
      if (storage == null) return;

      final graphContext = core_graph.GraphContext(storage: storage);
      await graphContext.initialize();

      final description = core_graph.EntityDescription(
        type: 'Link',
        propertyTypes: {'label': const core_graph.TextPropertyType()},
      );

      await graphContext.createLink(
        sourceId: sourceId,
        targetId: targetId,
        type: label.isNotEmpty ? label : 'related',
        description: description,
        properties: {'label': label},
      );

      // Refresh graph state
      final activeGraph = ref.read(core_graph.activeGraphProvider);
      if (activeGraph != null) {
        final updatedLinks = await graphContext.queryLinks(
          core_graph.GraphQuery<core_graph.Link>(entityType: core_graph.Link),
        );
        var newGraph = activeGraph;
        for (final link in updatedLinks.items) {
          newGraph = newGraph.addLink(link);
        }
        ref.read(core_graph.activeGraphProvider.notifier).setGraph(newGraph);
      }

      await graphContext.close();
    } catch (e) {
      debugPrint('Error creating link: $e');
    } finally {
      ref.read(tapLinkCreationProvider.notifier).completeAndContinue();
    }
  }
}

class _LinkPreviewPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  _LinkPreviewPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue.withOpacity(0.7)
          ..strokeWidth = 2.0;

    // Draw a dashed line
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    final path = Path()..moveTo(start.dx, start.dy);
    final d = (end - start).distance;
    final direction = (end - start) / d;

    double distance = 0;
    while (distance < d) {
      path.lineTo(
        start.dx + direction.dx * (distance + dashWidth),
        start.dy + direction.dy * (distance + dashWidth),
      );
      distance += dashWidth + dashSpace;
      path.moveTo(
        start.dx + direction.dx * distance,
        start.dy + direction.dy * distance,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LinkPreviewPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
