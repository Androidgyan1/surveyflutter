class ResponsibleEmployeeModel {
  final int id;
  final String name;

  ResponsibleEmployeeModel({
    required this.id,
    required this.name,
  });

  factory ResponsibleEmployeeModel.fromJson(
      Map<String, dynamic> json) {
    return ResponsibleEmployeeModel(
      id: json["ValueId"] ?? 0,
      name: json["ValueText"] ?? "",
    );
  }
}