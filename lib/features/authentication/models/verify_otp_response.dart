class VerifyOtpResponse {
  final String content;
  final String message;
  final int statusCode;

  VerifyOtpResponse({
    required this.content,
    required this.message,
    required this.statusCode,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      content: json['content'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }
}
