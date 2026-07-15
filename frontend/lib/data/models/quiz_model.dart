class QuizModel {
  final int id;
  final String title;
  final String? description;
  final int passingScore;
  final List<QuizQuestionModel> questions;

  QuizModel({
    required this.id,
    required this.title,
    this.description,
    required this.passingScore,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final List questionsList = json['questions'] ?? [];
    return QuizModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      passingScore: json['passing_score'] ?? 70,
      questions: questionsList.map((q) => QuizQuestionModel.fromJson(q)).toList(),
    );
  }
}

class QuizQuestionModel {
  final int id;
  final String question;
  final Map<String, String> options;

  QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final opts = json['options'] as Map<String, dynamic>? ?? {};
    return QuizQuestionModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: opts.map((k, v) => MapEntry(k, v.toString())),
    );
  }
}

// Backward compatibility for existing codebase using QuizQuestion
typedef QuizQuestion = QuizQuestionModel;


// Backward compatibility for existing codebase using QuizResult
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

