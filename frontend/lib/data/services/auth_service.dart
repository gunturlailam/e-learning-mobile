import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../../core/constants/api_constants.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final String _base = ApiConstants.baseUrl;

  Map<String, dynamic> _parseJsonMap(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('invalid_json');
    }
    return decoded;
  }

  String _firstValidationMessage(Map<String, dynamic> errors) {
    for (final v in errors.values) {
      if (v is List && v.isNotEmpty) return v.first.toString();
      if (v != null) return v.toString();
    }
    return 'Validasi gagal';
  }

  // ─── LOGIN ───────────────────────────────────────────────
  Future<AuthUser> login(String email, String password) async {
    late final http.Response res;
    try {
      res = await http.post(
        Uri.parse('$_base/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
    } on SocketException {
      throw Exception(
          'Tidak ada koneksi. Pastikan Laravel jalan (php artisan serve --host=0.0.0.0) dan IP di ApiConstants benar.');
    } on http.ClientException catch (e) {
      throw Exception('Koneksi gagal: ${e.message}');
    }

    final Map<String, dynamic> body;
    try {
      body = _parseJsonMap(res.body);
    } catch (_) {
      throw Exception('Respons server tidak valid (bukan JSON).');
    }

    if (res.statusCode == 200 && body['success'] == true) {
      final userMap = body['user'];
      final token = body['token'];
      if (userMap is! Map || token is! String) {
        throw Exception('Format respons login tidak dikenali.');
      }
      final user = AuthUser.fromJson(
        Map<String, dynamic>.from(userMap),
        token,
      );
      await _saveSession(user);
      return user;
    }

    if (body['errors'] != null && body['errors'] is Map<String, dynamic>) {
      throw Exception(_firstValidationMessage(body['errors'] as Map<String, dynamic>));
    }

    throw Exception(body['message']?.toString() ?? 'Email atau password salah');
  }

  // ─── REGISTER ────────────────────────────────────────────
  Future<AuthUser> register(String name, String email, String password) async {
    late final http.Response res;
    try {
      res = await http.post(
        Uri.parse('$_base/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
    } on SocketException {
      throw Exception(
          'Tidak ada koneksi. Pastikan server Laravel aktif dan URL API benar.');
    } on http.ClientException catch (e) {
      throw Exception('Koneksi gagal: ${e.message}');
    }

    final Map<String, dynamic> body;
    try {
      body = _parseJsonMap(res.body);
    } catch (_) {
      throw Exception('Respons server tidak valid (bukan JSON).');
    }

    if ((res.statusCode == 200 || res.statusCode == 201) &&
        body['success'] == true) {
      final userMap = body['user'];
      final token = body['token'];
      if (userMap is! Map || token is! String) {
        throw Exception('Format respons registrasi tidak dikenali.');
      }
      final user = AuthUser.fromJson(
        Map<String, dynamic>.from(userMap),
        token,
      );
      await _saveSession(user);
      return user;
    }

    if (body['errors'] != null && body['errors'] is Map<String, dynamic>) {
      throw Exception(_firstValidationMessage(body['errors'] as Map<String, dynamic>));
    }

    throw Exception(body['message']?.toString() ?? 'Registrasi gagal');
  }

  // ─── LOGOUT ──────────────────────────────────────────────
  Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$_base/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      } catch (_) {}
    }
    await _clearSession();
  }

  // ─── SESSION ─────────────────────────────────────────────
  Future<void> _saveSession(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, user.token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<AuthUser?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    final json = jsonDecode(raw);
    return AuthUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
