
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {

  String name = "N/A";
  String code = "N/A";
  String designation = "N/A";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("emp_name") ?? "N/A";
      code = prefs.getString("emp_code") ?? "N/A";
      designation = prefs.getString("designation") ?? "N/A";
    });
  }

  Widget buildProfileCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Row(
              children: [
                const Expanded(
                  child: Text("Name",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Divider(),

            Row(
              children: [
                const Expanded(
                  child: Text("EMP Code",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text(
                    code,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Divider(),

            Row(
              children: [
                const Expanded(
                  child: Text("Designation",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text(
                    designation,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Management"),
        backgroundColor: const Color(0xFF0366A3),
      ),
      body: Column(
        children: [

          // 🔥 PROFILE CARD
          buildProfileCard(),

          // 👉 rest of your UI here
          const SizedBox(height: 20),

          const Text("Leave Module Coming Soon"),
        ],
      ),
    );
  }
}