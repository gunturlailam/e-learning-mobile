import 'dart:convert';
import '../models/payment_model.dart';
import 'api_client.dart';

class PaymentService {
  static Future<Map<String, dynamic>> createPayment(String menuName, String method, {int? packageId}) async {
    try {
      final body = <String, dynamic>{
        'method': method,
      };
      if (packageId != null) {
        body['package_id'] = packageId;
      } else {
        body['menu_name'] = menuName;
      }

      final response = await ApiClient.post('/payments', body: body);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal membuat pembayaran'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  static Future<Map<String, dynamic>> uploadProof(int paymentId, String? filePath, {List<int>? fileBytes, String? fileName}) async {
    try {
      print('uploadProof: paymentId=$paymentId, filePath=$filePath, hasBytes=${fileBytes != null}, fileName=$fileName');
      final response = await ApiClient.postMultipart(
        '/payments/$paymentId/upload-proof',
        fileField: 'proof',
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      final responseBody = await response.stream.bytesToString();
      print('uploadProof response: ${response.statusCode} - $responseBody');
      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal upload bukti'};
      }
    } catch (e) {
      print('uploadProof error: $e');
      return {'success': false, 'message': 'Gagal upload: $e'};
    }
  }

  static Future<Map<String, dynamic>> getPaymentStatus(int paymentId) async {
    try {
      final response = await ApiClient.get('/payments/$paymentId/status');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil status'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    }
  }

  static Future<List<PaymentModel>> getMyPayments() async {
    try {
      final response = await ApiClient.get('/my-payments');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List list = data['data'] ?? [];
        return list.map((e) => PaymentModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
