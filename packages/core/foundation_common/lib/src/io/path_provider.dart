/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io';

/// Interface for abstracting platform-specific path retrieval
///
/// This interface allows different implementations for Flutter and CLI environments:
/// - Flutter environment: Uses path_provider package
/// - CLI environment: Uses dart:io
abstract class PathProvider {
  /// Gets the application documents directory
  ///
  /// Returns the platform-specific documents directory:
  /// - macOS: ~/Documents or Documents within sandbox
  /// - Windows: %USERPROFILE%\Documents
  /// - Linux: ~/Documents
  Future<Directory> getApplicationDocumentsDirectory();

  /// Gets the application support directory
  ///
  /// Returns the platform-specific application support directory:
  /// - macOS: ~/Library/Application Support or equivalent within sandbox
  /// - Windows: %APPDATA%
  /// - Linux: ~/.local/share
  Future<Directory> getApplicationSupportDirectory();

  /// Gets the temporary directory
  ///
  /// Returns the platform-specific temporary directory.
  Future<Directory> getTemporaryDirectory();

  /// Gets the user-specific directory
  ///
  /// Returns the App application's root directory for storing user-specific
  /// information, created within the user's home directory:
  /// - macOS: ~/Documents/RinneGraph
  /// - Windows: %USERPROFILE%\Documents\RinneGraph
  /// - Linux: ~/Documents/RinneGraph
  Future<Directory> getUserSpecificDirectory();

  /// Gets the directory for stacks
  ///
  /// Returns the directory for storing stack files.
  /// By default, returns getUserSpecificDirectory() + "/Stacks".
  Future<Directory> getStacksDirectory() async {
    final userDir = await getUserSpecificDirectory();
    return Directory('${userDir.path}/Stacks');
  }

  /// Gets the directory for sample stacks
  ///
  /// Returns the directory for storing sample stack instances.
  /// By default, returns getUserSpecificDirectory() + "/Samples".
  Future<Directory> getSamplesDirectory() async {
    final userDir = await getUserSpecificDirectory();
    return Directory('${userDir.path}/Samples');
  }
}
