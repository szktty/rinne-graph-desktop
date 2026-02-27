/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

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
