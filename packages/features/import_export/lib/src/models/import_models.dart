class ImportProgress {
  final String taskId;
  final String fileName;
  final ImportStatus status;
  final double progress;
  final String? error;
  final DateTime? startTime;
  final DateTime? endTime;

  const ImportProgress({
    required this.taskId,
    required this.fileName,
    required this.status,
    required this.progress,
    this.error,
    this.startTime,
    this.endTime,
  });
}

enum ImportStatus {
  waiting,
  preparing,
  importing,
  processing,
  completed,
  failed,
  cancelled,
}
