/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// Local HTTP server that accepts MCP commands from the MCP server process.
///
/// Active on debug builds by default; opt-in via app settings on release builds.
/// Listens on localhost:6107 only.
class McpHttpServer {
  static const int port = 6107;

  HttpServer? _server;

  bool get isRunning => _server != null;

  Future<void> start() async {
    if (_server != null) return;

    final router = Router();
    router.get('/ping', _handlePing);

    final handler = const Pipeline()
        .addMiddleware(_corsMiddleware())
        .addHandler(router.call);

    _server = await shelf_io.serve(
      handler,
      InternetAddress.loopbackIPv4,
      port,
    );
    debugPrint('McpHttpServer: listening on localhost:$port');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    debugPrint('McpHttpServer: stopped');
  }

  Response _handlePing(Request request) {
    final body = jsonEncode({'status': 'ok', 'app': 'RinneGraph'});
    return Response.ok(body, headers: {'content-type': 'application/json'});
  }

  Middleware _corsMiddleware() {
    return (Handler inner) {
      return (Request request) async {
        final response = await inner(request);
        return response.change(headers: {
          'access-control-allow-origin': 'http://localhost',
          ...response.headers,
        });
      };
    };
  }
}
