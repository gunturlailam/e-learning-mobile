import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/quiz_model.dart';
import '../../data/services/package_service.dart';
import '../../utils/app_config.dart';
import '../../data/services/auth_service.dart';

class QuizPage extends StatefulWidget {
  final int packageId;
  final String packageName;

  const QuizPage({super.key, required this.packageId, required this.packageName});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizModel? _quiz;
  bool _isLoading = true;
  Map<String, String> _answers = {};
  bool _submitted = false;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final quiz = await PackageService.getQuiz(widget.packageId);
    if (mounted) {
      setState(() {
        _quiz = quiz;
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadCertificate() async {
    final attemptId = _result?['attempt_id'];
    if (attemptId == null) return;

    final url = '${AppConfig.baseUrl}/certificate/$attemptId';
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal download sertifikat')),
        );
      }
    }
  }

  Future<void> _submitQuiz() async {
    if (_answers.length < (_quiz?.questions.length ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jawab semua soal terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await PackageService.submitQuiz(widget.packageId, _answers);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (result['success'] == true) {
        setState(() {
          _submitted = true;
          _result = result['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal mengirim jawaban'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Quiz: ${widget.packageName}', style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _submitted
              ? _buildResult()
              : _buildQuiz(),
    );
  }

  Widget _buildResult() {
    final passed = _result?['passed'] == true;
    final score = _result?['score'] ?? 0;
    final correct = _result?['correct'] ?? 0;
    final total = _result?['total'] ?? 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.celebration_rounded : Icons.sentiment_dissatisfied_rounded,
              size: 80,
              color: passed ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              passed ? 'Selamat! Anda Lulus! 🎉' : 'Belum Lulus 😔',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: passed ? Colors.green : Colors.orange),
            ),
            const SizedBox(height: 12),
            Text('Skor: $score%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Benar: $correct dari $total soal', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            if (passed) ...[
              ElevatedButton.icon(
                onPressed: () => _downloadCertificate(),
                icon: const Icon(Icons.workspace_premium_rounded),
                label: const Text('Download Sertifikat', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
              child: const Text('Kembali', style: TextStyle(color: Colors.white)),
            ),
            if (!passed) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _submitted = false;
                    _answers = {};
                    _result = null;
                  });
                },
                child: const Text('Coba Lagi'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    if (_quiz == null) {
      return const Center(child: Text('Quiz tidak tersedia'));
    }

    return Column(
      children: [
        // Progress
        LinearProgressIndicator(
          value: _quiz!.questions.isEmpty ? 0 : _answers.length / _quiz!.questions.length,
          backgroundColor: Colors.grey[200],
          color: const Color(0xFF1565C0),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _quiz!.questions.length,
            itemBuilder: (context, index) {
              final q = _quiz!.questions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${q.question}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...q.options.entries.map((entry) {
                      final isSelected = _answers[q.id.toString()] == entry.key;
                      return GestureDetector(
                        onTap: () => setState(() => _answers[q.id.toString()] = entry.key),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1565C0).withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? const Color(0xFF1565C0) : Colors.white,
                                  border: Border.all(color: isSelected ? const Color(0xFF1565C0) : Colors.grey),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${entry.key.toUpperCase()}. ${entry.value}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Submit (${_answers.length}/${_quiz!.questions.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
