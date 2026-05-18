class SpeakingMaterialModel {
  final int id;
  final String title;
  final String? description;
  final String video;
  final String? pdf;
  final String? videoUrl;
  final String? pdfUrl;
  final String? createdAt;

  SpeakingMaterialModel({
    required this.id,
    required this.title,
    this.description,
    required this.video,
    this.pdf,
    this.videoUrl,
    this.pdfUrl,
    this.createdAt,
  });

  factory SpeakingMaterialModel.fromJson(Map<String, dynamic> json) {
    return SpeakingMaterialModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      video: json['video'] ?? '',
      pdf: json['pdf'],
      videoUrl: json['video_url'],
      pdfUrl: json['pdf_url'],
      createdAt: json['created_at'],
    );
  }
}
