import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/quiz_model.dart';
import '../../providers/quiz_provider.dart';
import '../profile/certificate_screen.dart';

/// Quiz Screen — ditampilkan setelah user beli paket
class QuizScreen extends StatefulWidget {
  final int packageId;
  final String packageName;

  const QuizScreen({
    super.key,
    required this.packageId,
    required this.packageName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().loadQuiz(widget.packageId);
      _animCtrl.forward();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<QuizProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return _buildLoading();
          if (provider.state == QuizState.error) return _buildError(provider);
          if (provider.hasResult) return _buildResult(provider);
          if (provider.quiz == null) return _buildLoading();
          return _buildQuiz(provider);
        },
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Memuat soal quiz...',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────

  Widget _buildError(QuizProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.packageName),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline_rounded,
                    size: 64, color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text('Gagal Memuat Quiz',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(provider.error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => provider.loadQuiz(widget.packageId),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Quiz Questions ─────────────────────────────────────────────────────────

  Widget _buildQuiz(QuizProvider provider) {
    final q = provider.currentQuestion!;
    final quiz = provider.quiz!;
    final progress = (provider.currentIndex + 1) / provider.totalQuestions;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                provider.reset();
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(quiz.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          'Soal ${provider.currentIndex + 1} dari ${provider.totalQuestions}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Soal + Pilihan
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Soal
                _buildQuestionCard(q, provider.currentIndex, isDark),
                const SizedBox(height: 20),
                // Pilihan jawaban
                ...q.options.entries.map(
                  (e) => _buildOptionTile(
                    key: e.key,
                    value: e.value,
                    selected: provider.selectedAnswerForCurrent() == e.key,
                    questionId: q.id,
                    provider: provider,
                  ),
                ),
                const SizedBox(height: 24),
                // Navigator soal (dots)
                _buildQuestionDots(provider),
                const SizedBox(height: 24),
                // Nav buttons
                _buildNavButtons(provider),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion q, int index, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Pertanyaan ${index + 1}',
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            q.question,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String key,
    required String value,
    required bool selected,
    required int questionId,
    required QuizProvider provider,
  }) {
    const labels = {'a': 'A', 'b': 'B', 'c': 'C', 'd': 'D'};
    return GestureDetector(
      onTap: () => provider.selectAnswer(questionId, key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF4F46E5)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF4F46E5)
                : Theme.of(context).dividerColor.withOpacity(0.4),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF4F46E5).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[key] ?? key.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: selected ? Colors.white : const Color(0xFF4F46E5),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionDots(QuizProvider provider) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(provider.totalQuestions, (i) {
        final answered = provider.answers
            .containsKey(provider.quiz!.questions[i].id.toString());
        final isCurrent = i == provider.currentIndex;
        return GestureDetector(
          onTap: () => provider.goToQuestion(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCurrent
                  ? const Color(0xFF4F46E5)
                  : answered
                      ? const Color(0xFF10B981)
                      : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFF4F46E5)
                    : answered
                        ? const Color(0xFF10B981)
                        : Theme.of(context).dividerColor.withOpacity(0.4),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: (isCurrent || answered)
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavButtons(QuizProvider provider) {
    final canSubmit = provider.allAnswered;

    return Column(
      children: [
        Row(
          children: [
            if (provider.currentIndex > 0) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: provider.prevQuestion,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Sebelumnya'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4F46E5),
                    side: const BorderSide(color: Color(0xFF4F46E5)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: provider.isLastQuestion
                  ? ElevatedButton.icon(
                      onPressed: canSubmit
                          ? () => _confirmSubmit(provider)
                          : null,
                      icon: provider.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text(
                          provider.isSubmitting ? 'Mengirim...' : 'Submit Quiz'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSubmit
                            ? const Color(0xFF10B981)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: provider.nextQuestion,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Selanjutnya'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
            ),
          ],
        ),
        if (!canSubmit && provider.isLastQuestion) ...[
          const SizedBox(height: 8),
          Text(
            'Jawab semua soal sebelum submit (${provider.answers.length}/${provider.totalQuestions} terjawab)',
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmSubmit(QuizProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Submit Quiz?'),
        content: Text(
            'Kamu telah menjawab ${provider.answers.length} dari ${provider.totalQuestions} soal. Yakin ingin submit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white),
            child: const Text('Ya, Submit'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await provider.submitQuiz(widget.packageId);
    }
  }

  // ── Result ─────────────────────────────────────────────────────────────────

  Widget _buildResult(QuizProvider provider) {
    final result = provider.result!;
    final passed = result.passed;
    final color = passed ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final icon = passed ? Icons.emoji_events_rounded : Icons.refresh_rounded;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: passed
                ? [const Color(0xFF059669), const Color(0xFF10B981)]
                : [const Color(0xFFDC2626), const Color(0xFFEF4444)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Icon result
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 72, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  passed ? '🎉 Selamat! Kamu Lulus!' : '😔 Belum Lulus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  result.message.isNotEmpty
                      ? result.message
                      : (passed ? 'Hasil quiz kamu memuaskan!' : 'Coba lagi ya!'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Score card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _resultStatRow(
                        'Nilai Kamu',
                        '${result.score}',
                        Icons.grade_rounded,
                        color,
                        large: true,
                      ),
                      const Divider(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: _resultStatItem(
                              'Benar',
                              '${result.correct}',
                              const Color(0xFF10B981),
                              Icons.check_circle_rounded,
                            ),
                          ),
                          Container(
                              width: 1, height: 60, color: Colors.grey.shade200),
                          Expanded(
                            child: _resultStatItem(
                              'Salah',
                              '${result.total - result.correct}',
                              const Color(0xFFEF4444),
                              Icons.cancel_rounded,
                            ),
                          ),
                          Container(
                              width: 1, height: 60, color: Colors.grey.shade200),
                          Expanded(
                            child: _resultStatItem(
                              'Minimum',
                              '${result.passingScore}',
                              const Color(0xFFF59E0B),
                              Icons.flag_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress bar skor
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Progress Nilai',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text('${result.score}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: result.score / 100,
                              backgroundColor: Colors.grey.shade100,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(color),
                              minHeight: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Tombol aksi
                if (passed) ...[
                  _actionBtn(
                    label: 'Lihat Sertifikat Saya',
                    icon: Icons.workspace_premium_rounded,
                    color: Colors.white,
                    textColor: color,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CertificateScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                _actionBtn(
                  label: 'Kembali ke Paket',
                  icon: Icons.arrow_back_rounded,
                  color: Colors.white.withOpacity(0.2),
                  textColor: Colors.white,
                  onTap: () {
                    provider.reset();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultStatRow(String label, String value, IconData icon, Color color,
      {bool large = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: large ? 28 : 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
              large ? '$value / 100' : value,
              style: TextStyle(
                fontSize: large ? 28 : 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultStatItem(
      String label, String value, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
