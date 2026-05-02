import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> refreshTokenFlutter({int retry = 0}) async {
  final prefs = await SharedPreferences.getInstance();

  String username = prefs.getString("username") ?? "";
  String password = prefs.getString("password") ?? "";

  if (username.isEmpty || password.isEmpty) {
    return false;
  }

  String hashedPassword = sha256(password);

  try {
    final response = await http.post(
      Uri.parse("https://api.paniinap.in/token"),
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
      final json = jsonDecode(response.body);
      String token = json["access_token"];

      await prefs.setString("token", token);

      debugPrint("✅ Token refreshed");
      return true;
    } else {
      throw Exception("Refresh failed");
    }

  } catch (e) {
    if (retry < 2) {
      debugPrint("🔁 Retry refresh: $retry");
      await Future.delayed(const Duration(seconds: 2));
      return refreshTokenFlutter(retry: retry + 1);
    }
    return false;
  }
}


String sha256(String input) {
  return crypto.sha256.convert(utf8.encode(input)).toString();
}