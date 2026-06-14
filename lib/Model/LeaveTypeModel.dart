class LeaveTypeModel {
  final int valueId;
  final String valueText;

  LeaveTypeModel({
    required this.valueId,
    required this.valueText,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      valueId: json["ValueId"],
      valueText: json["ValueText"],
    );
  }
}