import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:uuid/uuid.dart';

/// UUID-based ID generator.
class UuidGenerator implements IdGenerator {
  static final _uuid = Uuid();

  @override
  UniqueId generate() {
    return UniqueId.fromString(_uuid.v7());
  }

  /// Generates an ID from a string.
  static UniqueId fromString(String value) {
    return UniqueId.fromString(value);
  }
}
