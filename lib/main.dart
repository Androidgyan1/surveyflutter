import 'dart:io';
import 'package:upgrader/upgrader.dart';
import 'package:flutter/material.dart';
import 'package:surveyflutter/Splash_Screen.dart';
import 'package:surveyflutter/sslbyypass.dart';


void main() {
  HttpOverrides.global = MyHttpOverrides(); // ✅ MUST be here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Splash_Screen(),
      ),
    );
  }
}