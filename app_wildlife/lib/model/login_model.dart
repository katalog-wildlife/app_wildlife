class LoginInput {
  final String email;
  final String password;
  LoginInput({
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class LoginResponse {
  final String? token;
  final String message;
  final int status;

  LoginResponse({
    this.token,
    required this.message,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["data"] != null ? json["data"]["token"] : null,
        message: json["message"],
        status: json["status"],
      );
}
