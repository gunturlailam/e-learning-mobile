import 'package:dio/dio.dart';
import '../models/learning_material_model.dart';
import '../../core/constants/api_constants.dart';

/// Service untuk handle Learning Material API calls
class LearningMaterialService {
  final Dio _dio;

  LearningMaterialService(this._dio);

  /// Get semua learning materials
  Future<List<LearningMaterial>> getAllMaterials() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/learning-materials',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => LearningMaterial.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load materials');
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }

  /// Get materials berdasarkan kategori
  Future<List<LearningMaterial>> getMaterialsByCategory(String kategori) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/learning-materials/category/$kategori',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => LearningMaterial.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load materials by category');
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }

  /// Upload learning material
  Future<LearningMaterial> uploadMaterial({
    required String title,
    required String kategori,
    required String videoPath,
    String? pdfPath,
    String? description,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'kategori': kategori,
        'description': description ?? '',
        'video': await MultipartFile.fromFile(videoPath),
        if (pdfPath != null) 'pdf': await MultipartFile.fromFile(pdfPath),
      });

      final response = await _dio.post(
        '${ApiConstants.baseUrl}/learning-materials',
        data: formData,
      );

      if (response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        return LearningMaterial.fromJson(data);
      }
      throw Exception('Failed to upload material');
    } on DioException catch (e) {
      throw Exception('Upload error: ${e.message}');
    }
  }

  /// Save progress untuk material
  Future<void> saveProgress({
    required int materialId,
    required int progress,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/learning-materials/progress',
        data: {
          'material_id': materialId,
          'progress': progress,
          'user_id': userId,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save progress');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }
}
