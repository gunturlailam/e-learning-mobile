import 'package:flutter/material.dart';

/// QuizPage - Placeholder halaman quiz
/// Sesuai modul Pertemuan 15 (quiz boleh diabaikan)
class QuizPage extends StatelessWidget {
  final int packageId;
  final String packageName;

  const QuizPage({
    super.key,
    required this.packageId,
    required this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(packageName, style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_rounded, size: 72, color: Color(0xFF7B1FA2)),
            SizedBox(height: 16),
            Text(
              'Quiz akan segera tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fitur ini sedang dalam pengembangan',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
