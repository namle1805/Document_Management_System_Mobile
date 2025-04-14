class TaskDetail {
  final String taskId;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String taskStatus;
  final String taskType;
  final String createdDate;
  final int taskNumber;
  final bool isDeleted;
  final bool isActive;
  final String stepId;
  final String documentId;
  final String userId;
  final dynamic commentIds;

  TaskDetail({
    required this.taskId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.taskStatus,
    required this.taskType,
    required this.createdDate,
    required this.taskNumber,
    required this.isDeleted,
    required this.isActive,
    required this.stepId,
    required this.documentId,
    required this.userId,
    this.commentIds,
  });

  factory TaskDetail.fromJson(Map<String, dynamic> json) {
    return TaskDetail(
      taskId: json['taskId'],
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      taskStatus: json['taskStatus'],
      taskType: json['taskType'],
      createdDate: json['createdDate'],
      taskNumber: json['taskNumber'],
      isDeleted: json['isDeleted'],
      isActive: json['isActive'],
      stepId: json['stepId'],
      documentId: json['documentId'],
      userId: json['userId'],
      commentIds: json['commentIds'],
    );
  }
}


class TaskContent {
  final TaskDetail taskDetail;
  final String scope;
  final String workflowName;
  final String stepAction;

  TaskContent({
    required this.taskDetail,
    required this.scope,
    required this.workflowName,
    required this.stepAction,
  });

  factory TaskContent.fromJson(Map<String, dynamic> json) {
    return TaskContent(
      taskDetail: TaskDetail.fromJson(json['taskDto']),
      scope: json['scope'],
      workflowName: json['workflowName'],
      stepAction: json['stepAction'],
    );
  }
}
