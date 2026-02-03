// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$archivedEntitiesHash() => r'7197f981e3f40aa6ab95f3d599db2b4ab1123e93';

/// Provider that provides a list of archived entities.
///
/// Copied from [archivedEntities].
@ProviderFor(archivedEntities)
final archivedEntitiesProvider =
    AutoDisposeFutureProvider<List<ArchivedEntity>>.internal(
      archivedEntities,
      name: r'archivedEntitiesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$archivedEntitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArchivedEntitiesRef =
    AutoDisposeFutureProviderRef<List<ArchivedEntity>>;
String _$archiveActionsHash() => r'96d75a81efcdffc0d6eefd47b603e0003c6dbfa4';

/// Provider that offers archive operations.
///
/// Copied from [ArchiveActions].
@ProviderFor(ArchiveActions)
final archiveActionsProvider =
    AutoDisposeNotifierProvider<ArchiveActions, void>.internal(
      ArchiveActions.new,
      name: r'archiveActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$archiveActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ArchiveActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
