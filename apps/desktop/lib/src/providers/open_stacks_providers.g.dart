// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_stacks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$openStacksHash() => r'601107c306a736c3966223f1a9d1e22b4e51664a';

/// Provider managing the list of open stacks
///
/// Copied from [OpenStacks].
@ProviderFor(OpenStacks)
final openStacksProvider =
    AutoDisposeNotifierProvider<OpenStacks, List<core_stack.Stack>>.internal(
      OpenStacks.new,
      name: r'openStacksProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$openStacksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OpenStacks = AutoDisposeNotifier<List<core_stack.Stack>>;
String _$openStacksActionsHash() => r'ded253e84b7d82223aa466d0795570e787c5bd1c';

/// Action provider for open stacks
///
/// Copied from [OpenStacksActions].
@ProviderFor(OpenStacksActions)
final openStacksActionsProvider =
    AutoDisposeNotifierProvider<OpenStacksActions, void>.internal(
      OpenStacksActions.new,
      name: r'openStacksActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$openStacksActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OpenStacksActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
