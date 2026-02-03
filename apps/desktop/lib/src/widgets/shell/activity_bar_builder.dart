import 'package:flutter/widgets.dart';
import 'package:app/app.dart';

/// Builder extracted ActivityBar construction logic
/// Currently, it simply delegates and returns the AppActivityBar provided by the app.
class ActivityBarBuilder {
  const ActivityBarBuilder._();

  static Widget buildBar() {
    // Handle additional decorations or wrappers here if needed
    return const AppActivityBar();
  }
}
