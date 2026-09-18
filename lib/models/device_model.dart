class Device {
  final String id;
  final String deviceName;
  final String user;
  final String branchName;
  final String password;
  final String ipAddress;
  final String passwordPortal;
  final String description;

  Device({
    required this.id,
    required this.deviceName,
    required this.user,
    required this.branchName,
    required this.password,
    required this.ipAddress,
    required this.passwordPortal,
    required this.description,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id']?.toString() ?? '',
      deviceName: json['deviceName'] ?? 'Unknown Device',
      user: json['user'] ?? 'Unknown User',
      branchName: json['branchName'] ?? 'Unknown Branch',
      password: json['password'] ?? 'No Password',
      ipAddress: json['ip_address'] ?? json['ipAddress'] ?? '-',
      passwordPortal:
          json['passwordPortal']?.toString() ??
          'No Portal Password',
      description: json['description']?.toString() ?? 'Tidak ada deskripsi',
    );
  }
}
