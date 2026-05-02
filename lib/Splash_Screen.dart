import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import 'DashBord.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  // ✅ CHECK LOGIN STATUS
  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      // ✅ Already logged in → Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // ❌ Not logged in → Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [

            // 🔝 Top Logo
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),

            // 🔵 Center Logo
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/panitwo.png",
                  height: 100,
                  color: Colors.white,
                ),
              ),
            ),

            // 🔽 Bottom Text
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "People's Action for National Integration - PANI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}