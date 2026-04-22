import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';
import '../services/api_service.dart';

class QuizProvider with ChangeNotifier {
  /// Selects adaptive questions based on user's past results.
  /// Prioritizes weakest topics and increases difficulty gradually.
  List<Question> selectAdaptiveQuestions({
    required List<Question> allQuestions,
    required List<Result> userResults,
    int numQuestions = 10,
  }) {
    // Group results by topic (using question type as topic proxy)
    final Map<String, List<Result>> resultsByTopic = {};
    for (var result in userResults) {
      resultsByTopic.putIfAbsent(result.type, () => []).add(result);
    }
    // 🛑 SAFETY CHECK (IMPORTANT)
if (resultsByTopic.isEmpty) {
  return allQuestions.take(numQuestions).toList();
}

    // Calculate average score per topic
    final topicScores = resultsByTopic.map((topic, results) {
  final accuracy = results.isNotEmpty
      ? results.where((r) => r.correctAnswers > 0).length / results.length
      : 0.0;

  return MapEntry(topic, accuracy);
});

    // Sort topics by weakest (lowest average score) first
    final sortedTopics = topicScores.keys.toList()
      ..sort((a, b) => topicScores[a]!.compareTo(topicScores[b]!));

    List<Question> selected = [];
    for (var topic in sortedTopics) {
      final topicResults = resultsByTopic[topic]!;
      // Estimate comfort difficulty as most frequent difficulty in past results
      final difficultyCounts = <String, int>{};
      for (var r in topicResults) {
        difficultyCounts[r.difficulty] =
            (difficultyCounts[r.difficulty] ?? 0) + 1;
      }
      String comfortDifficulty = difficultyCounts.entries.isNotEmpty
          ? (difficultyCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))[0]
              .key
          : 'easy';

      // Define difficulty progression order
      final difficulties = ['easy', 'medium', 'hard'];
      int comfortIdx = difficulties.indexOf(comfortDifficulty);
      int targetIdx = (comfortIdx + 1).clamp(0, difficulties.length - 1);
      String targetDifficulty = difficulties[targetIdx];

      // Select questions from this topic and target difficulty
      final candidates = allQuestions.where((q) =>
    q.type.toLowerCase() == topic.toLowerCase() &&
    (q.difficulty.toLowerCase() == targetDifficulty.toLowerCase() ||
     q.difficulty.toLowerCase() == comfortDifficulty.toLowerCase())
).toList();
      candidates.shuffle();
      selected.addAll(candidates.take(numQuestions - selected.length));
      if (selected.length >= numQuestions) break;
    }

    // Fill up with random questions if needed
    if (selected.length < numQuestions) {
      final remaining =
          allQuestions.where((q) => !selected.contains(q)).toList()..shuffle();
      selected.addAll(remaining.take(numQuestions - selected.length));
    }

    return selected.take(numQuestions).toList();
  }

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  bool _isLoading = false;
  String _difficulty = 'easy';

  // Timer state
  int _timeSpent = 0;
  int _totalTimeLimit = 60; // Default 60 seconds
  Timer? _timer;

  int get totalTimeLimit => _totalTimeLimit;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  bool get isLoading => _isLoading;
  String get difficulty => _difficulty;
  int get timeSpent => _timeSpent;

  Future<void> startQuizAdaptive({required int userId, int numQuestions = 10}) async {
  _isLoading = true;
  _currentIndex = 0;
  _score = 0;
  _correctAnswers = 0;
  _timeSpent = 0;

  notifyListeners();

  try {
    // 1. Get adaptive difficulty from backend
    final nextDifficulty = await ApiService.getNextDifficulty(userId);

    _difficulty = nextDifficulty;

    // 2. Load only that difficulty questions
    final questions = await ApiService.getQuestions(nextDifficulty);

    _questions = questions.take(numQuestions).toList();

    if (_questions.isNotEmpty) {
      _totalTimeLimit = _questions[0].timeLimit;
    }

    startTimer();
  } catch (e) {
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeSpent++;
      if (_timeSpent >= _totalTimeLimit) {
        stopTimer();
        // Auto-submit logic can be triggered from UI when time ends
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void answerQuestion(int selectedIndex) {
    if (_questions[_currentIndex].correctIndex == selectedIndex) {
      _correctAnswers++;
      // Use marks set by lecturer
      _score += _questions[_currentIndex].marks;
    }

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      stopTimer();
    }
    notifyListeners();
  }

  bool get isQuizFinished =>
      _currentIndex >= _questions.length - 1 && _timer?.isActive == false;

  Future<void> submitResult(int userId) async {
  final result = Result(
    userId: userId,
    difficulty: _difficulty,
    type: _questions.isNotEmpty ? _questions[0].type : 'MCQ',
    score: _score,
    totalQuestions: _questions.length,
    correctAnswers: _correctAnswers,
    timeSpentSeconds: _timeSpent,
  );

  await ApiService.saveResult(result);
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
