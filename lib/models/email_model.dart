class Email {
  final String id;
  final String perfectName;
  final String email;
  final String password;

  Email({
    required this.id,
    required this.perfectName,
    required this.email,
    required this.password,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: json['id']?.toString() ?? '',
      perfectName:
          (json['perfect_name'] ?? json['perfectName'])?.toString() ??
          'Unknown Device',
      email: json['email']?.toString() ?? 'Unknown Email',
      password: json['passwd']?.toString() ?? 'Unknown Password',
    );
  }
}
