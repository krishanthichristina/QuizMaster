import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/session_store.dart';

class QRGenerateScreen extends StatefulWidget {
  const QRGenerateScreen({super.key});

  @override
  State<QRGenerateScreen> createState() => _QRGenerateScreenState();
}

class _QRGenerateScreenState extends State<QRGenerateScreen> {
  String sessionId = const Uuid().v4();
  bool isActive = false;


  @override
  void initState() {
    super.initState();
    SessionStore.currentSessionId.value = sessionId;
    // Ensure the initial session is created on the backend
    generateSession(sessionId);
  }

  Future<void> startSession() async {
    final res = await http.put(
      Uri.parse("http://10.143.105.128:8080/api/session/$sessionId/start"),
    );

    if (res.statusCode == 200) {
      setState(() {
        isActive = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session Started Successfully")),
      );
    }
  }

  Future<void> stopSession() async {
    final res = await http.put(
      Uri.parse("http://10.143.105.128:8080/api/session/$sessionId/stop"),
    );

    if (res.statusCode == 200) {
      setState(() {
        isActive = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session Stopped Successfully")),
      );
    }
  }

  Future<void> generateSession(String id) async {
    final res = await http.post(
      Uri.parse("http://10.143.105.128:8080/api/session"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "sessionId": id,
        "difficulty": "easy"
      }),
    );

    if (res.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create session")),
      );
    }
  }

  void newSession() async {
    final newId = const Uuid().v4();

    final res = await http.post(
      Uri.parse("http://10.143.105.128:8080/api/session"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "sessionId": newId,
        "difficulty": "easy"
      }),
    );

    if (res.statusCode == 200) {
      setState(() {
        sessionId = newId;
        isActive = false;
      });

      SessionStore.currentSessionId.value = sessionId;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create session")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Quiz QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            QrImageView(
              data: "http://10.143.105.128:8080/api/session/$sessionId",
              size: 250,
            ),

            const SizedBox(height: 20),

            Text("Session: $sessionId"),

            const SizedBox(height: 10),

            Text(
              isActive ? "ACTIVE" : "INACTIVE",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: newSession,
              child: const Text("Generate New Session"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: startSession,
              child: const Text("Start Session"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: stopSession,
              child: const Text("End Session"),
            ),
          ],
        ),
      ),
    );
  }
}