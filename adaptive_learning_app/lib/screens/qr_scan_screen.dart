import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'quiz_start_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR")),
      body: MobileScanner(
          onDetect: (capture) async {
            if (scanned) return;

            final barcode = capture.barcodes.first;
            final value = barcode.rawValue;

            if (value == null) return;

            setState(() => scanned = true);

            String sessionId = value.trim();
            
            // Handle full URL or deep link formats
            if (sessionId.contains("/session/")) {
              sessionId = sessionId.split("/session/").last;
            }
            
            // Clean up any remaining URI parts
            if (sessionId.contains("?")) {
              sessionId = sessionId.split("?").first;
            }
            
            // Remove any trailing slashes
            if (sessionId.endsWith("/")) {
              sessionId = sessionId.substring(0, sessionId.length - 1);
            }

            print("EXTRACTED SESSION ID: $sessionId");

            try {
              final res = await http.get(
                Uri.parse("http://10.143.105.128:8080/api/session/$sessionId"),
              );

              print("STATUS: ${res.statusCode}");
              print("BODY: ${res.body}");

              if (!mounted) return;

              if (res.statusCode == 200) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizStartScreen(sessionId: sessionId),
                  ),
                );
              } else {
                setState(() => scanned = false);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Session not found: ${res.statusCode}")),
                );
              }
            } catch (e) {
              setState(() => scanned = false);

              print("ERROR: $e");

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Server error")),
              );
            }
          },
      ),
    );
  }
}