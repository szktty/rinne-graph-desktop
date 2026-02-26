import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_foundation_common/core_foundation_common.dart';

part 'id_providers.g.dart';

/// Provider for generating IDs.
///
/// Generates UUIDv7 format IDs.
@riverpod
UniqueId Function() idFactory(Ref ref) {
  return () => UniqueId();
}

/// Provider for managing IDs.
@riverpod
class IdCollectionManager extends _$IdCollectionManager {
  @override
  List<UniqueId> build() => [];

  /// Adds an ID.
  void add(UniqueId id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }

  /// Removes an ID.
  void remove(UniqueId id) {
    state = state.where((i) => i != id).toList();
  }

  /// Checks if an ID is contained.
  bool contains(UniqueId id) => state.contains(id);

  /// Gets all IDs.
  List<UniqueId> get ids => state;
}

/// Provider that provides an ID generator.
@riverpod
IdGenerator idGenerator(Ref ref) {
  return RiverpodUuidV7Generator();
}

/// Provider that provides an ID generator for testing.
@riverpod
IdGenerator testIdGenerator(Ref ref) {
  return RiverpodTestIdGenerator();
}

/// Provider that provides an in-memory ID generator.
@riverpod
IdGenerator inMemoryIdGenerator(Ref ref) {
  return RiverpodInMemoryIdGenerator();
}

/// UUIDv7 format ID generator (Riverpod version).
class RiverpodUuidV7Generator implements IdGenerator {
  @override
  UniqueId generate() => UniqueId();
}

/// ID generator for testing (Riverpod version).
///
/// Generates predictable IDs.
class RiverpodTestIdGenerator implements IdGenerator {
  int _counter = 0;

  @override
  UniqueId generate() {
    final id = 'test-${_counter.toString().padLeft(4, '0')}';
    _counter++;
    return UniqueId.trusted(id);
  }
}

/// In-memory ID generator (Riverpod version).
///
/// Generates IDs in memory.
class RiverpodInMemoryIdGenerator implements IdGenerator {
  int _counter = 0;

  @override
  UniqueId generate() {
    final id = 'mem-${_counter.toString().padLeft(4, '0')}';
    _counter++;
    return UniqueId.trusted(id);
  }
}
