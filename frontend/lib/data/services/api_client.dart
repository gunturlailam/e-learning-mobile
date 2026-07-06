import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class ApiClient {
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(String path, {bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return await http
        .get(
          Uri.parse('${ApiConstants.baseUrl}$path'),
          headers: headers,
        )
        .timeout(const Duration(seconds: 30));
  }

  static Future<http.Response> post(String path,
      {Map<String, dynamic>? body, bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return await http
        .post(
          Uri.parse('${ApiConstants.baseUrl}$path'),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 30));
  }

  static Future<http.Response> put(String path,
      {Map<String, dynamic>? body, bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return await http
        .put(
          Uri.parse('${ApiConstants.baseUrl}$path'),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 30));
  }

  static Future<http.StreamedResponse> postMultipart(
    String path, {
    required String fileField,
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
    Map<String, String>? fields,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}$path'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    if (fileBytes != null && fileName != null) {
      // Web: use bytes
      request.files.add(http.MultipartFile.fromBytes(
        fileField,
        fileBytes,
        filename: fileName,
      ));
    } else if (filePath != null) {
      // Mobile: use path
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    return await request.send().timeout(const Duration(seconds: 60));
  }
}
