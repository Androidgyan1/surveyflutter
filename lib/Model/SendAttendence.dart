import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/Model/SendAttendence.dart';
import 'package:surveyflutter/RefreshToken/refreshTokenFlutter.dart';
import 'package:surveyflutter/sslbyypass.dart';

Future<void> sendAttendanceApi({
  required int spType,

  String? lat,
  String? lng,
  String? address,

  String? checkInTime,
  String? checkOutTime,

  String? latCheckout,
  String? lngCheckout,
  String? addressCheckout,
  String? attendanceLocationStatus, // ✅ ADD THIS

  bool isRetry = false,
}) async {

  HttpOverrides.global = MyHttpOverrides();

  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");

  if (token == null) {
    debugPrint("❌ No token found");
    return;
  }

  final url = Uri.parse("https://api.paniinap.in/api/public/Attendance");

  final body = {
    "Sptype": spType,

    "latitude": lat,
    "longitude": lng,
    "address": address,

    "attendance_date": getApiDate(),
    "checkin_time": checkInTime,
    "checkout_time": checkOutTime,

    "latitude_checkout": latCheckout,
    "longitude_checkout": lngCheckout,
    "address_checkout": addressCheckout,

    "attendance_location_status": attendanceLocationStatus ?? "",
    "device_id": "Device123"
  };

  // ✅ ADD THIS
  debugPrint("REQUEST BODY → ${jsonEncode(body)}");

  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    debugPrint("ATTENDANCE RESPONSE → ${response.body}");

    /// 🔥 TOKEN EXPIRED
    if (response.statusCode == 401 && !isRetry) {
      bool refreshed = await refreshTokenFlutter();

      if (refreshed) {
        return sendAttendanceApi(
          spType: spType,
          lat: lat,
          lng: lng,
          address: address,
          checkInTime: checkInTime,
          checkOutTime: checkOutTime,
          latCheckout: latCheckout,
          lngCheckout: lngCheckout,
          addressCheckout: addressCheckout,
          attendanceLocationStatus: attendanceLocationStatus, // ✅ ADD THIS
          isRetry: true,
        );
      } else {
        debugPrint("❌ Token refresh failed");
        return;
      }
    }

    if (response.statusCode == 200) {
      debugPrint("✅ Attendance success");
    } else {
      debugPrint("❌ Attendance failed: ${response.body}");
    }

  } catch (e) {
    debugPrint("❌ API ERROR → $e");
  }
}

String getApiDate() {
  final now = DateTime.now();
  return "${now.day.toString().padLeft(2, '0')}/"
      "${now.month.toString().padLeft(2, '0')}/"
      "${now.year}";
}