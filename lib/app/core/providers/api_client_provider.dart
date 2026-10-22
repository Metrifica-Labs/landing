import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:metrifica_landing/app/core/config/app_config.dart';

class ApiClient {
  ApiClient(this._http);

  final http.Client _http;

  Uri _uri(String path) => Uri.parse('${AppConfig.apiUrl}$path');

  Future<dynamic> get(String path) async =>
      _decode(await _http.get(_uri(path)));

  Future<dynamic> post(String path, Map<String, dynamic> body) async =>
      _decode(await _http.post(
        _uri(path),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ));

  Future<dynamic> patch(String path, Map<String, dynamic> body) async =>
      _decode(await _http.patch(
        _uri(path),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ));

  dynamic _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
    return res.body.isEmpty ? null : jsonDecode(utf8.decode(res.bodyBytes));
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(http.Client());
});
