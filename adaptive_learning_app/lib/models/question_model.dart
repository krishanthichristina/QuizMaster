class Question {
  final int? id;
  final String title;
  final String difficulty;
  final String type; // MCQ, TF, DRAG_DROP
  final List<String> options;
  final int correctIndex;

  Question({
    this.id,
    required this.title,
    required this.difficulty,
    required this.type,
    required this.options,
    required this.correctIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      difficulty: json['difficulty'],
      type: json['type'] ?? 'MCQ',
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'difficulty': difficulty,
      'type': type,
      'optionA': options.length > 0 ? options[0] : '',
      'optionB': options.length > 1 ? options[1] : '',
      'optionC': options.length > 2 ? options[2] : '',
      'optionD': options.length > 3 ? options[3] : '',
      'correctIndex': correctIndex,
    };
  }
}
