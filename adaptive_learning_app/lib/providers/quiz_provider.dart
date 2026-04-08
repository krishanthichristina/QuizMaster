import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';
import '../services/api_service.dart';

class QuizProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  bool _isLoading = false;
  String _difficulty = 'easy';
  
  // Timer state
  int _timeSpent = 0;
  Timer? _timer;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  bool get isLoading => _isLoading;
  String get difficulty => _difficulty;
  int get timeSpent => _timeSpent;

  Future<void> startQuiz(String difficulty) async {
    _difficulty = difficulty;
    _isLoading = true;
    _currentIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _timeSpent = 0;
    notifyListeners();

    try {
      _questions = await ApiService.getQuestions(difficulty);
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
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void answerQuestion(int selectedIndex) {
    if (_questions[_currentIndex].correctIndex == selectedIndex) {
      _correctAnswers++;
      // Simple adaptive scoring: harder questions give more points
      int basePoints = _difficulty == 'easy' ? 10 : (_difficulty == 'medium' ? 20 : 30);
      _score += basePoints;
    }
    
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      stopTimer();
    }
    notifyListeners();
  }

  bool get isQuizFinished => _currentIndex >= _questions.length - 1 && _timer?.isActive == false;

  Future<void> submitResult(int userId) async {
    final result = Result(
      userId: userId,
      difficulty: _difficulty,
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
