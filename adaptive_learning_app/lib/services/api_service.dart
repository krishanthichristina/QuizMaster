import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.143.105.128:8080/api';

  // Auth
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<User> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Questions
  static Future<List<Question>> getQuestions(String difficulty) async {
    final response = await http.get(Uri.parse('$baseUrl/questions?difficulty=$difficulty'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Question.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<List<Question>> createQuestion(Question question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/questions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(question.toJson()),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body); // always parse as list
      return body.map((dynamic item) => Question.fromJson(item)).toList();
    } else {
      throw Exception('Failed to create question: ${response.body}');
    }
  }

  static Future<String> getNextDifficulty(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/next-difficulty/$userId'),
    );

    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception('Failed to get next difficulty');
    }
  }
  // Results
  static Future<Result> saveResult(Result result) async {
    final response = await http.post(
      Uri.parse('$baseUrl/results'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(result.toJson()),
    );

    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save result');
    }
  }

  static Future<List<Result>> getHistory(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/results/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Result.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  static Future<Map<String, dynamic>> getAnalytics(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/analytics/user/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load analytics');
    }
  }

  static Future<Map<String, dynamic>> getSession(String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/session/$sessionId'),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Invalid session response');
    }

  }
  static Future<List<dynamic>> getAllStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/users/students'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load students');
    }
  }
}
