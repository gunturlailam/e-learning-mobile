/// Package Model - Paket Kursus
/// Sesuai modul Pertemuan 15
class PackageModel {
  final int id;
  final String name;
  final String displayName;
  final String? description;
  final double price;
  final bool isFree;
  final String? thumbnail;
  final String? thumbnailUrl;
  final String? kategori;
  final int materialsCount;
  final bool hasQuiz;

  PackageModel({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    required this.price,
    required this.isFree,
    this.thumbnail,
    this.thumbnailUrl,
    this.kategori,
    this.materialsCount = 0,
    this.hasQuiz = false,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? json['name'] ?? '',
      description: json['description'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      isFree: json['is_free'] == true || json['is_free'] == 1,
      thumbnail: json['thumbnail'],
      thumbnailUrl: json['thumbnail_url'],
      kategori: json['kategori'],
      materialsCount: json['materials_count'] ?? 0,
      hasQuiz: json['has_quiz'] == true,
    );
  }

  /// Harga terformat: "Gratis" atau "Rp 50.000"
  String get formattedPrice {
    if (isFree || price <= 0) return 'Gratis';
    final intPrice = price.toInt();
    final str = intPrice.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }
}
