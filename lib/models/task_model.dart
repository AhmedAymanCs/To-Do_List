class TaskModel {
  String name;
  bool isCompleted;
  DateTime dueDate;

  TaskModel({
    required this.name,
    this.isCompleted = false,
    required this.dueDate,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      name: map['name'],
      isCompleted: map['isCompleted'] ?? false,
      dueDate: DateTime.parse(map['dueDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}
