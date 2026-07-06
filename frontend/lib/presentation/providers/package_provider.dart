import 'package:flutter/material.dart';
import '../../data/models/package_model.dart';
import '../../data/services/package_service.dart';

/// Provider untuk Package state management
/// Sesuai modul Pertemuan 15 - PackageService sekarang static
class PackageProvider with ChangeNotifier {
  List<PackageModel> _packages = [];
  bool _isLoading = false;
  String? _error;

  List<PackageModel> get packages => _packages;
  bool get isLoading => _isLoading;
  String get error => _error ?? '';
  bool get hasError => _error != null;

  PackageProvider();

  Future<void> loadPackages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _packages = await PackageService.getPackages();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _packages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadPackages();

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
