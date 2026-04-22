import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/result_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late Future<Map<String, dynamic>> _analyticsFuture;
  late Future<List<Result>> _historyFuture;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _analyticsFuture = ApiService.getAnalytics(user.id);
      _historyFuture = ApiService.getHistory(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: _analyticsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Text('Error loading analytics: ${snapshot.error}');
                final data = snapshot.data!;
                return Row(
                  children: [
                    _buildStatCard('Total Quizzes', data['totalQuizzes'].toString(), Icons.quiz, Colors.blue),
                    _buildStatCard('Average Score', data['averageScore'].toStringAsFixed(1), Icons.show_chart, Colors.green),
                    _buildStatCard('Best Score', data['bestScore'].toString(), Icons.star, Colors.orange),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Accuracy % by Difficulty', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 16),
            FutureBuilder<List<Result>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox(height: 200, child: Center(child: Text('No data yet.')));
                
                final history = snapshot.data!;
                final difficultyStats = _calculateDifficultyStats(history);
                
                return AspectRatio(
                  aspectRatio: 1.3,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barGroups: [
                        _makeBarGroup(0, difficultyStats['easy']!, Colors.green, 'Easy'),
                        _makeBarGroup(1, difficultyStats['medium']!, Colors.orange, 'Med'),
                        _makeBarGroup(2, difficultyStats['hard']!, Colors.red, 'Hard'),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
                              switch (value.toInt()) {
                                case 0: return const Text('Easy', style: style);
                                case 1: return const Text('Medium', style: style);
                                case 2: return const Text('Hard', style: style);
                                default: return const Text('');
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Quiz History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 16),
            FutureBuilder<List<Result>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text('No quiz history yet.');
                final history = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final result = history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getDifficultyColor(result.difficulty).withOpacity(0.1),
                          child: Text(result.difficulty[0].toUpperCase(), style: TextStyle(color: _getDifficultyColor(result.difficulty), fontWeight: FontWeight.bold)),
                        ),
                        title: Text('Score: ${result.score} points'),
                        subtitle: Text('${result.correctAnswers}/${result.totalQuestions} correct (${((result.correctAnswers/result.totalQuestions)*100).toStringAsFixed(0)}%)'),
                        trailing: Text(result.createdAt != null ? '${result.createdAt!.day}/${result.createdAt!.month}' : ''),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculateDifficultyStats(List<Result> history) {
    Map<String, List<double>> raw = {'easy': [], 'medium': [], 'hard': []};
    for (var r in history) {
      raw[r.difficulty.toLowerCase()]?.add((r.correctAnswers / r.totalQuestions) * 100);
    }
    return raw.map((k, v) => MapEntry(k, v.isEmpty ? 0.0 : v.reduce((a, b) => a + b) / v.length));
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color, String label) {
    return BarChartGroupData(x: x, barRods: [BarChartRodData(toY: y, color: color, width: 22, borderRadius: BorderRadius.circular(4))]);
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy': return Colors.green;
      case 'medium': return Colors.orange;
      case 'hard': return Colors.red;
      default: return Colors.indigo;
    }
  }
}
