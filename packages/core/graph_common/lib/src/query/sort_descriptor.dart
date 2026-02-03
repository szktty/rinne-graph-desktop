/// Sort descriptor
class SortDescriptor {
  /// Creates a new sort descriptor
  const SortDescriptor(this.property, {this.ascending = true});

  /// The name of the property to sort by
  final String property;

  /// The direction of the sort (ascending/descending)
  final bool ascending;

  @override
  String toString() {
    return '$property ${ascending ? 'asc' : 'desc'}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SortDescriptor &&
        other.property == property &&
        other.ascending == ascending;
  }

  @override
  int get hashCode => Object.hash(property, ascending);
}
