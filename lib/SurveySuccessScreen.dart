import 'package:flutter/material.dart';
class SurveySuccessScreen extends StatelessWidget {
  final String message;

  const SurveySuccessScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ✅ SUCCESS ICON
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Success",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // ✅ SHOW API RESULT MESSAGE
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                // ✅ BACK BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}