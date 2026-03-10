class TaskModel {
  String title;
  String description;

  TaskModel({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
    };
  }
}