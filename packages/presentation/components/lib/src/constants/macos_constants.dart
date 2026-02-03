/// macOS-specific constant values.
class MacOSConstants {
  MacOSConstants._();

  /// The width of the macOS traffic light buttons (red, yellow, green).
  ///
  /// The traffic light buttons occupy a position of about 90px from the left edge.
  /// This value is based on the standard macOS window layout.
  static const double trafficLightButtonsWidth = 90.0;

  /// Recommended margin between the traffic light buttons and the content.
  static const double trafficLightButtonsMargin = 8.0;

  /// Safe area on the left side, considering the traffic light buttons.
  static const double leftSafeArea =
      trafficLightButtonsWidth + trafficLightButtonsMargin;
}
