import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'master_detail_state.g.dart';

/// Management of selection state.
@riverpod
class SelectedItem extends _$SelectedItem {
  @override
  String? build() {
    return null;
  }

  void setSelectedId(String? id) {
    state = id;
  }
}

/// Management of master width.
@riverpod
class MasterWidth extends _$MasterWidth {
  @override
  double build() {
    return 280.0; // Default value
  }

  void setWidth(double width) {
    state = width;
  }
}

/// Management of detail display visibility.
@riverpod
class DetailVisibility extends _$DetailVisibility {
  @override
  bool build() {
    return false; // Default is hidden
  }

  void setVisible(bool visible) {
    state = visible;
  }
}
