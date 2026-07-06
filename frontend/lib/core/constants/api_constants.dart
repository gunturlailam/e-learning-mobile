/// URL backend Laravel.
///
/// **Penting:** isi ini dengan IP/hostname **komputer yang menjalankan**
/// `php artisan serve` (atau Apache/Nginx), **bukan** IP HP Android.
/// HP hanya memanggil API ke alamat itu lewat WiFi / hotspot yang sama.
///
/// Cek IP laptop: jalankan `ipconfig` → lihat IPv4 adapter Wi-Fi.
///
/// Ganti URL saat jalan tanpa edit file:
/// `flutter run --dart-define=API_BASE_URL=http://192.168.43.157:9000/api`
///
/// Emulator Android → host PC: `http://10.0.2.2:9000/api`
class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.43.157:8000/api',
  );

  // Auth & User endpoints
  static const String users = '/users';
  static const String login = '/login';
  static const String register = '/register';
  
  // Topic endpoints
  static const String topics = '/topics';
  
  // Learning Materials endpoints
  static const String learningMaterials = '/learning-materials';
  static const String learningMaterialsByCategory = '/learning-materials/category';
  static const String learningMaterialsProgress = '/learning-materials/progress';

  // Package (Paket Kursus) endpoints
  static const String packages = '/packages';
  
  // Legacy Speaking Materials (deprecated)
  static const String speakingMaterials = '/speaking-materials';
  static const String progress = '/speaking-materials/progress';

  /// Origin server tanpa `/api` — untuk file storage (video/pdf).
  static String get serverOrigin {
    if (baseUrl.endsWith('/api')) {
      return baseUrl.substring(0, baseUrl.length - 4);
    }
    return baseUrl;
  }
}
