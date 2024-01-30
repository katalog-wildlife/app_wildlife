class RegisterInput{
  final String fullname;
  final String phonenumber;
  final String email;
  final String password;

  RegisterInput({
    required this.fullname,
    required this.phonenumber,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phonenumber": phonenumber,
    "email": email,
    "password": password,
  };
}

//respone register
class RegisterResponse {
  final String? token;
  final String message;
  final int status;

  RegisterResponse({
    this.token,
    required this.message,
    required this.status,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    token: json["data"] != null ? json["data"]["token"] : null,
    message: json["message"],
    status: json["status"],
  );
}