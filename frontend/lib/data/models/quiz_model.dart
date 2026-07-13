/// Model untuk satu soal quiz
class QuizQuestion {
  final int id;
  final String question;
  final Map<String, String> options; // {'a': '...', 'b': '...', 'c': '...', 'd': '...'}

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final Map<String, String> opts = {};
    if (rawOptions is Map) {
      rawOptions.forEach((k, v) => opts[k.toString()] = v.toString());
    }
    return QuizQuestion(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: opts,
    );
  }
}

/// Model untuk Quiz (termasuk daftar soal)
class QuizModel {
  final int id;
  final String title;
  final String? description;
  final int passingScore;
  final List<QuizQuestion> questions;

  QuizModel({
    required this.id,
    required this.title,
    this.description,
    required this.passingScore,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawQuestions = json['questions'] ?? [];
    return QuizModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      passingScore: json['passing_score'] ?? 70,
      questions: rawQuestions
          .map((q) => QuizQuestion.fromJson(Map<String, dynamic>.from(q as Map)))
          .toList(),
    );
  }
}

/// Model untuk hasil submit quiz
class QuizResult {
  final int attemptId;
  final int score;
  final bool passed;
  final int correct;
  final int total;
  final int passingScore;
  final String message;

  QuizResult({
    required this.attemptId,
    required this.score,
    required this.passed,
    required this.correct,
    required this.total,
    required this.passingScore,
    required this.message,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json, String message) {
    return QuizResult(
      attemptId: json['attempt_id'] ?? 0,
      score: json['score'] ?? 0,
      passed: json['passed'] ?? false,
      correct: json['correct'] ?? 0,
      total: json['total'] ?? 0,
      passingScore: json['passing_score'] ?? 70,
      message: message,
    );
  }
}
