import 'package:core_graph_common/src/model/entity_id.dart';
import 'package:core_graph_common/src/model/link.dart';
import 'package:core_graph_common/src/model/node.dart';
import 'package:meta/meta.dart';

/// Represents a graph containing nodes and links.
@immutable
class Graph {
  /// Creates a new graph instance.
  ///
  /// Optionally initializes with a set of nodes and links.
  Graph({Set<Node>? nodes, Set<Link>? links})
    : _nodes = {for (var node in nodes ?? <Node>{}) node.id: node},
      _links = {for (var link in links ?? <Link>{}) link.id: link};
  final Map<EntityId, Node> _nodes;
  final Map<EntityId, Link> _links;

  /// Returns an unmodifiable view of the nodes in the graph.
  Map<EntityId, Node> get nodes => Map.unmodifiable(_nodes);

  /// Returns an unmodifiable view of the links in the graph.
  Map<EntityId, Link> get links => Map.unmodifiable(_links);

  /// Creates a new graph by adding a node.
  ///
  /// If a node with the same ID already exists, it will be replaced.
  Graph addNode(Node node) {
    final newNodes = Map<EntityId, Node>.from(_nodes);
    newNodes[node.id] = node;
    return Graph(nodes: newNodes.values.toSet(), links: _links.values.toSet());
  }

  /// Creates a new graph by removing a node.
  ///
  /// Also removes any links connected to the removed node.
  /// If the node does not exist, returns the original graph.
  Graph removeNode(EntityId nodeId) {
    if (!_nodes.containsKey(nodeId)) {
      return this;
    }
    final newNodes = Map<EntityId, Node>.from(_nodes);
    newNodes.remove(nodeId);

    final newLinks = Map<EntityId, Link>.from(_links);
    newLinks.removeWhere(
      (_, link) => link.sourceId == nodeId || link.targetId == nodeId,
    );

    return Graph(
      nodes: newNodes.values.toSet(),
      links: newLinks.values.toSet(),
    );
  }

  /// Creates a new graph by adding a link.
  ///
  /// If a link with the same ID already exists, it will be replaced.
  /// If the source or target node does not exist in the graph, the link is not added.
  Graph addLink(Link link) {
    // Ensure source and target nodes exist
    if (!_nodes.containsKey(link.sourceId) ||
        !_nodes.containsKey(link.targetId)) {
      // Optionally, throw an error or log a warning
      // print("Warning: Could not add link ${link.id} because source or target node not found.");
      return this;
    }
    final newLinks = Map<EntityId, Link>.from(_links);
    newLinks[link.id] = link;
    return Graph(nodes: _nodes.values.toSet(), links: newLinks.values.toSet());
  }

  /// Creates a new graph by removing a link.
  ///
  /// If the link does not exist, returns the original graph.
  Graph removeLink(EntityId linkId) {
    if (!_links.containsKey(linkId)) {
      return this;
    }
    final newLinks = Map<EntityId, Link>.from(_links);
    newLinks.remove(linkId);
    return Graph(nodes: _nodes.values.toSet(), links: newLinks.values.toSet());
  }

  /// Gets a node by its ID.
  ///
  /// Returns null if the node is not found.
  Node? getNode(EntityId nodeId) => _nodes[nodeId];

  /// Gets a link by its ID.
  ///
  /// Returns null if the link is not found.
  Link? getLink(EntityId linkId) => _links[linkId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Graph &&
          runtimeType == other.runtimeType &&
          _mapEquals(_nodes, other._nodes) &&
          _mapEquals(_links, other._links);

  @override
  int get hashCode => Object.hash(_mapHash(_nodes), _mapHash(_links));

  // Helper function for comparing maps
  bool _mapEquals<K, V>(Map<K, V> map1, Map<K, V> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  // Helper function for hashing maps
  int _mapHash<K, V>(Map<K, V> map) {
    var hash = 0;
    map.forEach((key, value) {
      hash = hash ^ key.hashCode ^ value.hashCode;
    });
    return hash;
  }
}
