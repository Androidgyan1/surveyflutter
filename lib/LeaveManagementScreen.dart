
import 'package:file_picker/file_picker.dart';
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

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController numberOfDaysController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController emergencyNumberController =
  TextEditingController();
  String? selectedChargeEmployee;
  final TextEditingController attachmentController = TextEditingController();

  PlatformFile? selectedAttachment;

 // String? filePath = selectedAttachment?.path;
 // String? fileName = selectedAttachment?.name;

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
        title: const Text("Leave Management",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0366A3),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            // 🔥 PROFILE CARD
            buildProfileCard(),
        
            // 👉 rest of your UI here
            const SizedBox(height: 20),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        
                  const Text(
                    "Leave Type",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Leave Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "CL",
                        child: Text("CL (Casual Leave)"),
                      ),
                      DropdownMenuItem(
                        value: "SL",
                        child: Text("SL (Sick Leave)"),
                      ),
                    ],
                    onChanged: (value) {
                      // For now static
                    },
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "From Date",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: fromDateController,
                      readOnly: true,
                      onTap: () => pickDate(fromDateController),
                      decoration: InputDecoration(
                        hintText: "Select From Date",
                        suffixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
        
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "To Date",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: toDateController,
                      readOnly: true,
                      onTap: () => pickDate(toDateController),
                      decoration: InputDecoration(
                        hintText: "Select To Date",
                        suffixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Number of Days",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: numberOfDaysController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Auto calculated",
                        suffixIcon: const Icon(Icons.calculate),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Reason for Leave",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: reasonController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter reason for leave",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Emergency Number During Leave Period",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: emergencyNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: "Enter Emergency Contact Number",
                        prefixIcon: const Icon(Icons.phone),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Employee Taking Charge During Leave",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                value: selectedChargeEmployee,
                decoration: InputDecoration(
                  labelText: "Select Employee",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Mayank",
                    child: Text("Mayank"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedChargeEmployee = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Attachment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: attachmentController,
                readOnly: true,
                onTap: pickAttachment,
                decoration: InputDecoration(
                  hintText: "Upload Image or PDF",
                  prefixIcon: const Icon(Icons.attach_file),
                  suffixIcon: const Icon(Icons.upload_file),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Submit Leave Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0366A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    // TODO: Call Leave API

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Leave Request Submitted"),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.day.toString().padLeft(2, '0')}-"
          "${pickedDate.month.toString().padLeft(2, '0')}-"
          "${pickedDate.year}";

      calculateNumberOfDays();
    }
  }
  void calculateNumberOfDays() {
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      numberOfDaysController.text = "";
      return;
    }

    DateTime fromDate = parseDate(fromDateController.text);
    DateTime toDate = parseDate(toDateController.text);

    if (toDate.isBefore(fromDate)) {
      numberOfDaysController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("To Date cannot be before From Date")),
      );
      return;
    }

    int days = toDate.difference(fromDate).inDays + 1;
    numberOfDaysController.text = days.toString();
  }

  DateTime parseDate(String date) {
    List<String> parts = date.split("-");
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }
  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedAttachment = result.files.first;
        attachmentController.text = selectedAttachment!.name;
      });
    }
  }

}