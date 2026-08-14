class LoginRequest {
  final String email; // atau username, sesuaikan dengan backend Anda
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String? token;

  LoginResponse({this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['accessToken'] ?? json['data']?['token'],
    );
  }
}
