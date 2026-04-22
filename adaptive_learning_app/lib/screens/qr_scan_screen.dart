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
            if (barcode.rawValue == null) return;

            setState(() => scanned = true);

            final sessionId = barcode.rawValue!;
            print("Scanned: $sessionId");

            try {
              final res = await http.get(
                Uri.parse("http://10.163.47.128:8080/api/session"),
              );

              if (res.statusCode == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizStartScreen(sessionId: sessionId),
                  ),
                );
              } else {
                setState(() => scanned = false);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Session not valid")),
                );
              }
            } catch (e) {
              setState(() => scanned = false);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Server error")),
              );
            }


        },
      ),
    );
  }
}