import 'package:flutter/material.dart';
import 'LoginScreen.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash_Screen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[800],

      body: SafeArea(
        child: Column(
          children: [
            // 🔝 Top Image
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