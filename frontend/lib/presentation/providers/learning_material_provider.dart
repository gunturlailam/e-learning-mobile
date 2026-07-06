import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/models/learning_material_model.dart';
import '../../data/services/learning_material_service.dart';

/// Provider untuk Learning Material state management
class LearningMaterialProvider with ChangeNotifier {
  final Dio _dio;
  late LearningMaterialService _service;

  // State variables
  List<LearningMaterial> _materials = [];
  List<LearningMaterial> _filteredMaterials = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';

  // Getters
  List<LearningMaterial> get materials => _materials;
  List<LearningMaterial> get filteredMaterials => _filteredMaterials;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error ?? '';
  String get selectedCategory => _selectedCategory;

  LearningMaterialProvider(this._dio) {
    _service = LearningMaterialService(_dio);
  }

  /// Load semua materials
  Future<void> loadMaterials() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _materials = await _service.getAllMaterials();
      _extractCategories();
      _filteredMaterials = _materials;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _materials = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load materials berdasarkan kategori
  Future<void> loadMaterialsByCategory(String kategori) async {
    _isLoading = true;
    _error = null;
    _selectedCategory = kategori;
    notifyListeners();

    try {
      if (kategori == 'All') {
        _filteredMaterials = _materials;
      } else {
        _filteredMaterials = await _service.getMaterialsByCategory(kategori);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _filteredMaterials = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search materials berdasarkan title
  void searchMaterials(String query) {
    if (query.isEmpty) {
      _filteredMaterials = _materials;
    } else {
      _filteredMaterials = _materials
          .where((material) =>
              material.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// Upload material baru
  Future<void> uploadMaterial({
    required String title,
    required String kategori,
    required String videoPath,
    String? pdfPath,
    String? description,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newMaterial = await _service.uploadMaterial(
        title: title,
        kategori: kategori,
        videoPath: videoPath,
        pdfPath: pdfPath,
        description: description,
      );

      _materials.add(newMaterial);
      _extractCategories();
      _filteredMaterials = _materials;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save progress
  Future<void> saveProgress({
    required int materialId,
    required int progress,
    required int userId,
  }) async {
    try {
      await _service.saveProgress(
        materialId: materialId,
        progress: progress,
        userId: userId,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Extract unique categories dari materials
  void _extractCategories() {
    _categories = ['All'];
    final uniqueCategories = <String>{};
    for (var material in _materials) {
      uniqueCategories.add(material.kategori);
    }
    _categories.addAll(uniqueCategories.toList()..sort());
  }

  /// Reset error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadMaterials();
  }
}
