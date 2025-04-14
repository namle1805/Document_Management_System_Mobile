class Task {
  final String taskId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String taskStatus;
  final String taskType;

  Task({
    required this.taskId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.taskStatus,
    required this.taskType,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      taskStatus: json['taskStatus'],
      taskType: json['taskType'],
    );
  }
}
