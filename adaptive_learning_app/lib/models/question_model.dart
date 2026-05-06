class Question {
  final int? id;
  final String title;
  final String difficulty;
  final String type; // MCQ, TF, DRAG_DROP
  final List<String> options;
  final int correctIndex;
  final int marks;


  Question({
    this.id,
    required this.title,
    required this.difficulty,
    required this.type,
    required this.options,
    required this.correctIndex,
    required this.marks,

  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      title: json['title'],
      difficulty: json['difficulty'],
      type: json['type'] ?? 'MCQ',
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
      marks: json['marks'] ?? 1,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'difficulty': difficulty,
      'type': type,
      'optionA': options.isNotEmpty ? options[0] : '',
      'optionB': options.length > 1 ? options[1] : '',
      'optionC': options.length > 2 ? options[2] : '',
      'optionD': options.length > 3 ? options[3] : '',
      'correctIndex': correctIndex,
      'marks': marks,

    };
  }
}
