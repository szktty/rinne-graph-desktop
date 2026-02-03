import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_view_providers.g.dart';

/// Provider that manages the tab view state of the entity editor
@riverpod
class TabViewState extends _$TabViewState {
  @override
  String? build() => 'info'; // Default is 'info' tab

  void selectTab(String tabId) {
    if (state != tabId) {
      state = tabId;
    }
  }

  bool isTabSelected(String tabId) => state == tabId;

  void clearSelection() {
    state = null;
  }
}
