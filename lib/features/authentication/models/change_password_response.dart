class ChangePasswordResponse {
  final String content;
  final String message;
  final int statusCode;

  ChangePasswordResponse({
    required this.content,
    required this.message,
    required this.statusCode,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      content: json['content'],
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}
