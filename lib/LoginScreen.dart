import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/sslbyypass.dart';

import 'DashBord.dart';
import 'SHA.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  // ✅ Controllers added
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ✅ API Login Function
  Future<void> login() async {
    if (usernameController.text.trim().isEmpty) {
      showError("Enter username");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      showError("Enter password");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ✅ SSL BYPASS (like Android unsafe)
      HttpOverrides.global = MyHttpOverrides();

      var url = Uri.parse('https://api.paniinap.in/token');

      // ✅ SHA-256 password
      String hashedPassword = sha256Hash(passwordController.text.trim());

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "password",
          "UserName": usernameController.text.trim(),
          "password": hashedPassword,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        String token = data["access_token"];

        // ✅ Save token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {
        showError("Invalid username or password");
      }
    } catch (e) {
      print("ERROR: $e");
      showError(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0366A3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Image.asset(
              'assets/panitwo.png',
              height: 100,
              width: 120,
              color: Colors.white,
            ),

            const SizedBox(height: 4),

            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDBEAFE),
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Login in to your account to continue",
              style: TextStyle(color: Color(0xFFE2E8F0)),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ Username
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/usertwo.png',
                                  width: 20,
                                ),
                              ),
                              hintText: "Username",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ✅ Password
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/padlocktwo.png',
                                  width: 20,
                                ),
                              ),
                              hintText: "Password",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // ✅ Call API instead of delay
                              onPressed: isLoading ? null : login,
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          if (isLoading)
                            const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "People's Action for National Integration - PANI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF8FAFC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}