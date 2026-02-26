// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_system_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides a FileSystemService instance

@ProviderFor(fileSystemService)
final fileSystemServiceProvider = FileSystemServiceProvider._();

/// Provider that provides a FileSystemService instance

final class FileSystemServiceProvider
    extends
        $FunctionalProvider<
          FileSystemService,
          FileSystemService,
          FileSystemService
        >
    with $Provider<FileSystemService> {
  /// Provider that provides a FileSystemService instance
  FileSystemServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSystemServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSystemServiceHash();

  @$internal
  @override
  $ProviderElement<FileSystemService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileSystemService create(Ref ref) {
    return fileSystemService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSystemService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileSystemService>(value),
    );
  }
}

String _$fileSystemServiceHash() => r'75336f30fb6228a20103ca79e17c425d96c0bf48';

/// Provider that provides the application's documents directory

@ProviderFor(documentsDirectory)
final documentsDirectoryProvider = DocumentsDirectoryProvider._();

/// Provider that provides the application's documents directory

final class DocumentsDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides the application's documents directory
  DocumentsDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return documentsDirectory(ref);
  }
}

String _$documentsDirectoryHash() =>
    r'dbc3a5bd5d70d0052c45a2e65984bd9972b0063d';

/// Provider that provides the application's support directory

@ProviderFor(supportDirectory)
final supportDirectoryProvider = SupportDirectoryProvider._();

/// Provider that provides the application's support directory

final class SupportDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides the application's support directory
  SupportDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return supportDirectory(ref);
  }
}

String _$supportDirectoryHash() => r'38a882b99b6c7c51d1b3299b4186c911bd0ddc67';

/// Provider that provides the application's temporary directory

@ProviderFor(temporaryDirectory)
final temporaryDirectoryProvider = TemporaryDirectoryProvider._();

/// Provider that provides the application's temporary directory

final class TemporaryDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides the application's temporary directory
  TemporaryDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return temporaryDirectory(ref);
  }
}

String _$temporaryDirectoryHash() =>
    r'd27d2f9f304878bbc24c5688f315ee53a2334540';

/// Provider that provides file system operations

@ProviderFor(fileSystemOperations)
final fileSystemOperationsProvider = FileSystemOperationsProvider._();

/// Provider that provides file system operations

final class FileSystemOperationsProvider
    extends
        $FunctionalProvider<
          FileSystemOperations,
          FileSystemOperations,
          FileSystemOperations
        >
    with $Provider<FileSystemOperations> {
  /// Provider that provides file system operations
  FileSystemOperationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSystemOperationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSystemOperationsHash();

  @$internal
  @override
  $ProviderElement<FileSystemOperations> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileSystemOperations create(Ref ref) {
    return fileSystemOperations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSystemOperations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileSystemOperations>(value),
    );
  }
}

String _$fileSystemOperationsHash() =>
    r'f5234ca53c4fd2dacb59649e29fea40155ababf8';
