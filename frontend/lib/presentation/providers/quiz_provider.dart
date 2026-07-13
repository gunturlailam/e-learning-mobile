import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';
import '../../data/services/quiz_service.dart';

enum QuizState { idle, loading, loaded, submitting, result, error }

class QuizProvider with ChangeNotifier {
  QuizState _state = QuizState.idle;
  QuizModel? _quiz;
  QuizResult? _result;
  String _error = '';

  /// Jawaban yang dipilih user: {questionId: 'a'/'b'/'c'/'d'}
  final Map<String, String> _answers = {};

  /// Index soal yang sedang ditampilkan
  int _currentIndex = 0;

  // ── Getters ────────────────────────────────────────────
  QuizState get state => _state;
  QuizModel? get quiz => _quiz;
  QuizResult? get result => _result;
  String get error => _error;
  Map<String, String> get answers => Map.unmodifiable(_answers);
  int get currentIndex => _currentIndex;

  bool get isLoading => _state == QuizState.loading;
  bool get isSubmitting => _state == QuizState.submitting;
  bool get hasResult => _state == QuizState.result;

  int get totalQuestions => _quiz?.questions.length ?? 0;
  bool get isLastQuestion => _currentIndex >= totalQuestions - 1;

  QuizQuestion? get currentQuestion =>
      (_quiz != null && _currentIndex < totalQuestions)
          ? _quiz!.questions[_currentIndex]
          : null;

  String? selectedAnswerForCurrent() =>
      currentQuestion != null ? _answers[currentQuestion!.id.toString()] : null;

  bool get allAnswered =>
      _quiz != null && _answers.length == _quiz!.questions.length;

  // ── Actions ────────────────────────────────────────────
  Future<void> loadQuiz(int packageId) async {
    _state = QuizState.loading;
    _error = '';
    _answers.clear();
    _currentIndex = 0;
    _result = null;
    notifyListeners();

    try {
      _quiz = await QuizService.getQuiz(packageId: packageId);
      _state = QuizState.loaded;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _state = QuizState.error;
    }
    notifyListeners();
  }

  void selectAnswer(int questionId, String answer) {
    _answers[questionId.toString()] = answer;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < totalQuestions - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void prevQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<void> submitQuiz(int packageId) async {
    if (_quiz == null) return;
    _state = QuizState.submitting;
    _error = '';
    notifyListeners();

    try {
      _result = await QuizService.submitQuiz(
        packageId: packageId,
        answers: Map<String, String>.from(_answers),
      );
      _state = QuizState.result;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _state = QuizState.loaded;
    }
    notifyListeners();
  }

  void reset() {
    _state = QuizState.idle;
    _quiz = null;
    _result = null;
    _error = '';
    _answers.clear();
    _currentIndex = 0;
    notifyListeners();
  }
}
