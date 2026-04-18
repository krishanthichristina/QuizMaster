import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QRGenerateScreen extends StatefulWidget {
  const QRGenerateScreen({super.key});

  @override
  State<QRGenerateScreen> createState() => _QRGenerateScreenState();
}

class _QRGenerateScreenState extends State<QRGenerateScreen> {
  String sessionId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Quiz QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            QrImageView(
              data: 'http://10.163.47.128:8080/quiz?session=$sessionId',
              size: 250,
            ),


            const SizedBox(height: 20),

            Text("Session: $sessionId"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final newSessionId = const Uuid().v4();

                final res = await http.post(
                  Uri.parse("http://localhost:8080/api/session"),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "sessionId": newSessionId,
                    "difficulty": "easy"
                  }),
                );

                if (res.statusCode == 200) {
                  setState(() {
                    sessionId = newSessionId;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to create session")),
                  );
                }
              },
              child: const Text("Generate New Session"),
            ),
          ],
        ),
      ),
    );
  }
}