// lib/models/ticket_model.dart
import '../../utils/date_formatter.dart';

class Ticket {
  final String id;
  final String judul;
  final String status;
  final String createdAt;

  Ticket({
    required this.id,
    required this.judul,
    required this.status,
    required this.createdAt,
  });

  String get formattedCreatedAt => DateFormatter.formatShort(createdAt);
  
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id']?.toString() ?? '-',
      judul: json['judul'] ?? json['subject'] ?? 'Tanpa Judul',
      status: json['status'] ?? 'OPEN',
      createdAt:
          json['createdAt']?.toString() ??
          json['createdDate']?.toString() ??
          '-',
    );
  }
}
