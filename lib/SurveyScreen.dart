import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyflutter/Model/CommonModel.dart';
import 'package:surveyflutter/Model/ProjectModel%20.dart';
import 'package:surveyflutter/RefreshToken/refreshTokenFlutter.dart';
import 'package:surveyflutter/SurveySuccessScreen.dart';
import 'package:surveyflutter/api_Service/api_service.dart';
import 'package:surveyflutter/sslbyypass.dart';

// ================= MODEL =================
class FamilyMember {
  String name = "";
  String fatherName = "";
  String? relation;
  String? gender;
  int? age;
  String? education;
  String? occupation;
}


class ChildMember {
  String name = "";
  String fatherName = "";
  String? relation;
  String? gender;
  int? age;
  String? maritalStatus;
  String? education;
  String? educationStatus;
  String? schooling;


}

// ================= SCREEN =================
class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  // Controllers
  final TextEditingController projectController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  final TextEditingController headNameController = TextEditingController();
  final TextEditingController headFatherController =
  TextEditingController();
  final TextEditingController mobileController = TextEditingController();
        TextEditingController gpsController = TextEditingController();
  TextEditingController Villagecontroller = TextEditingController();
  TextEditingController Hamletcontroller = TextEditingController();

        ////District

  List<CommonModel> districtList = [];
  CommonModel? selectedDistrict;

  bool isDistrictLoading = false;

/////Thesil
  List<CommonModel> blockList = [];
  CommonModel? selectedBlock;

  bool isBlockLoading = false;

//////Block selected
  List<CommonModel> villageList = [];
  CommonModel? selectedVillage;

  bool isVillageLoading = false;

  // Dropdown values
  String? selectedTehsil;

  String? headGender;
  int? headAge;
  String? headEducation;
  String? headOccupation;

  // Name OF Project
  List<ProjectModel> projectList = [];
  ProjectModel? selectedProject;

  bool isProjectLoading = false;

  bool isGeoExpanded = false;


  // Family Members
  List<FamilyMember> members = [];
  bool isExpanded = false;

  List<ChildMember> children = [];
  bool isChildrenExpanded = false;

//////sico-economic
  bool isSocioExpanded = false;

  String? religion;
  String? category;
  String? familyCard;
  String? houseType;
  String? waterSource;
  String? solar;
  String? solarType;
  String? toilet;
  String? electricity;
  String? bank;

///////Health
  bool isHealthExpanded = false;

  String? pregnant;
  String? lactating;
  String? immunized;
  String? anganwadi;
  String? delivery;
  String? insurance;
  String? handwash;

  TextEditingController pregnantCountController = TextEditingController();
  TextEditingController lactatingCountController = TextEditingController();

////Disablity

  bool isDisabilityExpanded = false;

  String? disabled;
  String? disabilityType;
  String? certificate;

  TextEditingController disabledCountController = TextEditingController();

  ////Megiration

  bool isMigrationExpanded = false;

  TextEditingController migratingMembersController = TextEditingController();
  TextEditingController daysMigratedController = TextEditingController();

  String? workType;
  String? workDescription;


///// Assets Hold
  bool isAssetsExpanded = false;

  Map<String, TextEditingController> assetControllers = {
    "Motorcycle": TextEditingController(),
    "Mobile Phone": TextEditingController(),
    "Television": TextEditingController(),
    "Sewing Machine": TextEditingController(),
    "Pump Set": TextEditingController(),
    "Tractor / Trolley": TextEditingController(),
    "Cow": TextEditingController(),
    "Buffalo": TextEditingController(),
    "Goat / Sheep": TextEditingController(),
    "Poultry": TextEditingController(),
    "Fish Pond": TextEditingController(),
    "LPG Gas": TextEditingController(),
  };

  Set<String> selectedAssets = {};

//////Family Income

  bool isIncomeExpanded = false;

  String? agricultureIncome;
  String? livestockIncome;
  String? serviceIncome;
  String? shopIncome;
  String? wagesIncome;

  TextEditingController agricultureController = TextEditingController();
  TextEditingController livestockController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  TextEditingController wagesController = TextEditingController();
  TextEditingController totalIncomeController = TextEditingController();

////Crop Section
  bool isFarmingExpanded = false;

  TextEditingController landHoldingController = TextEditingController();
  TextEditingController leaseLandController = TextEditingController();

  String? farmerRegistered;

// Crop selections + area controllers
  Map<String, TextEditingController> kharifCrops = {
    "Paddy": TextEditingController(),
    "Arhar": TextEditingController(),
    "Maize": TextEditingController(),
    "Till": TextEditingController(),
    "Vegetables": TextEditingController(),
    "Others": TextEditingController(),
  };

  Map<String, TextEditingController> rabiCrops = {
    "Wheat": TextEditingController(),
    "Sugarcane": TextEditingController(),
    "Maize": TextEditingController(),
    "Potato": TextEditingController(),
    "Onion": TextEditingController(),
    "Vegetables": TextEditingController(),
    "Mustard": TextEditingController(),
    "Masoor": TextEditingController(),
    "Gram": TextEditingController(),
    "Pea": TextEditingController(),
    "Others": TextEditingController(),
  };

  Map<String, TextEditingController> zaidCrops = {
    "Maize": TextEditingController(),
    "Vegetables": TextEditingController(),
    "Urd": TextEditingController(),
    "Moong": TextEditingController(),
    "Others": TextEditingController(),
  };

  Set<String> selectedKharif = {};
  Set<String> selectedRabi = {};
  Set<String> selectedZaid = {};

////// LiveStock
  bool isLivestockExpanded = false;

  TextEditingController cowController = TextEditingController();
  TextEditingController buffaloController = TextEditingController();
  TextEditingController goatController = TextEditingController();
  TextEditingController otherLivestockController = TextEditingController();
  TextEditingController milkProductionController = TextEditingController();
  TextEditingController milkSaleController = TextEditingController();

  ////Service Status

  bool isServiceExpanded = false;

  String? serviceType;
  String? serviceNature;
  String? jobType;

  TextEditingController jobDetailsController = TextEditingController();

/////Shop Status

  bool isEnterpriseExpanded = false;

  TextEditingController enterpriseTypeController = TextEditingController();
  TextEditingController enterpriseLocationController = TextEditingController();
  TextEditingController shopMaterialController = TextEditingController();

////Wages Status

  bool isWagesExpanded = false;

  String? wagesWorkType;

  TextEditingController wagesJobDetailsController = TextEditingController();

/////Government Sceheme
  bool isSchemeExpanded = false;

  Set<String> selectedSchemes = {};

  final List<String> governmentSchemes = [
    "Ujjwala Yojana",
    "PM Jeevan Jyoti Bima Yojana",
    "PM Kisan Samman Nidhi",
    "Ayushman Bharat",
    "PM Awas Yojana",
    "PM Fasal Bima Yojana",
    "MGNREGA",
    "Public Distribution System (PDS)",
  ];



  ////sico

  Widget _buildExpandableHeader(
      String title, bool isOpen, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey.shade300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(isOpen ? Icons.expand_less : Icons.expand_more),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setCurrentDateTime();
    getCurrentLocation();   // NEW
    getProjects(); // 👈 NEW
    getDistricts(); // 👈 NEW
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0366A3),
        title: Row(
          children: const [
            Image(image: AssetImage("assets/panitwo.png"),
                color: Colors.white,
                height: 30),
            SizedBox(width: 8),
            Text(
              "Baseline Survey",
              style: TextStyle(
                fontWeight: FontWeight.bold, // 👈 bold text
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ================= GEOGRAPHICAL =================
            // ================= GEOGRAPHICAL DETAILS =================

            const SizedBox(height: 24),

            const Text(
              "Geographical Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

// Project Name
            DropdownButtonFormField<ProjectModel>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "Name of Project",
                border: OutlineInputBorder(),
              ),
              value: selectedProject,
              items: projectList.map((project) {
                return DropdownMenuItem<ProjectModel>(
                  value: project,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      project.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return projectList.map((project) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      project.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              onChanged: (value) {
                setState(() {
                  selectedProject = value;
                });
              },
            ),
            const SizedBox(height: 12),

// Date & Time
            TextField(
              controller: dateTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Date & Time",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

// GPS Location (NEW)
            TextField(
              controller: gpsController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "GPS Location (Lat, Long)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

// State (Static)
            const TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "State",
                hintText: "Uttar Pradesh",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

// District

                DropdownButtonFormField<CommonModel>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "District",
                border: OutlineInputBorder(),
              ),
              value: selectedDistrict,
              items: districtList.map((district) {
                return DropdownMenuItem<CommonModel>(
                  value: district,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      district.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return districtList.map((district) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      district.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;

                      // reset dependent fields
                      selectedBlock = null;
                      blockList = [];
                    });

                    if (value != null) {
                      getBlocks(value.id); // 👈 CALL BLOCK API
                    }
                  },
            ),

            const SizedBox(height: 12),

// Block
           DropdownButtonFormField<CommonModel>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "Tehsil",
                border: OutlineInputBorder(),
              ),
              value: selectedBlock,
              items: blockList.map((block) {
                return DropdownMenuItem<CommonModel>(
                  value: block,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      block.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return blockList.map((block) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      block.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
               onChanged: (value) {
                 setState(() {
                   selectedBlock = value;

                   // reset village
                   selectedVillage = null;
                   villageList = [];
                 });

                 if (value != null) {
                   getVillages(value.id); // 👈 CALL VILLAGE API
                 }

                print("Selected Block ID: ${value?.id}");
              },
            ),

            const SizedBox(height: 12),

// Village (UPDATED → TEXTFIELD)
           DropdownButtonFormField<CommonModel>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "Block",
                border: OutlineInputBorder(),
              ),
              value: selectedVillage,
              items: villageList.map((village) {
                return DropdownMenuItem<CommonModel>(
                  value: village,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      village.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (context) {
                return villageList.map((village) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      village.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              onChanged: (value) {
                setState(() {
                  selectedVillage = value;
                });

                print("Selected Village ID: ${value?.id}");
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: Villagecontroller,
              decoration: const InputDecoration(
                labelText: "Village",
                hintText: "Enter Village",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: Hamletcontroller,
              decoration: const InputDecoration(
                labelText: "Name of Hamlet",
                hintText: "Enter Village",
                border: OutlineInputBorder(),
              ),
            ),

            // ================= FAMILY HEAD =================
            const SizedBox(height: 24),

            const Text(
              "Family Head Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: headNameController,
              decoration: const InputDecoration(
                labelText: "Name of Family Head",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: headFatherController,
              decoration: const InputDecoration(
                labelText: "Father / Husband Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: mobileController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
                counterText: "10",
              ),
            ),


            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              value: headAge,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                83,
                    (i) => DropdownMenuItem(
                  value: i + 18,
                  child: Text((i + 18).toString()),
                ),
              ),
              onChanged: (val) => setState(() => headAge = val),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: headGender,
              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
              items: ["Male", "Female"]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => headGender = val),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: headEducation,
              decoration: const InputDecoration(
                labelText: "Education",
                border: OutlineInputBorder(),
              ),
              items: [
                "Illiterate",
                "Primary",
                "Upper Primary",
                "High School",
                "Intermediate",
                "Graduate",
                "Post Graduate"
              ]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => headEducation = val),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: headOccupation,
              decoration: const InputDecoration(
                labelText: "Occupation",
                border: OutlineInputBorder(),
              ),
              items: [
                "Farming",
                "Government Job",
                "Private Job",
                "Wage Labour",
                "Shop",
                "Others"
              ]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => headOccupation = val),
            ),

            // ================= FAMILY MEMBERS =================
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Family Members Details",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more),
                  ],
                ),
              ),
            ),

            if (isExpanded) ...[
              const SizedBox(height: 12),

              ...members.asMap().entries.map((entry) {
                int index = entry.key;
                FamilyMember m = entry.value;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text("Member ${index + 1}"),

                        TextFormField(
                          key: ValueKey("Name_$index"),
                          initialValue: m.name,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            m.name = val;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          key: ValueKey("father_$index"),
                          initialValue: m.fatherName,
                          decoration: const InputDecoration(
                            labelText: "Father Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            m.fatherName = val;
                          },
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: m.relation, // 🔥 IMPORTANT (bind selected value)
                          decoration: const InputDecoration(
                            labelText: "Relation",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            "Father",
                            "Mother",
                            "Brother",
                            "Sister",
                            "Nephew",
                            "Niece",
                            "Grand Son",
                            "Grand Daughter",
                            "Son",
                            "Daughter",
                            "Spouse"
                          ]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              m.relation = val;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: m.gender, // 🔥 important
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Male", "Female"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              m.gender = val;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<int>(
                          value: m.age, // 🔥 bind selected value
                          decoration: const InputDecoration(
                            labelText: "Age",
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(
                            83,
                                (i) => DropdownMenuItem(
                              value: i + 18,
                              child: Text((i + 18).toString()),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              m.age = val;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        DropdownButtonFormField<String>(
                          value: m.education, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Education",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            "Primary",
                            "Upper Primary",
                            "High School",
                            "Intermediate",
                            "Graduate",
                            "Post Graduate"
                          ]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              m.education = val;
                            });
                          },
                        ),

                        const SizedBox(height: 24),

                        DropdownButtonFormField<String>(
                          value: m.occupation, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Primary Occupation",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            "House Wife",
                            "Farming",
                            "Government Job",
                            "Private Job",
                            "Wage Labour",
                            "Shop",
                            "Others"
                          ]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              m.occupation = val;
                            });
                          },
                        ),

                        const SizedBox(height: 24),



                        TextButton(
                          onPressed: () {
                            setState(() {
                              members.removeAt(index);
                            });
                          },
                          child: const Text("Remove"),
                        )
                      ],
                    ),
                  ),
                );
              }),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    members.add(FamilyMember());
                  });
                },
                child: const Text("Add Family Member"),
              ),
            ],

// ================= FAMILY Childern =================
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () {
                setState(() {
                  isChildrenExpanded = !isChildrenExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Family Children Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(isChildrenExpanded
                        ? Icons.expand_less
                        : Icons.expand_more),
                  ],
                ),
              ),
            ),

            if (isChildrenExpanded) ...[
              const SizedBox(height: 12),

              ...children.asMap().entries.map((entry) {
                int index = entry.key;
                ChildMember child = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text("Child ${index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),

                        const SizedBox(height: 10),

                        // Name
                        TextFormField(
                          key: ValueKey("child_name_$index"),
                          initialValue: child.name,
                          decoration: const InputDecoration(
                            labelText: "Name of Child",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            child.name = val;
                          },
                        ),

                        const SizedBox(height: 10),

                        // Father Name
                        TextFormField(
                          key: ValueKey("child_father_$index"),
                          initialValue: child.fatherName,
                          decoration: const InputDecoration(
                            labelText: "Father Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            child.fatherName = val;
                          },
                        ),

                        const SizedBox(height: 10),

                        // Relation
                        DropdownButtonFormField<String>(
                          value: child.relation, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Relation",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            "Son",
                            "Daughter",
                            "Grand Son",
                            "Grand Daughter"
                          ]
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              child.relation = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Gender
                        DropdownButtonFormField<String>(
                          value: child.gender, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Male", "Female"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              child.gender = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Age (1–18)
                        DropdownButtonFormField<int>(
                          value: child.age, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Age",
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(
                            18,
                                (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text((i + 1).toString()),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              child.age = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Marital Status
                        DropdownButtonFormField<String>(
                          value: child.maritalStatus, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Marital Status",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Married", "Unmarried"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              child.maritalStatus = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Education
                        DropdownButtonFormField<String>(
                          value: child.education, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Education",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            "Home",
                            "Play Group",
                            "Anganwadi",
                            "Primary",
                            "Upper Primary",
                            "High School",
                            "Intermediate",
                            "Graduate"
                          ]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              child.education = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Education Status
                        DropdownButtonFormField<String>(
                          value: child.educationStatus, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Education Status",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Continue", "Completed", "Dropout"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              child.educationStatus = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Schooling
                        DropdownButtonFormField<String>(
                          value: child.schooling, // 🔥 bind value
                          decoration: const InputDecoration(
                            labelText: "Schooling",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Government School", "Private School"]
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              child.schooling = val;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // Remove Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                children.removeAt(index);
                              });
                            },
                            child: const Text("Remove"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    children.add(ChildMember());
                  });
                },
                child: const Text("Add Child"),
              ),
            ],

            const SizedBox(height: 24),

            _buildExpandableHeader(
                "Socio-Economic Status", isSocioExpanded, () {
              setState(() => isSocioExpanded = !isSocioExpanded);
            }),

            if (isSocioExpanded) ...[
              const SizedBox(height: 12),

              // Religion
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Religion",
                  border: OutlineInputBorder(),
                ),
                items: ["Hindu", "Muslim", "Others"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => religion = v),
              ),

              const SizedBox(height: 12),

              // Category
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: ["General", "OBC", "SC", "ST", "Minority"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => category = v),
              ),

              const SizedBox(height: 12),

              // Family Card
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Family Card",
                  border: OutlineInputBorder(),
                ),
                items: ["BPL", "APL"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => familyCard = v),
              ),

              const SizedBox(height: 12),

              // House Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Type of House",
                  border: OutlineInputBorder(),
                ),
                items: ["Kuccha", "Pakka", "Semi-Pakka"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => houseType = v),
              ),

              const SizedBox(height: 12),

              // Water Source
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Drinking Water Source",
                  border: OutlineInputBorder(),
                ),
                items: ["Tap", "Handpump", "Well", "Others"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => waterSource = v),
              ),

              const SizedBox(height: 12),

              // Solar
              DropdownButtonFormField<String>(
                value: solar,
                decoration: const InputDecoration
                  ( labelText: "Solar Energy Consumption",
                  border: OutlineInputBorder(),),
                items: ["Yes", "No"].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    solar = value;

                    // ✅ CLEAR if NO
                    if (solar == "No") {
                      solarType = null;
                    }
                  });
                },
              ),

              const SizedBox(height: 12),

              // Solar Type
              if (solar == "Yes") ...[
                const SizedBox(height: 10),

                TextField(
                  decoration: const InputDecoration(
                    labelText: "Type of Solar Use",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value){
                    setState(() {
                      solar = value;

                      // ✅ clear value when No
                      if (solar == "No") {
                        solarType = null;
                      }
                    });
                  }
                ),
              ],

              const SizedBox(height: 12),

              // Toilet
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Toilet Facility",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => toilet = v),
              ),

              const SizedBox(height: 12),

              // Electricity
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Electricity Connection",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => electricity = v),
              ),

              const SizedBox(height: 12),

              // Bank
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Bank Account",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => bank = v),
              ),
            ],

            //////Health section

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Health & Nutrition Indicators",
              isHealthExpanded,
                  () {
                setState(() => isHealthExpanded = !isHealthExpanded);
              },
            ),

            if (isHealthExpanded) ...[
              const SizedBox(height: 12),

              // Pregnant Women
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Pregnant Women in Household",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => pregnant = v),
              ),

              if (pregnant == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: pregnantCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Number of Pregnant Women",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Lactating Mothers
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Lactating Mothers",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => lactating = v),
              ),

              if (lactating == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: lactatingCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Number of Lactating Mothers",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Immunized
              if (hasYoungChildren()) ...[

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Children Fully Immunized",
                    border: OutlineInputBorder(),
                  ),
                  value: immunized,
                  items: ["Yes", "No"].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (v) => setState(() => immunized = v),
                ),

                const SizedBox(height: 10),
//////Aganwadi
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Children Attending Anganwadi",
                    border: OutlineInputBorder(),
                  ),
                  value: anganwadi,
                  items: ["Yes", "No"].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (v) => setState(() => anganwadi = v),
                ),
              ],

              const SizedBox(height: 12),

              // Delivery
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Institutional Delivery",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No", "Not Applicable"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => delivery = v),
              ),

              const SizedBox(height: 12),

              // Insurance
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Health Insurance Coverage",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => insurance = v),
              ),

              const SizedBox(height: 12),

              // Handwash
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Handwashing Facility with Soap",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => handwash = v),
              ),
            ],


            // ================= DISABILITY DETAILS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Disability Details",
              isDisabilityExpanded,
                  () {
                setState(() => isDisabilityExpanded = !isDisabilityExpanded);
              },
            ),

            if (isDisabilityExpanded) ...[
              const SizedBox(height: 12),

              // Any Disabled Member
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Any Disabled Member",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    disabled = v;
                  });
                },
              ),

              // Show count if Yes
              if (disabled == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: disabledCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Number of Disabled Members",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Type of Disability
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Type of Disability",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Blindness",
                  "Locomotor Disability",
                  "Hearing/Speech Disability",
                  "Mental Illness",
                  "Others"
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    disabilityType = v;
                  });
                },
              ),

              const SizedBox(height: 12),

              // Certificate
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Disability Certificate Available",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    certificate = v;
                  });
                },
              ),
            ],




            // ================= MIGRATION DETAILS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Migration Details",
              isMigrationExpanded,
                  () {
                setState(() => isMigrationExpanded = !isMigrationExpanded);
              },
            ),

            if (isMigrationExpanded) ...[
              const SizedBox(height: 12),

              // Number of Migrating Members
              TextField(
                controller: migratingMembersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Migrating Members",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  int total = members.length;
                  int entered = int.tryParse(val) ?? 0;

                  if (entered > total) {
                    showMsg("Max allowed is $total");
                    migratingMembersController.text = total.toString();
                    migratingMembersController.selection =
                        TextSelection.fromPosition(
                          TextPosition(offset: migratingMembersController.text.length),
                        );
                  }
                },
              ),

              const SizedBox(height: 12),

              // Days Migrated
              TextField(
                controller: daysMigratedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "No. of Days Migrated in a Year",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Work Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Type of Work",
                  border: OutlineInputBorder(),
                ),
                items: ["Skilled", "Unskilled"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    workType = v;
                  });
                },
              ),

              const SizedBox(height: 12),

              // Work Description
              TextField(
                decoration: const InputDecoration(
                  labelText: "Specify Type of Work",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  workDescription = v;
                },
              ),

              const SizedBox(height: 12),

              // Definition Text (Important)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Skilled Labour – Electrician, Plumber, Carpenter, Mason, Driver, Tailor, Machine Operator, Technician\n\n"
                      "Unskilled Labour – Agricultural labour, Construction labour/helper, Brick kiln worker, Daily wage labour, "
                      "Loading/unloading, Domestic work, Factory helper",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],

            // ================= HOUSEHOLD ASSETS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Household Assets",
              isAssetsExpanded,
                  () {
                setState(() => isAssetsExpanded = !isAssetsExpanded);
              },
            ),

            if (isAssetsExpanded) ...[
              const SizedBox(height: 12),

              ...assetControllers.keys.map((asset) {
                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(asset),
                      value: selectedAssets.contains(asset),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedAssets.add(asset);
                          } else {
                            selectedAssets.remove(asset);
                            assetControllers[asset]?.clear();
                          }
                        });
                      },
                    ),

                    if (selectedAssets.contains(asset))
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: TextField(
                          controller: assetControllers[asset],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Number of $asset",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ],



// ================= FAMILY INCOME DETAILS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Family Income Details",
              isIncomeExpanded,
                  () {
                setState(() => isIncomeExpanded = !isIncomeExpanded);
              },
            ),

            if (isIncomeExpanded) ...[
              const SizedBox(height: 12),

              // AGRICULTURE
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Income from Agriculture/Farming",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    agricultureIncome = v;

                    if (v == "No") {
                      agricultureController.clear();
                      isFarmingExpanded = false; // 👈 ADD THIS
                      calculateTotalIncome();
                    } else {
                      isFarmingExpanded = true; // 👈 ADD THIS
                    }
                  });
                },
              ),

              if (agricultureIncome == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: agricultureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Annual Income (Rs.)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => calculateTotalIncome(),
                ),
              ],

              const SizedBox(height: 12),

              // LIVESTOCK
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Income from Livestock",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    livestockIncome = v;

                    if (v == "No") {
                      livestockController.clear();
                      isLivestockExpanded = false;
                      calculateTotalIncome();
                    } else {
                      isLivestockExpanded = true;
                    }
                  });
                },
              ),

              if (livestockIncome == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: livestockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Annual Income (Rs.)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => calculateTotalIncome(),
                ),
              ],

              const SizedBox(height: 12),

              // SERVICE
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Income from Service",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    serviceIncome = v;

                    if (v == "No") {
                      serviceController.clear();
                      isServiceExpanded = false;
                      calculateTotalIncome();
                    } else {
                      isServiceExpanded = true;
                    }
                  });
                },
              ),

              if (serviceIncome == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: serviceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Annual Income (Rs.)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => calculateTotalIncome(),
                ),
              ],

              const SizedBox(height: 12),

              // SHOP
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Income from Shop/Enterprise",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    shopIncome = v;

                    if (v == "No") {
                      shopController.clear();
                      isEnterpriseExpanded = false;
                      calculateTotalIncome();
                    } else {
                      isEnterpriseExpanded = true;
                    }
                  });
                },
              ),

              if (shopIncome == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: shopController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Annual Income (Rs.)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => calculateTotalIncome(),
                ),
              ],

              const SizedBox(height: 12),

              // WAGES
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Income from Wages",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    wagesIncome = v;

                    if (v == "No") {
                      wagesController.clear();
                      isWagesExpanded = false;
                      calculateTotalIncome();
                    } else {
                      isWagesExpanded = true;
                    }
                  });
                },
              ),

              if (wagesIncome == "Yes") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: wagesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Annual Income (Rs.)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => calculateTotalIncome(),
                ),
              ],

              const SizedBox(height: 16),

              // TOTAL INCOME
              TextField(
                controller: totalIncomeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Total Income (Auto Calculated)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],


            // ================= FARMING STATUS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Farming Status",
              isFarmingExpanded,
                  () {
                if (agricultureIncome != "Yes") {
                  showMsg("Enable Agriculture Income first");
                  return;
                }

                setState(() => isFarmingExpanded = !isFarmingExpanded);
              },
            ),

            if (isFarmingExpanded) ...[
              const SizedBox(height: 12),

              // Land Holding
              TextField(
                controller: landHoldingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Land Holding (in Acre)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 12),

              // Lease Land
              TextField(
                controller: leaseLandController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Land taken on lease (in Acre)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 12),

              // Farmer Registered
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Farmer Registered on Ag./Hort Portal",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => farmerRegistered = v),
              ),

              const SizedBox(height: 16),

              // SHOW CROPS ONLY IF LAND AVAILABLE
              if (hasLand()) ...[
                const Text("Kharif Season Crops",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                ...kharifCrops.keys.map((crop) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text(crop),
                        value: selectedKharif.contains(crop),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedKharif.add(crop);
                            } else {
                              selectedKharif.remove(crop);
                              kharifCrops[crop]?.clear();
                            }
                          });
                        },
                      ),
                      if (selectedKharif.contains(crop))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: kharifCrops[crop],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Area for $crop (Acre)",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 16),

                const Text("Rabi Season Crops",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                ...rabiCrops.keys.map((crop) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text(crop),
                        value: selectedRabi.contains(crop),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedRabi.add(crop);
                            } else {
                              selectedRabi.remove(crop);
                              rabiCrops[crop]?.clear();
                            }
                          });
                        },
                      ),
                      if (selectedRabi.contains(crop))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: rabiCrops[crop],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Area for $crop (Acre)",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                const SizedBox(height: 16),

                const Text("Zaid Season Crops",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                ...zaidCrops.keys.map((crop) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text(crop),
                        value: selectedZaid.contains(crop),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedZaid.add(crop);
                            } else {
                              selectedZaid.remove(crop);
                              zaidCrops[crop]?.clear();
                            }
                          });
                        },
                      ),
                      if (selectedZaid.contains(crop))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: zaidCrops[crop],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Area for $crop (Acre)",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ],


// ================= LIVESTOCK STATUS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Livestock Status",
              isLivestockExpanded,
                  () {
                if (livestockIncome != "Yes") {
                  showMsg("Enable Livestock Income first");
                  return;
                }

                setState(() => isLivestockExpanded = !isLivestockExpanded);
              },
            ),

            if (isLivestockExpanded) ...[
              const SizedBox(height: 12),

              // Cow
              TextField(
                controller: cowController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Cow",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Buffalo
              TextField(
                controller: buffaloController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Buffalo",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Goat
              TextField(
                controller: goatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Goat",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Other Livestock
              TextField(
                controller: otherLivestockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Other Livestock",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Milk Production
              TextField(
                controller: milkProductionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Daily Milk Production",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Milk Sale
              TextField(
                controller: milkSaleController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Daily Milk Sale / Available for Sale",
                  border: OutlineInputBorder(),
                ),
              ),
            ],


            // ================= SERVICE STATUS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Service Status",
              isServiceExpanded,
                  () {
                if (serviceIncome != "Yes") {
                  showMsg("Enable Service Income first");
                  return;
                }

                setState(() => isServiceExpanded = !isServiceExpanded);
              },
            ),

            if (isServiceExpanded) ...[
              const SizedBox(height: 12),

              // Type of Service
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Type of Service",
                  border: OutlineInputBorder(),
                ),
                items: ["Government", "Private"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => serviceType = v),
              ),

              const SizedBox(height: 12),

              // Nature of Service
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Nature of Service",
                  border: OutlineInputBorder(),
                ),
                items: ["Permanent", "Adhock"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => serviceNature = v),
              ),

              const SizedBox(height: 12),

              // Job Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Job Type",
                  border: OutlineInputBorder(),
                ),
                items: ["Skilled", "Unskilled"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    jobType = v;
                    if (v != "Skilled") {
                      jobDetailsController.clear();
                    }
                  });
                },
              ),

              // Show Job Details if Skilled
              if (jobType == "Skilled") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: jobDetailsController,
                  decoration: const InputDecoration(
                    labelText: "Specify Job Details",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ],


// ================= ENTERPRISE / SHOP STATUS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Enterprise / Shop Status",
              isEnterpriseExpanded,
                  () {
                if (shopIncome != "Yes") {
                  showMsg("Enable Shop Income first");
                  return;
                }

                setState(() => isEnterpriseExpanded = !isEnterpriseExpanded);
              },
            ),

            if (isEnterpriseExpanded) ...[
              const SizedBox(height: 12),

              // Type of Enterprise
              TextField(
                controller: enterpriseTypeController,
                decoration: const InputDecoration(
                  labelText: "Type of Enterprise / Shop",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Location
              TextField(
                controller: enterpriseLocationController,
                decoration: const InputDecoration(
                  labelText: "Where Enterprise is Located",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              // Materials
              TextField(
                controller: shopMaterialController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "List of Materials (if shop)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],


            // ================= WAGES STATUS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Wages Status",
              isWagesExpanded,
                  () {
                if (wagesIncome != "Yes") {
                  showMsg("Enable Wages Income first");
                  return;
                }

                setState(() => isWagesExpanded = !isWagesExpanded);
              },
            ),

            if (isWagesExpanded) ...[
              const SizedBox(height: 12),

              // Work Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Type of Work",
                  border: OutlineInputBorder(),
                ),
                items: ["Skilled", "Unskilled"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    wagesWorkType = v;
                    if (v != "Skilled") {
                      wagesJobDetailsController.clear();
                    }
                  });
                },
              ),

              // Show details if Skilled
              if (wagesWorkType == "Skilled") ...[
                const SizedBox(height: 8),
                TextField(
                  controller: wagesJobDetailsController,
                  decoration: const InputDecoration(
                    labelText: "Specify Job Details",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ],


            // ================= GOVERNMENT SCHEME BENEFITS =================

            const SizedBox(height: 24),

            _buildExpandableHeader(
              "Government Scheme Benefits",
              isSchemeExpanded,
                  () {
                setState(() => isSchemeExpanded = !isSchemeExpanded);
              },
            ),

            if (isSchemeExpanded) ...[
              const SizedBox(height: 12),

              ...governmentSchemes.map((scheme) {
                return CheckboxListTile(
                  title: Text(scheme),
                  value: selectedSchemes.contains(scheme),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedSchemes.add(scheme);
                      } else {
                        selectedSchemes.remove(scheme);
                      }
                    });
                  },
                );
              }).toList(),
            ],





            const SizedBox(height: 24),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    submitSurvey();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0366A3) ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // rounded
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateTotalIncome() {
    int agri = int.tryParse(agricultureController.text) ?? 0;
    int live = int.tryParse(livestockController.text) ?? 0;
    int serv = int.tryParse(serviceController.text) ?? 0;
    int shop = int.tryParse(shopController.text) ?? 0;
    int wage = int.tryParse(wagesController.text) ?? 0;

    int total = agri + live + serv + shop + wage;

    totalIncomeController.text = total.toString();
  }

  bool hasLand() {
    double land = double.tryParse(landHoldingController.text) ?? 0;
    double lease = double.tryParse(leaseLandController.text) ?? 0;
    return (land + lease) > 0;
  }
  DateTime? selectedDateTime;
  void setCurrentDateTime() {
    final now = DateTime.now();

    // ✅ store actual DateTime (IMPORTANT)
    selectedDateTime = now;

    // ✅ UI format (no change)
    String formatted =
        "${now.day.toString().padLeft(2, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.year} "
        "${_formatTime(now)}";

    dateTimeController.text = formatted;
  }

  String _formatTime(DateTime time) {
    int hour = time.hour > 12 ? time.hour - 12 : time.hour;
    String period = time.hour >= 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      gpsController.text = "Location OFF";
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      gpsController.text = "Permission Denied";
      return;
    }

    // Get location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    gpsController.text =
    "${position.latitude}, ${position.longitude}";
  }

  Future<void> getProjects() async {
    setState(() {
      isProjectLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.paniinap.in/api/public/ProjectName"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['result'];

        projectList =
            list.map((e) => ProjectModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isProjectLoading = false;
    });
  }


  Future<void> getDistricts() async {
    setState(() {
      isDistrictLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("https://api.paniinap.in/api/public/DistrictName"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['result'];

        districtList =
            list.map((e) => CommonModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("District Error: $e");
    }

    setState(() {
      isDistrictLoading = false;
    });
  }

  Future<void> getBlocks(int districtId) async {
    setState(() {
      isBlockLoading = true;
      blockList = [];
      selectedBlock = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            "https://api.paniinap.in/api/public/TehsilName?dcode=$districtId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['result'];

        blockList = list.map((e) {
          return CommonModel(
            id: int.parse(e['ValueId']), // 👈 IMPORTANT (string to int)
            name: e['ValueText'],
          );
        }).toList();
      }
    } catch (e) {
      print("Block Error: $e");
    }

    setState(() {
      isBlockLoading = false;
    });
  }

  Future<void> getVillages(int blockId) async {
    setState(() {
      isVillageLoading = true;
      villageList = [];
      selectedVillage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            "https://api.paniinap.in/api/public/BlockName?tcode=$blockId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['result'];

        villageList = list.map((e) {
          return CommonModel(
            id: e['ValueId'], // already int
            name: e['ValueText'],
          );
        }).toList();
      }
    } catch (e) {
      print("Village Error: $e");
    }

    setState(() {
      isVillageLoading = false;
    });
  }
  Future<void> submitSurvey({bool isRetry = false}) async {
    HttpOverrides.global = MyHttpOverrides();

    if (gpsController.text.isEmpty ||
        gpsController.text == "Location OFF" ||
        gpsController.text == "Permission Denied") {

      showMsg("Please enable location first");

      await getCurrentLocation(); // try again

      return;
    }

    // 2️⃣ Project
    if (selectedProject == null || selectedProject!.name.isEmpty) {
      showMsg("Please select project name");
      return;
    }




    // ✅ PROJECT VALIDATION FIRST
    if (selectedProject == null || selectedProject!.name.isEmpty) {
      showMsg("Please select project name");
      return;
    }

    // ✅ FAMILY HEAD VALIDATION
    if (headNameController.text.trim().isEmpty) {
      showMsg("Enter Family Head Name");
      return;
    }

    if (headFatherController.text.trim().isEmpty) {
      showMsg("Enter Father / Husband Name");
      return;
    }

    if (headAge == null || headAge == 0) {
      showMsg("Select Age");
      return;
    }

    if (headGender == null || headGender!.isEmpty) {
      showMsg("Select Gender");
      return;
    }

    if (headEducation == null || headEducation!.isEmpty) {
      showMsg("Select Education");
      return;
    }

    if (headOccupation == null || headOccupation!.isEmpty) {
      showMsg("Select Occupation");
      return;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobileController.text)) {
      hideLoader();
      showMsg("Enter valid 10 digit mobile number");
      return;
    }
    showLoader(); // after validation
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final empid = await SharedPreferences.getInstance();
    int empId = empid.getInt("emp_id") ?? 0;

    if (token == null) {
      hideLoader();
      showToast("Session expired. Login again.");
      return;
    }

    var url = Uri.parse("https://api.paniinap.in/api/public/InsertSurvey");

    try {
      var body = {
        "Survey": {
          "SurveyId": "0",
          "HouseHold_Id": "",

          "ProjectName": selectedProject?.name ?? "",

          "SurveyDateTime": selectedDateTime != null? formatApiTime(selectedDateTime!)
              : "",
          "GPSLocation": gpsController.text,

          "StateName": "Uttar Pradesh",
          "DistrictName": selectedDistrict?.name ?? "",
          "BlockName": selectedBlock?.name ?? "",
          "VillageName": Villagecontroller.text,
          "HamletName": Hamletcontroller.text,

          "FamilyHeadName": headNameController.text,
          "FatherOrHusbandName": headFatherController.text,
          "MobileNumber": mobileController.text,
          "Age": headAge ?? 0,
          "Gender": headGender ?? "",
          "Education": headEducation ?? "",
          "PrimaryOccupation": headOccupation ?? "",

          "Religion": religion ?? "",
          "Category": category ?? "",
          "FamilyCard": familyCard ?? "",

          "HouseType": houseType ?? "",
          "DrinkingWaterSource": waterSource ?? "",
          "SolarEnergyConsumption": solar ?? "",
          "SolarUseType": solarType?? "",

          "ToiletFacility": toilet ?? "",
          "ElectricityConnection": electricity ?? "",
          "BankAccount": bank ?? "",

          "PregnantWomen": pregnant ?? "",
          "LactatingMothers": lactating ?? "",
          "ChildrenFullyImmunized":hasYoungChildren() ? immunized ?? "" : "",
          "ChildrenAnganwadi": hasYoungChildren() ? anganwadi ?? "" : "",

          "InstitutionalDelivery": delivery ?? "",
          "HealthInsurance": insurance ?? "",
          "HandwashingFacility": handwash ?? "",

          "DisabledMember": disabled ?? "",
          "DisabilityType": disabilityType ?? "",
          "DisabilityCertificate": certificate ?? "",

          "MigratingMembers": migratingMembersController.text,
          "MigrationDays": daysMigratedController.text,
          "MigrationWorkType": workType ?? "",

          "Assets": selectedAssets.join(","), // multi select
          "GovtSchemes": selectedSchemes.join(","),

          "IncomeAgriculture": int.tryParse(agricultureController.text) ?? 0,
          "IncomeLivestock": int.tryParse(livestockController.text) ?? 0,
          "IncomeService": int.tryParse(serviceController.text) ?? 0,
          "IncomeBusiness": int.tryParse(shopController.text) ?? 0,
          "IncomeWages": int.tryParse(wagesController.text) ?? 0,
          "TotalIncome": int.tryParse(totalIncomeController.text) ?? 0,

          "LandHolding": double.tryParse(landHoldingController.text) ?? 0,
          "LandLease": double.tryParse(leaseLandController.text) ?? 0,
          "FarmerRegistered": farmerRegistered ?? "",

          "CropKharif": selectedKharif.join(", "),
          "CropRabi": selectedRabi.join(","),
          "CropZaid": selectedZaid.join(","),

          "CowCount": int.tryParse(cowController.text) ?? 0,
          "BuffaloCount": int.tryParse(buffaloController.text) ?? 0,
          "GoatCount": int.tryParse(goatController.text) ?? 0,
          "OtherLivestock": int.tryParse(otherLivestockController.text) ?? 0,

          "DailyMilkProduction": int.tryParse(milkProductionController.text) ?? 0,
          "DailyMilkSale": int.tryParse(milkSaleController.text) ?? 0,

          "ServiceType": serviceType ?? "",
          "ServiceNature": serviceNature ?? "",
          "JobType": jobType ?? "",

          "EnterpriseType": enterpriseTypeController.text,
          "EnterpriseLocation": enterpriseLocationController.text,
          "ShopMaterials": shopMaterialController.text,

          "WorkType": wagesWorkType ?? "",

          "emp_id": empId, // 👉 replace if dynamic
          "CreatedAt": dateTimeController.text


        },

        // ✅ FAMILY MEMBERS LIST
        "FamilyMembers": members.map((e) => {
          "MemberName": e.name,
          "FatherOrHusbandName": e.fatherName,
          "RelationWithHead": e.relation,
          "Gender": e.gender,
          "Age": e.age,
          "Education": e.education,
          "PrimaryOccupation": e.occupation,
        }).toList(),

        // ✅ CHILDREN LIST
        "Children": children.map((e) => {
          "ChildName": e.name,
          "FatherName": e.fatherName,
          "RelationWithHead": e.relation,
          "Gender": e.gender,
          "Age": e.age,
          "MaritalStatus": e.maritalStatus,
          "Education": e.education,
          "EducationStatus": e.educationStatus,
          "SchoolingDetails": e.schooling,
        }).toList(),
      };

      log("PARAMETERS → ${jsonEncode(body)}");


      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      /// 🔥 HANDLE TOKEN EXPIRE
      if (response.statusCode == 401 && !isRetry) {
        debugPrint("⚠️ Token expired → refreshing");

        bool refreshed = await refreshTokenFlutter();

        if (refreshed) {
          hideLoader(); // 🔥 CLOSE OLD LOADER
          return submitSurvey(isRetry: true); // 🔁 retry once
        } else {
          showToast("Session expired. Please login again.");
          return;
        }
      }

      /// ✅ SUCCESS
      if (response.statusCode == 200) {
        hideLoader();
        var data = jsonDecode(response.body);

        showToast(data["msg"] ?? "Survey submitted successfully");
        // ✅ DEFINE HERE
        String resultMsg = data["result"] ?? "Survey submitted successfully";
        log("SUCCESS → $data");

        clearForm(); // ✅ only here

        // 🔥 Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SurveySuccessScreen(message: resultMsg),
          ),
        );

      } else {
        hideLoader();
        showToast("Submission failed");
        log("FAILED → ${response.body}");
      }

    } catch (e) {
      hideLoader();
      showToast("Error: $e");
      debugPrint("❌ ERROR → $e");
    }
  }

  void showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
  void clearForm() {
    headNameController.clear();
    headFatherController.clear();
    mobileController.clear();

    selectedDistrict = null;
    selectedBlock = null;
    selectedVillage = null;

    selectedKharif.clear();
    selectedRabi.clear();
    selectedZaid.clear();

    setState(() {});
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool hasYoungChildren() {
    return children.any((child) {
      return (child.age ?? 0) >= 0 && (child.age ?? 0) <= 5;
    });
  }
/////////  live hood logic
  bool hasAgricultureIncome() {
    return (int.tryParse(agricultureController.text) ?? 0) > 0;
  }

  bool hasLivestockIncome() {
    return (int.tryParse(livestockController.text) ?? 0) > 0;
  }

  bool hasServiceIncome() {
    return (int.tryParse(serviceController.text) ?? 0) > 0;
  }

  bool hasBusinessIncome() {
    return (int.tryParse(shopController.text) ?? 0) > 0;
  }

  bool hasWagesIncome() {
    return (int.tryParse(wagesController.text) ?? 0) > 0;
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

/////hide loader
  void hideLoader() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }


  //////migration validation
  bool validateMigrationSection() {

    // 🔴 Check family members exist
    if (members.isEmpty) {
      showMsg("Please add family members first");
      return false;
    }

    // 🔴 Check input empty
    if (migratingMembersController.text.isEmpty) {
      showMsg("Enter number of migrating members");
      return false;
    }

    int totalFamily = members.length;
    int migrated = int.tryParse(migratingMembersController.text) ?? 0;

    // 🔴 MAIN LOGIC (your requirement)
    if (migrated > totalFamily) {
      showMsg(
          "Migrated members ($migrated) cannot exceed total family members ($totalFamily)");
      return false;
    }

    return true;
  }
  String formatApiTime(DateTime dt) {
    return "${dt.year}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.day.toString().padLeft(2, '0')}T"
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}:"
        "${dt.second.toString().padLeft(2, '0')}";
  }
  }
