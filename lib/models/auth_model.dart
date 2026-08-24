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
  final String? firstName;

  LoginResponse({this.token, this.firstName});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['accessToken'] ?? json['data']?['token'],
      firstName: json['first_name'], // 👈 Tangkap key 'first_name' dari backend
    );
  }
}
