import 'unique_id.dart';

/// Interface for generating IDs
///
/// Generates unique IDs used throughout the application.
/// Implementation classes can provide different generation strategies (UUID, sequential, test, etc.).
abstract interface class IdGenerator {
  /// Generates a new ID
  UniqueId generate();
}
