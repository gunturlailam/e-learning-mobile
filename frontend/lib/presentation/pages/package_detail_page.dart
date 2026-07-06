import 'package:flutter/material.dart';
import '../../data/models/material_model.dart';
import '../../data/services/package_service.dart';
import '../widgets/material_card.dart';
import 'material_detail_page.dart';
import 'quiz_page.dart';

/// PackageDetailPage - Halaman detail paket kursus
/// Sesuai modul Pertemuan 15
class PackageDetailPage extends StatefulWidget {
  final int packageId;
  final String packageName;

  const PackageDetailPage({
    super.key,
    required this.packageId,
    required this.packageName,
  });

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  List<MaterialModel> _materials = [];
  bool _isLoading = true;
  String? _error;
  bool _hasQuiz = false;
  String? _quizTitle;

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  Future<void> _loadPackage() async {
    final data = await PackageService.getPackageDetail(widget.packageId);
    if (mounted) {
      if (data != null) {
        final List materialsList = data['materials'] ?? [];
        setState(() {
          _materials =
              materialsList.map((e) => MaterialModel.fromJson(e)).toList();
          _hasQuiz = data['has_quiz'] == true;
          _quizTitle = data['quiz_title'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Gagal memuat paket';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.packageName,
            style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF1565C0)))
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.grey)))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Materials list
        if (_materials.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Text('Belum ada materi',
                  style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ..._materials.map((material) => MaterialCard(
                material: material,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MaterialDetailPage(material: material),
                      ));
                },
              )),

        // Quiz button
        if (_hasQuiz) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.quiz_rounded,
                        color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Text('Quiz Akhir',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _quizTitle ?? 'Kerjakan quiz untuk menyelesaikan paket ini',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              packageId: widget.packageId,
                              packageName: widget.packageName,
                            ),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7B1FA2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Mulai Quiz',
                        style:
                            TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
