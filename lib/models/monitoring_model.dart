class Monitoring {
  final int id;
  final String name;
  final String ip;
  final String port;
  final String description;
  final bool isOnline;

  Monitoring({
    required this.id,
    required this.name,
    required this.ip,
    required this.port,
    required this.description,
    required this.isOnline,
  });

  factory Monitoring.fromJson(Map<String, dynamic> json) {
    return Monitoring(
      id: json['id'] ?? 0,
      name: json['monitorName']?.toString() ?? 'Tanpa Nama',
      ip: json['ip']?.toString() ?? '-',
      port: json['port']?.toString() ?? '-',
      description: json['description']?.toString() ?? '-',
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}
