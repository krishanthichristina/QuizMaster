import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/auth_provider.dart';

class QuizScreen extends StatefulWidget {
  final String difficulty;
  final String? sessionId;

  const QuizScreen({super.key, required this.difficulty, this.sessionId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<String>? _draggedItems;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);

      if (user != null) {
        quizProvider.startQuizAdaptive(
          userId: user.id,
          sessionId: widget.sessionId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    if (quizProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Auto-submit when time is up
    if (quizProvider.timeSpent >= quizProvider.totalTimeLimit &&
        !quizProvider.isQuizFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        quizProvider.stopTimer();
        if (user != null) quizProvider.submitResult(user.id);
        _showResultDialog(quizProvider, timeout: true);
      });
    }

    if (quizProvider.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('No questions found for this difficulty.'),
        ),
      );
    }

    final question = quizProvider.questions[quizProvider.currentIndex];

    // Initialize dragged items for DRAG_DROP
    if (question.type == 'DRAG_DROP' && _draggedItems == null) {
      _draggedItems = List.from(question.options)..shuffle();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty.toUpperCase()} Quiz'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${quizProvider.timeSpent} / ${quizProvider.totalTimeLimit}s',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: quizProvider.timeSpent >= quizProvider.totalTimeLimit
                      ? Colors.red
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value:
                  (quizProvider.currentIndex + 1) /
                  quizProvider.questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${quizProvider.currentIndex + 1} of ${quizProvider.questions.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(question.difficulty),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        question.difficulty.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${question.marks} Marks',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: question.type == 'DRAG_DROP'
                  ? _buildDragDrop(question)
                  : _buildMultipleChoice(question, quizProvider, user?.id),
            ),
            if (question.type == 'DRAG_DROP')
              ElevatedButton(
                onPressed: () =>
                    _handleDragDropSubmit(quizProvider, question, user?.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Submit Order',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoice(question, quizProvider, userId) {
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        if (question.options[index].isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
            onPressed: () => _handleAnswer(quizProvider, index, userId),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              side: const BorderSide(color: Colors.indigo),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              question.options[index],
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragDrop(question) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = _draggedItems!.removeAt(oldIndex);
          _draggedItems!.insert(newIndex, item);
        });
      },
      children: [
        for (int i = 0; i < _draggedItems!.length; i++)
          if (_draggedItems![i].isNotEmpty)
            Card(
              key: ValueKey(_draggedItems![i]),
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.indigo.shade50,
              child: ListTile(
                leading: const Icon(Icons.drag_handle),
                title: Text(
                  _draggedItems![i],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
      ],
    );
  }

  void _handleAnswer(QuizProvider quizProvider, int index, int? userId) {
    quizProvider.answerQuestion(index);
    _draggedItems = null; // Reset for next question
    if (quizProvider.currentIndex >= quizProvider.questions.length - 1 &&
        quizProvider.isQuizFinished) {
      if (userId != null) quizProvider.submitResult(userId);
      _showResultDialog(quizProvider);
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleDragDropSubmit(QuizProvider quizProvider, question, userId) {
    // For drag-drop, correctIndex is not used; instead we compare orders.
    // However, to reuse existing logic, we'll check if the current order matches the original options order.
    bool isCorrect = true;
    for (int i = 0; i < _draggedItems!.length; i++) {
      if (_draggedItems![i] != question.options[i]) {
        isCorrect = false;
        break;
      }
    }

    // Simulate correctIndex check
    _handleAnswer(quizProvider, isCorrect ? question.correctIndex : -1, userId);
  }

  void _showResultDialog(QuizProvider quizProvider, {bool timeout = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(timeout ? 'Time is Up!' : 'Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Score: ${quizProvider.score}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Correct: ${quizProvider.correctAnswers}/${quizProvider.questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Time: ${quizProvider.timeSpent}s',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
