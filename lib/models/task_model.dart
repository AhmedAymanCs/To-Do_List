class TaskModel {
  int? id;
  String name;
  int isCompleted;
  DateTime dueDate;

  TaskModel({
    this.id,
    required this.name,
    this.isCompleted = 0,
    required this.dueDate,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
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
