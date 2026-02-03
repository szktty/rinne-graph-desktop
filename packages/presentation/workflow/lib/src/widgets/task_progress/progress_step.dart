/// Definition of progress step
class ProgressStep {
  /// Constructor
  const ProgressStep({
    required this.range,
    this.animationDuration = const Duration(milliseconds: 500),
    this.label,
  });

  /// Progress range (start and end percentage)
  final (double, double) range;

  /// Animation duration
  final Duration animationDuration;

  /// Optional label
  final String? label;
}
