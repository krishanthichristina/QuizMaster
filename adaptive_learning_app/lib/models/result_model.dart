class Result {
  final int? id;
  final int userId;
  final String difficulty;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeSpentSeconds;
  final DateTime? createdAt;

  Result({
    this.id,
    required this.userId,
    required this.difficulty,
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
      difficulty: json['difficulty'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      timeSpentSeconds: json['timeSpentSeconds'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'difficulty': difficulty,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeSpentSeconds': timeSpentSeconds,
    };
  }
}
