import 'package:flutter/material.dart';
import '../../data/models/certificate_model.dart';
import '../../data/services/certificate_service.dart';

class CertificateProvider with ChangeNotifier {
  List<CertificateModel> _certificates = [];
  bool _isLoading = false;
  String _error = '';

  // ── Getters ────────────────────────────────────────────
  List<CertificateModel> get certificates => _certificates;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isEmpty => _certificates.isEmpty;

  // ── Actions ────────────────────────────────────────────
  Future<void> loadCertificates() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _certificates = await CertificateService.getMyCertificates();
      _error = '';
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _certificates = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadCertificates();

  void clear() {
    _certificates = [];
    _error = '';
    _isLoading = false;
    notifyListeners();
  }
}
