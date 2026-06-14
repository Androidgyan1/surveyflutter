import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/AppUpdateHelper/AppUpdateHelper.dart';
import 'package:surveyflutter/HistoryScreen.dart';
import 'package:surveyflutter/LeaveManagementScreen.dart';
import 'package:surveyflutter/SurveyScreen.dart';
import 'package:surveyflutter/LoginScreen.dart';
import 'package:surveyflutter/sslbyypass.dart';
import 'package:surveyflutter/SHA.dart';
import 'package:surveyflutter/AttendeanceScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  double w(double size) =>
      MediaQuery.of(context).size.width * (size / 375);

  double h(double size) =>
      MediaQuery.of(context).size.height * (size / 812);

  double sp(double size) =>
      MediaQuery.of(context).textScaleFactor * size;

  String name = "N/A";
  String code = "N/A";
  String designation = "N/A";

  @override
  void initState() {
    super.initState();
    loadCachedProfile();
    callProfileApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateHelper.checkForUpdate(context);
    });
  }

  // ✅ LOAD CACHE
  Future<void> loadCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("emp_name") ?? "N/A";
      code = prefs.getString("emp_code") ?? "N/A";
      designation = prefs.getString("designation") ?? "N/A";
    });
  }

  // ✅ API CALL
  Future<void> callProfileApi() async {
    HttpOverrides.global = MyHttpOverrides();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      goToLogin();
      return;
    }

    var url = Uri.parse("https://api.paniinap.in/api/public/authenticate");

    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var result = data["result"];

      setState(() {
        name = result["emp_name"];
        code = result["emp_code"];
        designation = result["Designation"];
      });

      // ✅ CACHE
      await prefs.setString("emp_name", name);
      await prefs.setString("emp_code", code);
      await prefs.setString("designation", designation);
      await prefs.setInt("emp_id", result["emp_id"]); // 🔥 IMPORTANT

      // ✅ CACHE EXTRA PROFILE DATA FOR FUTURE USE
      await prefs.setString("mobile_no", result["mobileno"] ?? "");
      await prefs.setString("email_id", result["emailid"] ?? "");
      await prefs.setString("permanent_address", result["permanent_address"] ?? "");
      await prefs.setString("department_name", result["dep_name"] ?? "");
      await prefs.setString("district_name", result["DisttName"] ?? "");
      await prefs.setString("image_path", result["ImagePath"] ?? "");
      await prefs.setString("joining_date", result["joining_date"] ?? "");

      await prefs.setString("reporting_manager", result["ReportingManager"] ?? "");
      await prefs.setString("reporting_manager_id", result["ReportingManagerId"] ?? "");

      await prefs.setString("department_id", result["DepartmentId"] ?? "");
      await prefs.setString("designation_id", result["designation_id"] ?? "");
      await prefs.setString("project_id", result["project_id"] ?? "");


    } else if (response.statusCode == 401) {
      await refreshToken();
      await callProfileApi(); // retry
    } else {
      showToast("API Error");
    }
  }

  // ✅ TOKEN REFRESH
  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();

    String username = prefs.getString("username") ?? "";
    String password = prefs.getString("password") ?? "";

    var url = Uri.parse("https://api.paniinap.in/token");

    var response = await http.post(
      url,
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
      String newToken = data["access_token"];

      await prefs.setString("token", newToken);
    } else {
      goToLogin();
    }
  }

  // ✅ NAVIGATE LOGIN
  void goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  // ✅ TOAST
  void showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ✅ PROFILE CARD (ANDROID STYLE)
  Widget buildProfileCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            Row(
              children: [
                const Expanded(
                  child: Text("Name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Expanded(
                  child: Text(name,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),

            const Divider(),

            Row(
              children: [
                const Expanded(
                  child: Text("EMP Code",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Expanded(
                  child: Text(code,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),

            const Divider(),

            Row(
              children: [
                const Expanded(
                  child: Text("EMP Designation",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Expanded(
                  child: Text(designation,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ CARD GRID ITEM
  Widget buildCard({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, height: 60),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(subtitle, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Color(0xFF0366A3),
        titleSpacing: 12,
        title: Row(
          children: [
            Image.asset(
              "assets/panitwo.png",
              color: Colors.white70,
              height: w(28),
              width: w(28),
            ),
            SizedBox(width: w(12)),
            Text(
              "DashBord",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: sp(25),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [

                  // 🔵 HEADER
                  Container(
                    width: double.infinity,
                    height: constraints.maxHeight < 500 ? 120 : constraints.maxHeight * 0.22,
                    color: const Color(0xFF0366A3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/panitwo.png',
                          height: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Select Your Role",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildProfileCard(),

                  const SizedBox(height: 10),

                  // 🔳 GRID
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 2;

                        if (constraints.maxWidth < 350) {
                          crossAxisCount = 1;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 3;
                        }

                        return GridView.count(
                          childAspectRatio: constraints.maxHeight < 500 ? 1.2 : 0.85,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                         // childAspectRatio: 0.85,
                          children: [

                            buildCard(
                              title: "Attendance",
                              subtitle: "Manage attendance",
                              icon: 'assets/immigration.png',
                              color: Colors.orange.shade100,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AttendanceScreen(),
                                  ),
                                );
                              },
                            ),

                            buildCard(
                              title: "Survey",
                              subtitle: "Baseline Survey",
                              icon: 'assets/checklist.png',
                              color: Colors.green.shade100,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SurveyScreen(),
                                  ),
                                );
                              },
                            ),

                            buildCard(
                              title: "Leave",
                              subtitle: "Manage leave",
                              icon: 'assets/leave.png',
                              color: Colors.blue.shade100,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LeaveManagementScreen(),
                                  ),
                                );
                              },
                            ),

                            buildCard(
                              title: "History",
                              subtitle: "Reports",
                              icon: 'assets/file.png',
                              color: Colors.purple.shade100,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HistoryScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔻 LOGOUT (no Spacer)
                  GestureDetector(
                    onTap: logoutUser,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ✅ clear all saved data
    showToast("Logout Success...");
    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (_) => const LoginScreen()),

          (route) => false,
    );
  }
}

