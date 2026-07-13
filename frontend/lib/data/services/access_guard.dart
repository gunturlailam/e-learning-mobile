import 'package:shared_preferences/shared_preferences.dart';
import 'payment_service.dart';

/// AccessGuard - Cek akses user sebelum masuk ke paket
/// Sesuai modul Pertemuan 15
/// Returns: 'granted', 'login_required', 'payment_required'
class AccessGuard {
  static Future<String> checkAccess(String packageName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Cek apakah user sudah login
    if (token == null || token.isEmpty) {
      return 'login_required';
    }

    try {
      // Cek apakah paket sudah dibayar via API
      final payments = await PaymentService.getMyPayments();
      final hasAccess = payments.any((p) => 
        (p.menuName.toLowerCase() == packageName.toLowerCase()) && 
        p.status == 'approved'
      );
      
      if (hasAccess) {
        // Simpan ke local cache agar sinkron
        await grantAccess(packageName);
        return 'granted';
      }
    } catch (e) {
      // Jika offline/error, fallback ke local storage
      final purchasedPackages = prefs.getStringList('purchased_packages') ?? [];
      if (purchasedPackages.contains(packageName)) {
        return 'granted';
      }
    }

    // Belum bayar → perlu pembayaran
    return 'payment_required';
  }

  /// Simpan paket yang sudah dibeli
  static Future<void> grantAccess(String packageName) async {
    final prefs = await SharedPreferences.getInstance();
    final purchased = prefs.getStringList('purchased_packages') ?? [];
    if (!purchased.contains(packageName)) {
      purchased.add(packageName);
      await prefs.setStringList('purchased_packages', purchased);
    }
  }

  /// Hapus akses paket (untuk testing)
  static Future<void> revokeAccess(String packageName) async {
    final prefs = await SharedPreferences.getInstance();
    final purchased = prefs.getStringList('purchased_packages') ?? [];
    purchased.remove(packageName);
    await prefs.setStringList('purchased_packages', purchased);
  }
}
