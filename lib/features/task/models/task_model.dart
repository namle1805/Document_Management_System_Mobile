class Task {
  final String taskId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String taskStatus;
  final String taskType;

  final String scope;
  final String workflowName;
  final String stepAction;

  Task({
    required this.taskId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.taskStatus,
    required this.taskType,
    required this.scope,
    required this.workflowName,
    required this.stepAction,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final taskDto = json['taskDto'];

    return Task(
      taskId: taskDto['taskId'],
      title: taskDto['title'],
      description: taskDto['description'],
      startDate: DateTime.parse(taskDto['startDate']),
      endDate: DateTime.parse(taskDto['endDate']),
      taskStatus: taskDto['taskStatus'],
      taskType: taskDto['taskType'],
      scope: json['scope'] ?? '',
      workflowName: json['workflowName'] ?? '',
      stepAction: json['stepAction'] ?? '',
    );
  }
}
