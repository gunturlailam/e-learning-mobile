import 'dart:convert';
import '../models/quiz_model.dart';
import 'api_client.dart';

/// Service untuk Quiz — fetch soal dan submit jawaban
class QuizService {
  /// Ambil soal quiz berdasarkan packageId
  static Future<QuizModel> getQuiz({required int packageId}) async {
    final res = await ApiClient.get('/packages/$packageId/quiz');
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['success'] == true && body['data'] != null) {
        return QuizModel.fromJson(Map<String, dynamic>.from(body['data'] as Map));
      }
    }
    throw Exception(_errMsg(res.body));
  }

  /// Submit jawaban quiz — answers: {questionId: 'a'/'b'/'c'/'d'}
  static Future<QuizResult> submitQuiz({
    required int packageId,
    required Map<String, String> answers,
  }) async {
    final res = await ApiClient.post(
      '/packages/$packageId/quiz/submit',
      body: {'answers': answers},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['success'] == true && body['data'] != null) {
        return QuizResult.fromJson(
          Map<String, dynamic>.from(body['data'] as Map),
          body['message']?.toString() ?? '',
        );
      }
    }
    throw Exception(_errMsg(res.body));
  }

  static String _errMsg(String body) {
    try {
      final d = jsonDecode(body);
      if (d is Map) return d['message']?.toString() ?? 'Terjadi kesalahan';
    } catch (_) {}
    return 'Terjadi kesalahan server';
  }
}
