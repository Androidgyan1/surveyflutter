import 'package:flutter/material.dart';
import 'package:surveyflutter/SurveyScreen.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // 🔵 TOP HEADER
            Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFF0366A3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/panitwo.png',
                    height: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Select Your Role",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Choose how you want to access the system",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 TITLE
            const Text(
              "I am for...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            // 🔳 GRID CARDS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                  children: [

                    // ✅ Attendance
                    buildCard(
                      context,
                      title: "Attendence Mark",
                      subtitle: "Attendence management",
                      icon: 'assets/immigration.png',
                      color: Colors.orange.shade100,
                      onTap: () {
                        showToast(context);
                      },
                    ),

                    // ✅ Survey
                    buildCard(
                      context,
                      title: "Baseline Survey",
                      subtitle: "Public Survey",
                      icon: 'assets/checklist.png',
                      color: Colors.green.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyScreen(),
                          ),
                        );
                      },
                    ),

                    // ✅ Leave
                    buildCard(
                      context,
                      title: "Leave Management",
                      subtitle: "Leave Approve/Reject",
                      icon: 'assets/leave.png',
                      color: Colors.blue.shade100,
                      onTap: () {
                        showToast(context);
                      },
                    ),

                    // ✅ History
                    buildCard(
                      context,
                      title: "History",
                      subtitle: "Previously Report",
                      icon: 'assets/file.png',
                      color: Colors.purple.shade100,
                      onTap: () {
                        showToast(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 🔻 BOTTOM TEXT
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "People's Action for National Integration - PANI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 CARD WIDGET
  Widget buildCard(
      BuildContext context, {
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
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Working on it..."),
        duration: Duration(seconds: 2),
      ),
    );
  }

}