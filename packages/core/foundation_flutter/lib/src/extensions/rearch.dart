import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueFoundationExtension<T> on AsyncValue<T> {
  T get unwrap {
    return when(
      data: (data) => data,
      loading: () => throw StateError('data is still loading'),
      error: (error, _) => throw StateError('data loading failed: $error'),
    );
  }
}
