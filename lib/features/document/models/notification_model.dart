class NotificationModel {
  final String id;
  final String title;
  final String content;
  final bool isRead;
  final String createdAt;
  final String type;
  final String taskId;
  final String documentId;
  final String workflowId;
  final String redirectUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.type,
    required this.taskId,
    required this.documentId,
    required this.workflowId,
    required this.redirectUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
      type: json['type'],
      taskId: json['taskId'],
      documentId: json['documentId'],
      workflowId: json['workflowId'],
      redirectUrl: json['redirectUrl'],
    );
  }
}
