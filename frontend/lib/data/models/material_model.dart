/// Material Model - untuk dipakai di PackageDetailPage
/// Sesuai modul Pertemuan 15
class MaterialModel {
  final int id;
  final String title;
  final String? description;
  final String kategori;
  final String? video;
  final String? pdf;
  final String? videoUrl;
  final String? pdfUrl;

  MaterialModel({
    required this.id,
    required this.title,
    this.description,
    required this.kategori,
    this.video,
    this.pdf,
    this.videoUrl,
    this.pdfUrl,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      kategori: json['kategori'] ?? '',
      video: json['video'],
      pdf: json['pdf'],
      videoUrl: json['video_url'],
      pdfUrl: json['pdf_url'],
    );
  }
}
