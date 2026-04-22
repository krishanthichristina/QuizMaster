class Result {
  final int? id;
  final int userId;
  final String difficulty;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeSpentSeconds;
  final DateTime? createdAt;
  final String type;

  Result({
    this.id,
    required this.userId,
    required this.difficulty,
    required this.type,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeSpentSeconds,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
  return Result(
    id: json['id'],
    userId: json['userId'],
    difficulty: json['difficulty'] ?? 'easy',
    type: json['type'] ?? 'MCQ',
    score: json['score'] ?? 0,
    totalQuestions: json['totalQuestions'] ?? 0,
    correctAnswers: json['correctAnswers'] ?? 0,
    timeSpentSeconds: json['timeSpentSeconds'] ?? 0,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'difficulty': difficulty,
      'type': type,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeSpentSeconds': timeSpentSeconds,
    };
  }
}
