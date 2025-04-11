class SendOtpResponse {
  final String content;
  final String message;
  final int size;
  final int statusCode;

  SendOtpResponse({
    required this.content,
    required this.message,
    required this.size,
    required this.statusCode,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      content: json['content'] ?? '',
      message: json['message'] ?? '',
      size: json['size'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }
}
