import '../identifiable_widget/identifiable_widget.dart';

/// A basic interface for identifying navigation elements.
///
/// Navigation-related widgets are expected to implement this interface and have
/// a unique ID.
abstract class IdentifiableNavigationItem extends IdentifiableWidget {
  /// Creates a new [IdentifiableNavigationItem].
  ///
  /// [id] - The unique identifier for the navigation item.
  const IdentifiableNavigationItem({required super.id, super.key});
}
