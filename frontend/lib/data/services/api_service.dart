import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/topic_model.dart';
import '../models/speaking_material_model.dart';
import '../../core/constants/api_constants.dart';
import 'auth_service.dart';

class ApiService {
  final String _base = ApiConstants.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, String>> _headers({String? contentType}) async {
    final h = <String, String>{'Accept': 'application/json'};
    if (contentType != null) h['Content-Type'] = contentType;
    final token = await _auth.getToken();
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  // ─── USERS ───────────────────────────────────────────────
  Future<List<UserModel>> getUsers() async {
    final res = await http.get(
      Uri.parse('$_base/users'),
      headers: await _headers(),
    );
    _checkStatus(res);
    final body = jsonDecode(res.body);
    final List data = body['data'];
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<UserModel> getUserById(int id) async {
    final res = await http.get(
      Uri.parse('$_base/users/$id'),
      headers: await _headers(),
    );
    _checkStatus(res);
    return UserModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<UserModel> createUser(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$_base/users'),
      headers: await _headers(contentType: 'application/json'),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    _checkStatus(res);
    return UserModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<UserModel> updateUser(int id,
      {String? name, String? email, String? password}) async {
    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    final res = await http.put(
      Uri.parse('$_base/users/$id'),
      headers: await _headers(contentType: 'application/json'),
      body: jsonEncode(body),
    );
    _checkStatus(res);
    return UserModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<void> deleteUser(int id) async {
    final res = await http.delete(
      Uri.parse('$_base/users/$id'),
      headers: await _headers(),
    );
    _checkStatus(res);
  }

  // ─── TOPICS ──────────────────────────────────────────────
  Future<List<TopicModel>> getTopics() async {
    final res = await http.get(
      Uri.parse('$_base/topics'),
      headers: await _headers(),
    );
    _checkStatus(res);
    final body = jsonDecode(res.body);
    final List data = body['data'];
    return data.map((e) => TopicModel.fromJson(e)).toList();
  }

  Future<TopicModel> getTopicById(int id) async {
    final res = await http.get(
      Uri.parse('$_base/topics/$id'),
      headers: await _headers(),
    );
    _checkStatus(res);
    return TopicModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<TopicModel> createTopic(
      {required String title,
      String? description,
      double price = 0,
      bool isFree = false}) async {
    final res = await http.post(
      Uri.parse('$_base/topics'),
      headers: await _headers(contentType: 'application/json'),
      body: jsonEncode({
        'title': title,
        'description': description,
        'price': price,
        'is_free': isFree,
      }),
    );
    _checkStatus(res);
    return TopicModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<void> deleteTopic(int id) async {
    final res = await http.delete(
      Uri.parse('$_base/topics/$id'),
      headers: await _headers(),
    );
    _checkStatus(res);
  }

  // ─── SPEAKING MATERIALS ──────────────────────────────────
  Future<List<SpeakingMaterialModel>> getMaterials() async {
    final res = await http.get(
      Uri.parse('$_base/speaking-materials'),
      headers: await _headers(),
    );
    _checkStatus(res);
    final list = _decodeJsonList(res.body);
    return list
        .map((e) => SpeakingMaterialModel.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<SpeakingMaterialModel> getMaterialById(int id) async {
    final res = await http.get(
      Uri.parse('$_base/speaking-materials/$id'),
      headers: await _headers(),
    );
    _checkStatus(res);
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is Map) {
        return SpeakingMaterialModel.fromJson(
            Map<String, dynamic>.from(decoded['data'] as Map));
      }
      if (decoded['id'] != null) {
        return SpeakingMaterialModel.fromJson(decoded);
      }
    }
    throw const FormatException('Format respons detail materi tidak valid');
  }

  Future<SpeakingMaterialModel> createMaterial({
    required String title,
    String? description,
    required String videoPath,
    String? pdfPath,
  }) async {
    final req = http.MultipartRequest(
        'POST', Uri.parse('$_base/speaking-materials'));
    req.headers.addAll(await _headers());
    req.fields['title'] = title;
    if (description != null) req.fields['description'] = description;
    req.files.add(await http.MultipartFile.fromPath('video', videoPath));
    if (pdfPath != null) {
      req.files.add(await http.MultipartFile.fromPath('pdf', pdfPath));
    }
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    _checkStatus(res);
    return SpeakingMaterialModel.fromJson(
        jsonDecode(res.body)['data']);
  }

  Future<void> deleteMaterial(int id) async {
    final res = await http.delete(
      Uri.parse('$_base/speaking-materials/$id'),
      headers: await _headers(),
    );
    _checkStatus(res);
  }

  Future<void> saveProgress(
      {required int materialId,
      required int userId,
      required double progress}) async {
    final res = await http.post(
      Uri.parse('$_base/speaking-materials/progress'),
      headers: await _headers(contentType: 'application/json'),
      body: jsonEncode({
        'material_id': materialId,
        'user_id': userId,
        'progress': progress,
      }),
    );
    _checkStatus(res);
  }

  /// Accepts `[...]` or `{"data":[...]}` from Laravel.
  List<dynamic> _decodeJsonList(String body) {
    final decoded = jsonDecode(body);
    if (decoded is List<dynamic>) return decoded;
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List<dynamic>) return data;
    }
    throw const FormatException('Expected JSON array or object with "data" array');
  }

  // ─── HELPER ──────────────────────────────────────────────
  void _checkStatus(http.Response res) {
    if (res.statusCode >= 400) {
      final body = jsonDecode(res.body);
      throw ApiException(
        message: body['message'] ?? 'Terjadi kesalahan',
        statusCode: res.statusCode,
        errors: body['errors'],
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException(
      {required this.message, required this.statusCode, this.errors});

  @override
  String toString() => message;
}
