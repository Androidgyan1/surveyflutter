import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  String name = "N/A";
  String code = "N/A";
  String designation = "N/A";

  late AnimationController _controller;
  late Animation<Offset> leftSlide;
  late Animation<Offset> rightSlide;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    loadProfile();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    leftSlide = Tween<Offset>(
      begin: const Offset(-0.6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    rightSlide = Tween<Offset>(
      begin: const Offset(0.6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            profileRow("Name", name),
            const Divider(),
            profileRow("EMP Code", code),
            const Divider(),
            profileRow("EMP Designation", designation),
          ],
        ),
      ),
    );
  }

  Widget profileRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget historyCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool alignRight,
    required Animation<Offset> slideAnimation,
    required VoidCallback onTap,
  }) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnimation,
        child: Align(
          alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 28,
                          color: const Color(0xFF0366A3),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0366A3),
        elevation: 6,
        title: Row(
          children: [
            Image.asset(
              "assets/panitwo.png",
              height: 28,
              width: 28,
              color: Colors.white70,
            ),
            const SizedBox(width: 10),
            const Text(
              "History",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildProfileCard(),

              const SizedBox(height: 10),

              historyCard(
                title: "Baseline Survey Summary",
                subtitle: "View submitted survey history",
                icon: Icons.assignment,
                color: Colors.green.shade100,
                alignRight: false,
                slideAnimation: leftSlide,
                onTap: () {
                  showMsg("Baseline Survey Summary clicked");
                },
              ),

              historyCard(
                title: "Attendance Summary",
                subtitle: "View attendance and tracking report",
                icon: Icons.access_time_filled,
                color: Colors.orange.shade100,
                alignRight: true,
                slideAnimation: rightSlide,
                onTap: () {
                  showMsg("Attendance Summary clicked");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}