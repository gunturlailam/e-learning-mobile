import 'package:flutter/material.dart';
import '../../data/models/material_model.dart';
import '../screens/materials/in_app_video_player.dart';

/// MaterialDetailPage - Halaman detail materi dalam paket
/// Sesuai modul Pertemuan 15
class MaterialDetailPage extends StatelessWidget {
  final MaterialModel material;

  const MaterialDetailPage({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          material.title,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Video player
          if (material.videoUrl != null && material.videoUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: InAppVideoPlayer(filePath: material.videoUrl!),
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(Icons.videocam_off, size: 48, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 20),

          // Title
          Text(
            material.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),

          // Kategori badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              material.kategori,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          if (material.description != null &&
              material.description!.isNotEmpty) ...[
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              material.description!,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // PDF button
          if (material.pdfUrl != null && material.pdfUrl!.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () {
                // Buka PDF viewer
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Lihat Materi PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
