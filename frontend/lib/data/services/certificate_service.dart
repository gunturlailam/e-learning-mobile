import 'dart:convert';
import '../models/certificate_model.dart';
import 'api_client.dart';

/// Service untuk mengambil sertifikat kelulusan milik user
class CertificateService {
  static Future<List<CertificateModel>> getMyCertificates() async {
    try {
      final response = await ApiClient.get('/my-certificates');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List list = [];
        if (data is Map && data['success'] == true) {
          list = data['data'] ?? [];
        } else if (data is List) {
          list = data;
        }
        return list
            .map((e) =>
                CertificateModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching certificates: $e');
      return [];
    }
  }
}
