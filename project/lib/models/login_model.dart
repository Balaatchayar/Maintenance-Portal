class LoginResponse {
  final String employeeId;
  final String password;

  LoginResponse({
    required this.employeeId,
    required this.password,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      employeeId: json['employeeId'] ?? '',
      password: json['password'] ?? '',
    );
  }
}