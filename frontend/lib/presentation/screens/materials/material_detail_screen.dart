import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../data/models/learning_material_model.dart';
import '../../../presentation/providers/learning_material_provider.dart';
import 'in_app_video_player.dart';
import 'pdf_viewer_screen.dart';

class MaterialDetailScreen extends StatefulWidget {
  final int materialId;

  const MaterialDetailScreen({
    super.key,
    required this.materialId,
  });

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  final Dio _dio = Dio();
  LearningMaterial? _material;
  bool _loading = true;
  bool _pdfReading = false;

  @override
  void initState() {
    super.initState();
    _loadMaterial();
  }

  Future<void> _loadMaterial() async {
    try {
      final provider = context.read<LearningMaterialProvider>();
      final material = provider.materials.firstWhere(
        (m) => m.id == widget.materialId,
      );

      if (mounted) {
        setState(() {
          _material = material;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _readPdf() async {
    final material = _material;
    if (material == null) return;

    final pdfUrl = material.pdfUrl?.isNotEmpty == true 
        ? material.pdfUrl 
        : material.pdf;

    if (pdfUrl == null || pdfUrl.isEmpty) return;

    setState(() => _pdfReading = true);

    try {
      String pdfPath = pdfUrl;
      
      if (pdfUrl.startsWith('http')) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'pdf_${ material.id}.pdf';
        pdfPath = '${tempDir.path}/$fileName';
        await _dio.download(pdfUrl, pdfPath);
      }

      if (!mounted) return;
      
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PdfViewerScreen(
            filePath: pdfPath,
            title: material.title,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal buka PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfReading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_material == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Material')),
        body: const ErrorView(
          message: 'Material tidak ditemukan',
        ),
      );
    }

    final material = _material!;
    final videoUrl = material.videoUrl.isNotEmpty 
        ? material.videoUrl 
        : material.video;
    final hasPdf = material.pdf != null && material.pdf!.isNotEmpty || 
                   material.pdfUrl != null && material.pdfUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(material.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: InAppVideoPlayer(
                key: ValueKey(videoUrl),
                filePath: videoUrl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: AppTextStyles.headlineMedium(context),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      material.kategori,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (material.description != null && material.description!.isNotEmpty) ...[
                    Text('Deskripsi', style: AppTextStyles.titleLarge(context)),
                    const SizedBox(height: 8),
                    Text(material.description!, style: AppTextStyles.bodyMedium(context)),
                    const SizedBox(height: 16),
                  ],
                  if (hasPdf)
                    FilledButton.icon(
                      onPressed: _pdfReading ? null : _readPdf,
                      icon: _pdfReading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf),
                      label: Text(_pdfReading ? 'Loading...' : 'Lihat PDF'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    )
                  else
                    Text(
                      'Tidak ada PDF',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
