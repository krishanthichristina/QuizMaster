import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart';


class QuizStartScreen extends StatefulWidget {
  final String sessionId;

  const QuizStartScreen({super.key, required this.sessionId});

  @override
  State<QuizStartScreen> createState() => _QuizStartScreenState();
}

class _QuizStartScreenState extends State<QuizStartScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startQuiz(context);
    });
  }

  Future<void> startQuiz(BuildContext context) async {
    try {
      final data = await ApiService.getSession(widget.sessionId);

      if (data == null || data['difficulty'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Session not found")),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            difficulty: data['difficulty'],
            sessionId: widget.sessionId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load session")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}