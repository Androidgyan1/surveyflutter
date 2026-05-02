import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/SHA.dart';
import 'package:surveyflutter/sslbyypass.dart';

class ApiService {

  // 🔁 COMMON POST METHOD (AUTO TOKEN HANDLE)
  static Future<http.Response> post(
      String url, {
        Map<String, dynamic>? body,
      }) async {

    HttpOverrides.global = MyHttpOverrides();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    // 🔹 First Call
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body ?? {}),
    );

    // 🔥 IF TOKEN EXPIRED
    if (response.statusCode == 401) {
      bool refreshed = await _refreshToken();

      if (refreshed) {
        String? newToken = prefs.getString("token");

        // 🔁 RETRY API
        response = await http.post(
          Uri.parse(url),
          headers: {
            "Authorization": "Bearer $newToken",
            "Content-Type": "application/json",
          },
          body: jsonEncode(body ?? {}),
        );
      }
    }

    return response;
  }

  // 🔁 REFRESH TOKEN (PRIVATE)
  static Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();

    String username = prefs.getString("username") ?? "";
    String password = prefs.getString("password") ?? "";

    if (username.isEmpty || password.isEmpty) return false;

    try {
      var response = await http.post(
        Uri.parse("https://api.paniinap.in/token"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "password",
          "UserName": username,
          "password": sha256Hash(password),
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await prefs.setString("token", data["access_token"]);
        return true;
      }
    } catch (e) {
      print("Refresh Error: $e");
    }

    return false;
  }
}