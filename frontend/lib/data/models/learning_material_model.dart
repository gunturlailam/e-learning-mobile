/// Learning Material Model
class LearningMaterial {
  final int id;
  final String title;
  final String? description;
  final String kategori;
  final String video;
  final String? pdf;
  final String videoUrl;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearningMaterial({
    required this.id,
    required this.title,
    this.description,
    required this.kategori,
    required this.video,
    this.pdf,
    required this.videoUrl,
    this.pdfUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor dari JSON API response
  factory LearningMaterial.fromJson(Map<String, dynamic> json) {
    return LearningMaterial(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      kategori: json['kategori'] ?? '',
      video: json['video'] ?? '',
      pdf: json['pdf'],
      videoUrl: json['video_url'] ?? '',
      pdfUrl: json['pdf_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  /// Convert ke JSON untuk API request
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'kategori': kategori,
      'video': video,
      'pdf': pdf,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Copy with untuk membuat instance baru dengan perubahan
  LearningMaterial copyWith({
    int? id,
    String? title,
    String? description,
    String? kategori,
    String? video,
    String? pdf,
    String? videoUrl,
    String? pdfUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningMaterial(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      kategori: kategori ?? this.kategori,
      video: video ?? this.video,
      pdf: pdf ?? this.pdf,
      videoUrl: videoUrl ?? this.videoUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
