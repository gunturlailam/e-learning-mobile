class ApiConstants {
  // ⚠️ Ganti sesuai platform yang digunakan:
  // Chrome/Web         → 'http://localhost:8000/api'
  // Emulator Android   → 'http://10.0.2.2:8000/api'
  // Device fisik       → 'http://192.168.x.x:8000/api' (cek ipconfig)
  static const String baseUrl = 'http://localhost:8000/api';

  // Endpoints
  static const String users = '/users';
  static const String topics = '/topics';
  static const String speakingMaterials = '/speaking-materials';
  static const String progress = '/speaking-materials/progress';
}
