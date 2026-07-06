import '../../core/constants/api_constants.dart';

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
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      video: json['video']?.toString() ?? '',
      pdf: json['pdf']?.toString(),
      videoUrl: json['video_url']?.toString(),
      pdfUrl: json['pdf_url']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  /// URL video — path di-encode (nama file bisa ada spasi).
  String? get playableVideoUrl {
    if (video.isNotEmpty) return _buildFileUrl(video);
    return _normalizeUrl(videoUrl);
  }

  String? get downloadablePdfUrl {
    if (pdf != null && pdf!.isNotEmpty) return _buildFileUrl(pdf!);
    return _normalizeUrl(pdfUrl);
  }

  bool get hasPdf => downloadablePdfUrl != null;

  static String _buildFileUrl(String relativePath) {
    final base = ApiConstants.serverOrigin.replaceAll(RegExp(r'/+$'), '');
    var clean = relativePath.replaceAll(r'\', '/');
    if (clean.startsWith('/')) clean = clean.substring(1);
    if (!clean.startsWith('storage/')) clean = 'storage/$clean';
    final encoded =
        clean.split('/').map((s) => Uri.encodeComponent(s)).join('/');
    return '$base/$encoded';
  }

  static String? _normalizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final origin = ApiConstants.serverOrigin;
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    Uri fixed = uri;
    if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
      final server = Uri.parse(origin);
      fixed = uri.replace(
        scheme: server.scheme,
        host: server.host,
        port: server.hasPort ? server.port : uri.port,
      );
    }

    if (fixed.path.contains(' ')) {
      final path = fixed.path.startsWith('/') ? fixed.path.substring(1) : fixed.path;
      if (path.startsWith('storage/')) {
        return _buildFileUrl(path.substring('storage/'.length));
      }
    }
    return fixed.toString();
  }
}
