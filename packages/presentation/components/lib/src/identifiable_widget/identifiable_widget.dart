import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';

/// Base class for widgets that have an ID.
///
/// Based on this class, you can create widget components with a unique ID.
/// Since it uses the Riverpod framework, state management functions are also
/// available.
abstract class IdentifiableWidget extends ConsumerWidget {
  /// Unique identifier for the widget.
  final UniqueId id;

  /// Creates an [IdentifiableWidget].
  ///
  /// [id] - The unique identifier for the widget.
  /// [key] - Optional Flutter widget key.
  const IdentifiableWidget({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref);
}

/// Base class for widgets that display entities implementing Identifiable.
abstract class IdentifiableEntityWidget<T extends Identifiable>
    extends IdentifiableWidget {
  /// The entity to display.
  final T entity;

  /// Creates an [IdentifiableEntityWidget].
  ///
  /// [entity] - The entity to display (must have an ID).
  /// [key] - Optional Flutter widget key.
  IdentifiableEntityWidget({required this.entity, super.key})
    : super(id: entity.id);

  @override
  Widget build(BuildContext context, WidgetRef ref);
}
