import 'package_model.dart';

/// Model untuk menyimpan informasi Sertifikat Kelulusan
class CertificateModel {
  final int id;
  final int userId;
  final int packageId;
  final String certificateCode;
  final DateTime issuedAt;
  final PackageModel? package;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.certificateCode,
    required this.issuedAt,
    this.package,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      packageId: json['package_id'] ?? 0,
      certificateCode: json['certificate_code'] ?? '',
      issuedAt: json['issued_at'] != null
          ? DateTime.tryParse(json['issued_at']) ?? DateTime.now()
          : DateTime.now(),
      package: json['package'] != null
          ? PackageModel.fromJson(Map<String, dynamic>.from(json['package']))
          : null,
    );
  }

  /// Format tanggal: 13 Juli 2026
  String get formattedIssuedDate {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${issuedAt.day} ${months[issuedAt.month]} ${issuedAt.year}';
  }
}
