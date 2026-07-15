import 'dart:convert';
import '../models/package_model.dart';
import '../models/quiz_model.dart';
import 'api_client.dart';

/// Service untuk Package API - sesuai modul Pertemuan 15
class PackageService {
  static Future<List<PackageModel>> getPackages() async {
    try {
      print('PackageService: fetching /packages');
      final response = await ApiClient.get('/packages', auth: false);
      print('PackageService: status=${response.statusCode}');
      print('PackageService: body=${response.body.substring(0, response.body.length > 300 ? 300 : response.body.length)}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = [];
        if (data is Map && data['success'] == true) {
          list = data['data'] ?? [];
        } else if (data is Map && data['data'] is List) {
          list = data['data'];
        } else if (data is List) {
          list = data;
        }

        print('PackageService: found ${list.length} packages');
        return list.map((e) => PackageModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      return [];
    } catch (e, stack) {
      print('Error fetching packages: $e');
      print('Stack: $stack');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getPackageDetail(int packageId) async {
    try {
      final response =
          await ApiClient.get('/packages/$packageId', auth: false);
      print('PackageDetail response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data['success'] == true) {
          return Map<String, dynamic>.from(data['data']);
        }
        if (data is Map && data['id'] != null) {
          return Map<String, dynamic>.from(data);
        }
      }
      return null;
    } catch (e, stack) {
      print('Error fetching package detail: $e');
      print('Stack: $stack');
      return null;
    }
  }

  static Future<QuizModel?> getQuiz(int packageId) async {
    try {
      final response = await ApiClient.get('/packages/$packageId/quiz');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['success'] == true) {
          return QuizModel.fromJson(Map<String, dynamic>.from(data['data']));
        }
      }
      return null;
    } catch (e) {
      print('Error fetching quiz: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> submitQuiz(
      int packageId, Map<String, String> answers) async {
    try {
      final response = await ApiClient.post(
        '/packages/$packageId/quiz/submit',
        body: {'answers': answers},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      }
      return {'success': false, 'message': data['message'] ?? 'Gagal submit quiz'};
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }
}
