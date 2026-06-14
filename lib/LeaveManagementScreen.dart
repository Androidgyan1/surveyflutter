
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/Model/LeaveTypeModel.dart';
import 'package:surveyflutter/Model/ResponsibleEmployeeModel.dart';
import 'package:surveyflutter/RefreshToken/refreshTokenFlutter.dart';
class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {

  String name = "N/A";
  String code = "N/A";
  String designation = "N/A";
  String reportingManager = "";
  String reportingManagerId = "";
  String departmentId = "";
  String designationId = "";
  String projectId = "";

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController numberOfDaysController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController emergencyNumberController =
  TextEditingController();
  List<ResponsibleEmployeeModel> responsibleEmployees = [];

  ResponsibleEmployeeModel? selectedChargeEmployee;

  String departmentid = "";
  String projectid = "";
  final TextEditingController attachmentController = TextEditingController();

  PlatformFile? selectedAttachment;

  List<LeaveTypeModel> leaveTypes = [];

  LeaveTypeModel? selectedLeaveType;

 // String? filePath = selectedAttachment?.path;
 // String? fileName = selectedAttachment?.name;

  @override
  void initState() {
    super.initState();
    loadProfile();
    getLeaveTypes();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("emp_name") ?? "N/A";
      code = prefs.getString("emp_code") ?? "N/A";
      designation = prefs.getString("designation") ?? "N/A";
      departmentId =
          prefs.getString("department_id") ?? "";

      projectId =
          prefs.getString("project_id") ?? "";
    });

    getResponsibleEmployees();
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<LeaveTypeModel>(
                      value: selectedLeaveType,
                      decoration: InputDecoration(
                        labelText: "Select Leave Type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: leaveTypes.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.valueText),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLeaveType = value;
                        });

                        debugPrint(
                          "Selected ID: ${value?.valueId}",
                        );

                        debugPrint(
                          "Selected Text: ${value?.valueText}",
                        );
                      },
                    ),
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
              child: DropdownButtonFormField<ResponsibleEmployeeModel>(
                value: selectedChargeEmployee,
                decoration: InputDecoration(
                  labelText: "Select Employee",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                hint: const Text("No employee found"),

                items: responsibleEmployees.map((item) {
                  return DropdownMenuItem<ResponsibleEmployeeModel>(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),

                onChanged: responsibleEmployees.isEmpty
                    ? null
                    : (value) {
                  setState(() {
                    selectedChargeEmployee = value;
                  });

                  debugPrint(
                    "Employee Id: ${value?.id}",
                  );

                  debugPrint(
                    "Employee Name: ${value?.name}",
                  );
                },
              ),
            ),            const SizedBox(height: 20),

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

                    submitLeave();
                    // TODO: Call Leave API
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
  Future<void> getLeaveTypes() async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://api.paniinap.in/api/public/LeaveType",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List result = data["result"];

        setState(() {
          leaveTypes = result
              .map((e) => LeaveTypeModel.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Leave Type Error: $e");
    }
  }
  Future<void> getResponsibleEmployees() async {
    try {
      if (departmentId.isEmpty) {
        debugPrint("DepartmentId is empty");
        return;
      }

      String projId = projectId.isEmpty ? "" : projectId;

      var url = Uri.parse(
        "https://api.paniinap.in/api/public/ResponsibleEmployeeList"
            "?depid=$departmentId&projid=$projId",
      );

      debugPrint("Responsible Employee URL: $url");

      var response = await http.get(url);

      debugPrint("Responsible Employee Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["status"] == "success" && data["result"] is List) {
          List result = data["result"];

          setState(() {
            responsibleEmployees = result
                .map((e) => ResponsibleEmployeeModel.fromJson(e))
                .toList();

            selectedChargeEmployee =
            responsibleEmployees.isNotEmpty ? responsibleEmployees.first : null;
          });
        } else {
          setState(() {
            responsibleEmployees = [];
            selectedChargeEmployee = null;
          });

          debugPrint("No responsible employee found: ${data["result"]}");
        }
      }
    } catch (e) {
      debugPrint("Responsible Employee Error: $e");
    }
  }
  Future<void> submitLeave({bool isRetry = false}) async {

    if (selectedLeaveType == null) {
      showMsg("Please select leave type");
      return;
    }

    if (fromDateController.text.isEmpty) {
      showMsg("Please select From Date");
      return;
    }

    if (toDateController.text.isEmpty) {
      showMsg("Please select To Date");
      return;
    }

    if (reasonController.text.trim().isEmpty) {
      showMsg("Please enter reason");
      return;
    }

    if (emergencyNumberController.text.trim().isEmpty) {
      showMsg("Please enter emergency number");
      return;
    }

    showLoader();

    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    if (token == null) {
      hideLoader();
      showMsg("Session expired");
      return;
    }

    int reportingManagerId = int.tryParse(
        prefs.getString("reporting_manager_id") ?? "0") ??
        0;

    var url = Uri.parse(
      "https://api.paniinap.in/api/Public/ApplyLeave",
    );
    String? attachmentBase64 = await convertAttachmentToBase64();
    try {
      var body = {
        "leave_type_id": selectedLeaveType?.valueId,
        "reason": reasonController.text.trim(),
        "FromDate":  convertDateForApi(fromDateController.text),
        "ToDate": convertDateForApi(toDateController.text),
        "DaysOff":
        int.tryParse(numberOfDaysController.text) ?? 0,
        "reporting_user_id": reportingManagerId,

        "supporting_attachment": attachmentBase64,

        "emergency_contact":
        emergencyNumberController.text.trim(),

        "responsible_emp_id":
        selectedChargeEmployee?.id,
      };

      debugPrint(
        "LEAVE REQUEST => ${jsonEncode(body)}",
      );

      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      /// TOKEN EXPIRE
      if (response.statusCode == 401 && !isRetry) {
        debugPrint("Token expired -> Refresh");

        bool refreshed =
        await refreshTokenFlutter();

        if (refreshed) {
          hideLoader();
          return submitLeave(isRetry: true);
        } else {
          hideLoader();
          showMsg("Session expired. Login again.");
          return;
        }
      }

      if (response.statusCode == 200) {
        hideLoader();

        var data = jsonDecode(response.body);

        showMsg(
          data["result"] ??
              "Leave Request Submitted Successfully",
        );

        debugPrint(response.body);

        clearLeaveForm();
      } else {
        hideLoader();

        debugPrint(response.body);

        showMsg("Failed to submit leave request");
      }
    } catch (e) {
      hideLoader();
      showMsg("Error: $e");
    }
  }
  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /////hide loader
  void hideLoader() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /////// show loader
  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false, // ❌ user cannot close
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void clearLeaveForm() {

    setState(() {
      selectedLeaveType = null;
      selectedChargeEmployee = null;
      selectedAttachment = null;
    });

    fromDateController.clear();
    toDateController.clear();
    numberOfDaysController.clear();
    reasonController.clear();
    emergencyNumberController.clear();
    attachmentController.clear();
  }

  String convertDateForApi(String date) {
    return date.replaceAll("-", "/");
  }

  Future<String?> convertAttachmentToBase64() async {
    if (selectedAttachment == null || selectedAttachment!.path == null) {
      return null;
    }

    final file = File(selectedAttachment!.path!);

    final bytes = await file.readAsBytes();

    return base64Encode(bytes);
  }
}