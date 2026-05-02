import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/Model/SendAttendence.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {

  String? selectedLocationType;


  double w(double size) =>
      MediaQuery.of(context).size.width * (size / 375);

  double h(double size) =>
      MediaQuery.of(context).size.height * (size / 812);

  double sp(double size) =>
      MediaQuery.of(context).textScaleFactor * size;

  String name = "N/A";
  String code = "N/A";
  String designation = "N/A";

  String locationStatus = "Checking...";
  Color statusColor = Colors.grey;

  Timer? timer;

  double maxDrag = 0;
  bool isProcessing = false;
  double dragPosition = 0;

  late AnimationController _controller;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  String fullAddress = "Fetching address...";

  String checkInTime = "--:--";
  String checkOutTime = "--:--";
  String totalTime = "--";
  String liveTime = "--";

  bool isCheckedIn = false;

  String userLat = "--";
  String userLng = "--";
  double distanceInMeters = 0;
  @override
  void initState() {
    super.initState();
    loadProfile(); // 🔥 ADD THIS
    loadAttendance();
    getLocation();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(_controller);

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(Duration.zero, () {
      if (isCheckedIn && checkInTime != "--:--") {
        startLiveTimer();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  // ✅ LOAD DATA + RESET DAILY
  Future<void> loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();

    String today = DateTime.now().toString().split(" ")[0];
    String? savedDate = prefs.getString("attendance_date");

    if (savedDate != today) {
      // ✅ ONLY CLEAR ATTENDANCE DATA (NOT TOKEN)
      await prefs.remove("checkIn");
      await prefs.remove("checkOut");
      await prefs.remove("totalTime");
      await prefs.remove("isCheckedIn");

      await prefs.setString("attendance_date", today);
    }

    setState(() {
      checkInTime = prefs.getString("checkIn") ?? "--:--";
      checkOutTime = prefs.getString("checkOut") ?? "--:--";
      totalTime = prefs.getString("totalTime") ?? "--";
      isCheckedIn = prefs.getBool("isCheckedIn") ?? false;
    });
  }

  // ✅ LOCATION
  Future<Position> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        locationStatus = "Location Disabled";
        statusColor = Colors.red;
      });
      throw "Location services are disabled";
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 🔥 GET ADDRESS
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      Placemark place = placemarks.first;

      fullAddress =
      "${place.name}, ${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}";
    } catch (e) {
      fullAddress = "Address not found";
    }

    setState(() {
      userLat = pos.latitude.toStringAsFixed(5);
      userLng = pos.longitude.toStringAsFixed(5);

      locationStatus = "Location Captured";
      statusColor = Colors.green;
    });

    return pos;
  }

  Future<bool> isWithinOffice() async {
    await getLocation(); // just fetch location
    return true; // always allow
  }

  // ✅ CHECK IN
  Future<void> checkIn() async {
    try {
      await getLocation();

      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("checkIn", now.toString());
      await prefs.setBool("isCheckedIn", true);
      await prefs.setString(
          "attendance_date", DateTime.now().toString().split(" ")[0]);

      setState(() {
        checkInTime = now.toString();
        isCheckedIn = true;
      });

      // 🔥 CALL API
      await sendAttendanceApi(
        spType: 1,
        lat: userLat,
        lng: userLng,
        address: fullAddress,
        checkInTime: formatApiTime(DateTime.now()),
        attendanceLocationStatus: selectedLocationType, // ✅ HERE
        checkOutTime: null,
        latCheckout: null,
        lngCheckout: null,
        addressCheckout: null,
      );

      startLiveTimer();
      showMsg("Check-In Successful");

    } catch (e) {
      showMsg(e.toString());
    }
  }

  // ✅ CHECK OUT
  Future<void> checkOut() async {
    try {
      await getLocation();

      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();

      String? checkInStr = prefs.getString("checkIn");

      if (checkInStr == null) {
        showMsg("Check-In not found");
        return;
      }

      DateTime checkInDate = DateTime.parse(checkInStr);
      Duration diff = now.difference(checkInDate);

      String total = "${diff.inHours}h ${diff.inMinutes % 60}m";

      await prefs.setString("checkOut", now.toString());
      await prefs.setString("totalTime", total);
      await prefs.setBool("isCheckedIn", false);

      setState(() {
        dragPosition = 0;
        checkOutTime = now.toString();
        totalTime = total;
        isCheckedIn = false;
      });

      // 🔥 CALL API (CHECKOUT)
      await sendAttendanceApi(
        spType: 2,

        lat: null,
        lng: null,
        address: null,

        checkInTime: null,
        checkOutTime: formatApiTime(DateTime.now()),

        latCheckout: userLat,
        lngCheckout: userLng,
        addressCheckout: fullAddress,
        attendanceLocationStatus: selectedLocationType, // ✅ HERE
      );

      timer?.cancel();
      showMsg("Check-Out Successful");

    } catch (e) {
      showMsg(e.toString());
    }
  }

  // ✅ TIMER
  void startLiveTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isCheckedIn) return;

      DateTime checkInDate = DateTime.parse(checkInTime);
      Duration diff = DateTime.now().difference(checkInDate);

      setState(() {
        liveTime =
        "${diff.inHours}h ${diff.inMinutes % 60}m ${diff.inSeconds % 60}s";
      });
    });
  }

  // ✅ FORMAT TIME (AM/PM)
  String formatTime(String raw) {
    if (raw == "--:--") return raw;

    DateTime dt = DateTime.parse(raw);

    int hour = dt.hour;
    int minute = dt.minute;

    String period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    String min = minute.toString().padLeft(2, '0');

    return "$hour:$min $period";
  }

  // ✅ DATE FORMAT
  String getFormattedTodayDate() {
    DateTime now = DateTime.now();

    return "${getDay(now.weekday)}, ${now.day} ${getMonth(now.month)} ${now.year}";
  }

  String getDay(int d) {
    const days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
    return days[d - 1];
  }

  String getMonth(int m) {
    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    return months[m - 1];
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ✅ UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.blue[800],
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset(
              "assets/panitwo.png",
              color: Colors.white70,
              height: w(28),
              width: w(28),
            ),
            SizedBox(width: w(8)),
            Text(
              "Attendance Mark",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: sp(20),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: h(80)), // 🔥 space for bottom button
          child: Column(
            children: [

              // HEADER + PROFILE
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: EdgeInsets.all(w(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today is -",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: h(4)),
                          Text(
                            getFormattedTodayDate(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    buildProfileCard(),
                    SizedBox(height: h(20)),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w(12)),
                      child: DropdownButtonFormField<String>(
                        value: selectedLocationType,
                        decoration: InputDecoration(
                          labelText: "Select Work Location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w(10)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: w(12),
                            vertical: h(10),
                          ),
                        ),
                        items: ["Office", "Field", "WFH(Work From Home)"]
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: sp(14)),
                          ),
                        ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedLocationType = v!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h(10)),

              // CARDS
              FadeTransition(
                opacity: fadeAnim,
                child: SlideTransition(
                  position: slideAnim,
                  child: Padding(
                    padding: EdgeInsets.all(w(12)),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded(
                              child: box("Check In", formatTime(checkInTime), Icons.login, Colors.green.shade100),
                            ),
                            SizedBox(width: w(10)),
                            Expanded(
                              child: box("Check Out", formatTime(checkOutTime), Icons.logout, Colors.red.shade100),
                            ),
                          ],
                        ),

                        SizedBox(height: h(10)),

                        Row(
                          children: [
                            Expanded(
                              child: box("Working", isCheckedIn ? liveTime : totalTime, Icons.timer, Colors.blue.shade100),
                            ),
                            SizedBox(width: w(10)),
                            Expanded(
                              child: box(
                                "Location",
                                "$userLat\n$userLng",
                                Icons.location_on,
                                Colors.orange.shade100,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: w(12)),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w(12)),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.place, size: w(18), color: statusColor),
                            SizedBox(width: w(6)),
                            const Text("Current Address", style: TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: w(8), vertical: h(4)),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(w(8)),
                              ),
                              child: Text(
                                locationStatus,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sp(14),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: h(10)),
                        Text(fullAddress, style: TextStyle(fontSize: sp(14))),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(20)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(w(12)),
          child: swipeButton(),
        ),
      ),
    );

  }

  Widget box(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w(12))),
      child: Container(
        padding: EdgeInsets.all(w(12)),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(w(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: w(16)),
                SizedBox(width: w(5)),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: sp(15)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: h(8)),
            Text(
              value,
              style: TextStyle(
                fontSize: sp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget swipeButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        maxDrag = constraints.maxWidth - 60;

        return Container(
          height: h(60),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: dragPosition + 60,
                decoration: BoxDecoration(
                  color: isCheckedIn ? Colors.red.shade300 : Colors.green.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              Center(
                child: Text(
                  isProcessing
                      ? "Processing..."
                      : isCheckedIn
                      ? "Swipe to Check Out"
                      : "Swipe to Check In",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              Positioned(
                left: dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (isProcessing) return;

                    setState(() {
                      dragPosition += details.delta.dx;
                      dragPosition = dragPosition.clamp(0, maxDrag);
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    if (isProcessing) return;

                    if (dragPosition > maxDrag * 0.85) {

                      // ✅ ADD VALIDATION HERE
                      if (selectedLocationType == null) {
                        showMsg("Please select work location");

                        setState(() {
                          dragPosition = 0; // reset swipe
                        });
                        return;
                      }

                      setState(() => isProcessing = true);

                      if (!isCheckedIn) {
                        await checkIn();
                      } else {
                        await checkOut();
                      }

                      setState(() {
                        dragPosition = 0;
                        isProcessing = false;
                      });

                    } else {
                      setState(() => dragPosition = 0);
                    }
                  },
                  child: Container(
                    height: h(60),
                    width: w(60),
                    decoration: BoxDecoration(
                      color: isCheckedIn ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("emp_name") ?? "N/A";
      code = prefs.getString("emp_code") ?? "N/A";
      designation = prefs.getString("designation") ?? "N/A";
    });
  }

  //////profile data

  Widget buildProfileCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(w(12)),
        child: Column(
          children: [

            Row(
              children: [
                const Expanded(
                  child: Text("Name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(12)),
                    overflow: TextOverflow.ellipsis,
                  ),
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
                  child: Text(
                    code,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(12)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const Divider(),

            Row(
              children: [
                const Expanded(
                  child: Text("Designation",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Expanded(
                  child: Text(
                    designation,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(12)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String formatDateTime(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";
  }

  String formatApiTime(DateTime dt) {
    return "${dt.year}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}:"
        "${dt.second.toString().padLeft(2, '0')}";
  }


}