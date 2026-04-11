class CommonModel {
  final int id;
  final String name;

  CommonModel({required this.id, required this.name});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      id: json['ValueId'],
      name: json['ValueText'],
    );
  }
}