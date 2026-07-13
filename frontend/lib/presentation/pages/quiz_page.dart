import 'package:flutter/material.dart';
import '../../data/services/package_service.dart';
import 'certificate_view_page.dart';

class QuizPage extends StatefulWidget {
  final int packageId;
  final String packageName;

  const QuizPage({
    super.key,
    required this.packageId,
    required this.packageName,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  Map<String, dynamic>? _quizData;
  List<Map<String, dynamic>> _questions = [];
  final Map<String, String> _answers = {};

  int _currentIndex = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _purple = Color(0xFF7B1FA2);
  static const _lightPurple = Color(0xFFF3E5F5);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _loadQuiz();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    setState(() => _loading = true);
    final data = await PackageService.getQuiz(widget.packageId);
    if (!mounted) return;
    if (data == null) {
      setState(() {
        _error = 'Quiz tidak ditemukan untuk paket ini.';
        _loading = false;
      });
      return;
    }
    final rawQ = data['questions'] as List? ?? [];
    setState(() {
      _quizData = data;
      _questions = rawQ
          .map((q) => Map<String, dynamic>.from(q as Map))
          .toList();
      _loading = false;
    });
    _animController.forward();
  }

  void _selectAnswer(String questionId, String option) {
    setState(() => _answers[questionId] = option);
  }

  bool get _allAnswered => _questions.every(
      (q) => _answers.containsKey(q['id'].toString()));

  Future<void> _submit() async {
    if (!_allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Jawab semua soal terlebih dahulu!'),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    final result =
        await PackageService.submitQuiz(widget.packageId, _answers);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      _showResultDialog(
        score: data['score'] as int,
        passed: data['passed'] as bool,
        correct: data['correct'] as int,
        total: data['total'] as int,
        passingScore: data['passing_score'] as int,
        message: result['message'] as String? ?? '',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal submit quiz'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showResultDialog({
    required int score,
    required bool passed,
    required int correct,
    required int total,
    required int passingScore,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ResultDialog(
        packageId: widget.packageId,
        packageName: widget.packageName,
        score: score,
        passed: passed,
        correct: correct,
        total: total,
        passingScore: passingScore,
        message: message,
        onRetry: () {
          Navigator.pop(context); // close dialog
          setState(() {
            _answers.clear();
            _currentIndex = 0;
          });
        },
      ),
    );
  }

  void _goToQuestion(int index) {
    if (index < 0 || index >= _questions.length) return;
    _animController.reverse().then((_) {
      setState(() => _currentIndex = index);
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF),
      appBar: AppBar(
        title: Text(widget.packageName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: _loading || _questions.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
      ),
      body: _loading
          ? _buildLoading()
          : _error != null
              ? _buildError()
              : _questions.isEmpty
                  ? _buildEmpty()
                  : _buildQuiz(),
    );
  }

  Widget _buildLoading() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _purple),
            SizedBox(height: 16),
            Text('Memuat soal quiz…',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      );

  Widget _buildError() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 56),
              const SizedBox(height: 16),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 15)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loadQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _purple, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );

  Widget _buildEmpty() => const Center(
        child: Text('Belum ada soal quiz untuk paket ini.',
            style: TextStyle(color: Colors.grey)),
      );

  Widget _buildQuiz() {
    final q = _questions[_currentIndex];
    final qId = q['id'].toString();
    final options = q['options'] as Map<String, dynamic>? ?? {};
    final passingScore = _quizData?['passing_score'] ?? 70;

    return Column(
      children: [
        // Header info
        Container(
          color: _purple,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Soal ${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('Lulus: $passingScore',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Question & options
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Question number dot row
                Row(
                  children: List.generate(_questions.length, (i) {
                    final answered = _answers
                        .containsKey(_questions[i]['id'].toString());
                    final isCurrent = i == _currentIndex;
                    return GestureDetector(
                      onTap: () => _goToQuestion(i),
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent
                              ? _purple
                              : answered
                                  ? const Color(0xFF10B981)
                                  : Colors.white,
                          border:
                              Border.all(color: _purple.withOpacity(0.4)),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                      color: _purple.withOpacity(0.4),
                                      blurRadius: 8)
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: (isCurrent || answered)
                                ? Colors.white
                                : _purple,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Question card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: _purple.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _lightPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${_currentIndex + 1}',
                              style: const TextStyle(
                                  color: _purple,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('Pertanyaan',
                              style: TextStyle(
                                  color: _purple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        q['question'] as String? ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Options
                ...(['a', 'b', 'c', 'd']).map((key) {
                  final optionText = options[key] as String?;
                  if (optionText == null || optionText.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final isSelected = _answers[qId] == key;
                  return GestureDetector(
                    onTap: () => _selectAnswer(qId, key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? _purple : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected ? _purple : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: isSelected
                                  ? _purple.withOpacity(0.25)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: isSelected ? 12 : 4,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.25)
                                  : _lightPurple,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              key.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: isSelected ? Colors.white : _purple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected ? Colors.white : const Color(0xFF1A1A2E),
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 22),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Bottom navigation
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4)),
            ],
          ),
          child: Row(
            children: [
              if (_currentIndex > 0)
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    onPressed: () => _goToQuestion(_currentIndex - 1),
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
                    label: const Text('Sebelumnya'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _purple,
                      side: const BorderSide(color: _purple),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              if (_currentIndex > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _currentIndex < _questions.length - 1
                    ? ElevatedButton.icon(
                        onPressed: () => _goToQuestion(_currentIndex + 1),
                        icon: const Text('Selanjutnya'),
                        label: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _submitting ? null : _submit,
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                            : const Icon(Icons.send_rounded, size: 18),
                        label: Text(_submitting ? 'Mengirim…' : 'Kumpulkan Jawaban'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _allAnswered
                              ? const Color(0xFF10B981)
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── Result Dialog ────────────────────────────────────

class _ResultDialog extends StatelessWidget {
  final int packageId;
  final String packageName;
  final int score;
  final bool passed;
  final int correct;
  final int total;
  final int passingScore;
  final String message;
  final VoidCallback onRetry;

  const _ResultDialog({
    required this.packageId,
    required this.packageName,
    required this.score,
    required this.passed,
    required this.correct,
    required this.total,
    required this.passingScore,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: passed
                    ? [const Color(0xFF10B981), const Color(0xFF059669)]
                    : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    passed
                        ? Icons.emoji_events_rounded
                        : Icons.replay_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  passed ? '🎉 Selamat! Anda Lulus!' : '😅 Belum Lulus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  passed
                      ? 'Sertifikat kelulusan telah diterbitkan!'
                      : 'Pelajari kembali materi dan coba lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Score circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: passed
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      width: 4,
                    ),
                    color: passed
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEF2F2),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: passed
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                      Text(
                        'Skor',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats row
                Row(
                  children: [
                    Expanded(
                        child: _StatItem(
                            label: 'Benar',
                            value: '$correct',
                            color: const Color(0xFF10B981))),
                    Expanded(
                        child: _StatItem(
                            label: 'Salah',
                            value: '${total - correct}',
                            color: const Color(0xFFEF4444))),
                    Expanded(
                        child: _StatItem(
                            label: 'Batas Lulus',
                            value: '$passingScore',
                            color: const Color(0xFFF59E0B))),
                  ],
                ),
                const SizedBox(height: 24),

                // Buttons
                if (passed) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CertificateViewPage(
                              packageId: packageId,
                              packageName: packageName,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.workspace_premium_rounded),
                      label: const Text('Lihat Sertifikat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Kembali ke Materi'),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Kembali ke Materi'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
