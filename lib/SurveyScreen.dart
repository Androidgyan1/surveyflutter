import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:surveyflutter/Model/CommonModel.dart';
import 'package:surveyflutter/Model/ProjectModel%20.dart';

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
      appBar: AppBar(title: const Text("Survey Form")),
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
                labelText: "Village",
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
                counterText: "",
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

                        TextField(
                          decoration:
                          const InputDecoration(labelText: "Name"),
                          onChanged: (val) => m.name = val,
                        ),

                        TextField(
                          decoration: const InputDecoration(
                              labelText: "Father Name"),
                          onChanged: (val) => m.fatherName = val,
                        ),

                        DropdownButtonFormField<String>(
                          decoration:
                          const InputDecoration(labelText: "Relation"),
                          items: ["Son", "Daughter", "Spouse"]
                              .map((e) => DropdownMenuItem(
                              value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => m.relation = val,
                        ),

                        DropdownButtonFormField<String>(
                          decoration:
                          const InputDecoration(labelText: "Gender"),
                          items: ["Male", "Female"]
                              .map((e) => DropdownMenuItem(
                              value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => m.gender = val,
                        ),

                        DropdownButtonFormField<int>(
                          decoration:
                          const InputDecoration(labelText: "Age"),
                          items: List.generate(
                            83,
                                (i) => DropdownMenuItem(
                              value: i + 18,
                              child: Text((i + 18).toString()),
                            ),
                          ),
                          onChanged: (val) => m.age = val,
                        ),

                        const SizedBox(height: 8),

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
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "Name of Child",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => child.name = val,
                        ),

                        const SizedBox(height: 10),

                        // Father Name
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "Father Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => child.fatherName = val,
                        ),

                        const SizedBox(height: 10),

                        // Relation
                        DropdownButtonFormField<String>(
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
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Male", "Female"]
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
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
                          decoration: const InputDecoration(
                            labelText: "Marital Status",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Married", "Unmarried"]
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
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
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
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
                          decoration: const InputDecoration(
                            labelText: "Education Status",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Continue", "Completed", "Dropout"]
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
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
                          decoration: const InputDecoration(
                            labelText: "Schooling",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Government School", "Private School"]
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
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
                decoration: const InputDecoration(
                  labelText: "Solar Energy Consumption",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => solar = v),
              ),

              const SizedBox(height: 12),

              // Solar Type
              TextField(
                decoration: const InputDecoration(
                  labelText: "Type of Solar Use",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => solarType = v,
              ),

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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Children Fully Immunized (0-5)",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No", "Don't Know"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => immunized = v),
              ),

              const SizedBox(height: 12),

              // Anganwadi
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Children attending Anganwadi",
                  border: OutlineInputBorder(),
                ),
                items: ["Yes", "No"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => anganwadi = v),
              ),

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
                      calculateTotalIncome();
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
                      calculateTotalIncome();
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
                      calculateTotalIncome();
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
                      calculateTotalIncome();
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
                      calculateTotalIncome();
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
            ElevatedButton(
              onPressed: () {
                // submit logic later
              },
              child: const Text("Submit"),
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

  void setCurrentDateTime() {
    final now = DateTime.now();

    // Format: 11-04-2026 10:30 AM
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



  }