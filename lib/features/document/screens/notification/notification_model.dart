class NotificationItem {
  final String id;
  final String userId;
  final String title;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final String type;
  final String? taskId;
  final String? documentId;
  final String? workflowId;
  final String? redirectUrl;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.type,
    this.taskId,
    this.documentId,
    this.workflowId,
    this.redirectUrl,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
      taskId: json['taskId'],
      documentId: json['documentId'],
      workflowId: json['workflowId'],
      redirectUrl: json['redirectUrl'],
    );
  }
}
