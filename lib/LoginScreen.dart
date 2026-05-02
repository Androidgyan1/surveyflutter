import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/SurveyScreen.dart';
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
      HttpOverrides.global = MyHttpOverrides();

      var url = Uri.parse('https://api.paniinap.in/token');

      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      String hashedPassword = sha256Hash(password);

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "password",
          "UserName": username,
          "password": hashedPassword,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        String token = data["access_token"];
        int expiresIn = data["expires_in"];

        // ✅ Save data (same as Kotlin)
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("username", username);
        await prefs.setString("password", password);
        await prefs.setString("token", token);

        int expiryTime =
            DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
        await prefs.setInt("expiry", expiryTime);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Success")),
        );

        // ✅ DIRECT NAVIGATION (NO resume logic)
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [

                        SizedBox(height: constraints.maxHeight * 0.03),

                        // 🔵 LOGO
                        Image.asset(
                          'assets/panitwo.png',
                          height: constraints.maxHeight * 0.12,
                          width: constraints.maxWidth * 0.3,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDBEAFE),
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "Login in to your account to continue",
                          style: TextStyle(color: Color(0xFFE2E8F0)),
                        ),

                        const Spacer(),

                        // 🔳 LOGIN CARD
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.05,
                          ),
                          child: Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(constraints.maxWidth * 0.06),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  // USERNAME
                                  TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset('assets/usertwo.png'),
                                      ),
                                      hintText: "Username",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // PASSWORD
                                  TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset('assets/padlocktwo.png'),
                                      ),
                                      hintText: "Password",
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
                                        backgroundColor: const Color(0xFF0366A3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: isLoading ? null : login,
                                      child: const Text("LOGIN",
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ),

                                  if (isLoading) ...[
                                    const SizedBox(height: 10),
                                    const CircularProgressIndicator(),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "People's Action for National Integration - PANI",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFF8FAFC),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    );
  }
}