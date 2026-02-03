// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_system_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fileSystemServiceHash() => r'75336f30fb6228a20103ca79e17c425d96c0bf48';

/// Provider that provides a FileSystemService instance
///
/// Copied from [fileSystemService].
@ProviderFor(fileSystemService)
final fileSystemServiceProvider =
    AutoDisposeProvider<FileSystemService>.internal(
      fileSystemService,
      name: r'fileSystemServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fileSystemServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FileSystemServiceRef = AutoDisposeProviderRef<FileSystemService>;
String _$documentsDirectoryHash() =>
    r'dbc3a5bd5d70d0052c45a2e65984bd9972b0063d';

/// Provider that provides the application's documents directory
///
/// Copied from [documentsDirectory].
@ProviderFor(documentsDirectory)
final documentsDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      documentsDirectory,
      name: r'documentsDirectoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$documentsDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DocumentsDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$supportDirectoryHash() => r'38a882b99b6c7c51d1b3299b4186c911bd0ddc67';

/// Provider that provides the application's support directory
///
/// Copied from [supportDirectory].
@ProviderFor(supportDirectory)
final supportDirectoryProvider = AutoDisposeFutureProvider<Directory>.internal(
  supportDirectory,
  name: r'supportDirectoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supportDirectoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupportDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$temporaryDirectoryHash() =>
    r'd27d2f9f304878bbc24c5688f315ee53a2334540';

/// Provider that provides the application's temporary directory
///
/// Copied from [temporaryDirectory].
@ProviderFor(temporaryDirectory)
final temporaryDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      temporaryDirectory,
      name: r'temporaryDirectoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$temporaryDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TemporaryDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$fileSystemOperationsHash() =>
    r'f5234ca53c4fd2dacb59649e29fea40155ababf8';

/// Provider that provides file system operations
///
/// Copied from [fileSystemOperations].
@ProviderFor(fileSystemOperations)
final fileSystemOperationsProvider =
    AutoDisposeProvider<FileSystemOperations>.internal(
      fileSystemOperations,
      name: r'fileSystemOperationsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fileSystemOperationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FileSystemOperationsRef = AutoDisposeProviderRef<FileSystemOperations>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
