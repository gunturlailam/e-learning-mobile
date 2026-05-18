import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/topic_model.dart';
import '../models/speaking_material_model.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  final String _base = ApiConstants.baseUrl;

  // ─── USERS ───────────────────────────────────────────────
  Future<List<UserModel>> getUsers() async {
    final res = await http.get(Uri.parse('$_base/users'));
    _checkStatus(res);
    final body = jsonDecode(res.body);
    final List data = body['data'];
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<UserModel> getUserById(int id) async {
    final res = await http.get(Uri.parse('$_base/users/$id'));
    _checkStatus(res);
    return UserModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<UserModel> createUser(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$_base/users'),
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    _checkStatus(res);
    return UserModel.fromJson(jsonDecode(res.body)['data']);
  }

  Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$_base/users/$id'));
    _checkStatus(res);
  }

  // ─── TOPICS ──────────────────────────────────────────────
  Future<List<TopicModel>> getTopics() async {
    final res = await http.get(Uri.parse('$_base/topics'));
    _checkStatus(res);
    final body = jsonDecode(res.body);
    final List data = body['data'];
    return data.map((e) => TopicModel.fromJson(e)).toList();
  }

  Future<TopicModel> getTopicById(int id) async {
    final res = await http.get(Uri.parse('$_base/topics/$id'));
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
      headers: {'Content-Type': 'application/json'},
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
    final res = await http.delete(Uri.parse('$_base/topics/$id'));
    _checkStatus(res);
  }

  // ─── SPEAKING MATERIALS ──────────────────────────────────
  Future<List<SpeakingMaterialModel>> getMaterials() async {
    final res =
        await http.get(Uri.parse('$_base/speaking-materials'));
    _checkStatus(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => SpeakingMaterialModel.fromJson(e)).toList();
  }

  Future<SpeakingMaterialModel> getMaterialById(int id) async {
    final res =
        await http.get(Uri.parse('$_base/speaking-materials/$id'));
    _checkStatus(res);
    return SpeakingMaterialModel.fromJson(
        jsonDecode(res.body)['data']);
  }

  Future<SpeakingMaterialModel> createMaterial({
    required String title,
    String? description,
    required String videoPath,
    String? pdfPath,
  }) async {
    final req = http.MultipartRequest(
        'POST', Uri.parse('$_base/speaking-materials'));
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
    final res =
        await http.delete(Uri.parse('$_base/speaking-materials/$id'));
    _checkStatus(res);
  }

  Future<void> saveProgress(
      {required int materialId,
      required int userId,
      required double progress}) async {
    final res = await http.post(
      Uri.parse('$_base/speaking-materials/progress'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'material_id': materialId,
        'user_id': userId,
        'progress': progress,
      }),
    );
    _checkStatus(res);
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
