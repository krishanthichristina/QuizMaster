import 'package:adaptive_learning_app/screens/qr_generate_screen.dart';
import 'package:adaptive_learning_app/screens/quiz_start_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart';
import 'analytics_screen.dart';
import 'create_quiz_screen.dart';
import 'student_list_screen.dart';
import 'package:adaptive_learning_app/screens/qr_scan_screen.dart';
import '../utils/session_store.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive LMS'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (!auth.isLecturer)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // This will trigger a rebuild and refetch the FutureBuilder
                (context as Element).markNeedsBuild();
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: auth.isLecturer ? _buildLecturerDashboard(context, user?.name) : _buildStudentDashboard(context, user?.name),
    );
  }

  Widget _buildLecturerDashboard(BuildContext context, String? name) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Hello, Lecturer ${name ?? ''}!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const Text('Manage your course content and student performance.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 30),
          _buildActionCard(
            context,
            'Create New Question',
            'Add MCQ, T/F, or Drag & Drop questions',
            Icons.add_circle_outline,
            Colors.indigo,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateQuestionScreen())),
          ),
          _buildActionCard(
            context,
            'View Student Analytics',
            'Monitor overall student progress',
            Icons.analytics_outlined,
            Colors.green,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentListScreen()),
            ),
          ),
          _buildActionCard(
            context,
            'Generate QR Session',
            'Create quiz session QR',
            Icons.qr_code,
            Colors.blue,
                () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QRGenerateScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDashboard(BuildContext context, String? name) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Text(
            'Hello, ${name ?? 'Learner'}!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),

          const Text(
            'Ready to challenge yourself today?',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),

          const SizedBox(height: 30),

          _buildDifficultyCard(context, 'Easy', 'Perfect for beginners',
              Icons.sentiment_satisfied, Colors.green),
          _buildDifficultyCard(context, 'Medium', 'Test your intermediate skills',
              Icons.sentiment_neutral, Colors.orange),
            _buildDifficultyCard(context, 'Hard', 'Only for the experts!',
              Icons.sentiment_very_dissatisfied, Colors.red),
            _buildDifficultyCard(context, 'Adaptive', 'Adaptive to your level',
              Icons.autorenew, Colors.purple),

          const SizedBox(height: 20),

          FutureBuilder<List<dynamic>>(
            future: ApiService.getActiveSessions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox();
              }

              // Always show the last activated session if multiple exist
              final session = snapshot.data!.last;
              final sessionId = session['sessionId'];

              return Column(
                children: [
                  const Text(
                    'Active Quiz Session',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(height: 15),

                  QrImageView(
                    data: "http://192.168.2:8080/api/session/$sessionId",
                    size: 200,
                  ),

                  const SizedBox(height: 10),

                  Text('Session ID: $sessionId'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizStartScreen(sessionId: sessionId),
                        ),
                      );
                    },
                    child: const Text("Join Active Session"),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QRScanScreen()),
                );
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR to Join Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              ),
              icon: const Icon(Icons.bar_chart),
              label: const Text('View My Performance'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(BuildContext context, String level, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(difficulty: level.toLowerCase()))),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(level, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
