// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableMetadataTabsHash() =>
    r'0151dccfaeb7ce6d992173c59df6a51ece41f89d';

/// Provider that provides a list of available metadata tabs
///
/// Copied from [availableMetadataTabs].
@ProviderFor(availableMetadataTabs)
final availableMetadataTabsProvider =
    AutoDisposeProvider<List<MetadataTab>>.internal(
      availableMetadataTabs,
      name: r'availableMetadataTabsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$availableMetadataTabsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableMetadataTabsRef = AutoDisposeProviderRef<List<MetadataTab>>;
String _$metadataTabStateHash() => r'5a19b50d0920ace5faffcb192b2294bd12cb706a';

/// Provider that manages the tab state for metadata management
///
/// Copied from [MetadataTabState].
@ProviderFor(MetadataTabState)
final metadataTabStateProvider =
    AutoDisposeNotifierProvider<MetadataTabState, String>.internal(
      MetadataTabState.new,
      name: r'metadataTabStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$metadataTabStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MetadataTabState = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
