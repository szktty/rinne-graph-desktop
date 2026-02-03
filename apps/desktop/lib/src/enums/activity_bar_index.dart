/// Activity bar index enum
enum ActivityBarIndex {
  /// Graph Navigation
  graphNavigation(0),

  /// Advanced Search
  advancedSearch(1),

  /// Settings
  settings(7),

  /// Stack Collection
  stackCollection(8),

  /// Entity Editor
  entityEditor(10),

  /// Welcome screen
  welcome(11),

  /// Label List
  labelList(12),

  /// Property List
  propertyList(13),

  /// AI Test screen
  aiTest(14);

  const ActivityBarIndex(this.value);

  /// Index value
  final int value;
}
