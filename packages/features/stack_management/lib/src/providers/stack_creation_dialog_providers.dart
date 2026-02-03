import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stack_creation_dialog_providers.g.dart';

/// Form name state for stack creation dialog
@riverpod
class FormNameState extends _$FormNameState {
  @override
  String build() => '';

  void setName(String name) {
    state = name;
  }
}

/// Form save path state for stack creation dialog
@riverpod
class FormSavePathState extends _$FormSavePathState {
  @override
  String build() => '';

  void setSavePath(String savePath) {
    state = savePath;
  }
}
