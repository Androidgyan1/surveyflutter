class ProjectModel {
  final int id;
  final String name;

  ProjectModel({required this.id, required this.name});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['ValueId'],
      name: json['ValueText'],
    );
  }
}