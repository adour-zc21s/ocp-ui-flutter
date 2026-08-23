// lib/models/ticket_model.dart
import '../../utils/date_formatter.dart';

class Ticket {
  final String id;
  final String noTiket;
  final String judul;
  final String status;
  final String createdAt;
  final String jenisDukungan;
  final String branch;

  Ticket({
    required this.id,
    required this.noTiket,
    required this.judul,
    required this.status,
    required this.createdAt,
    required this.jenisDukungan,
    required this.branch,
  });

  String get formattedCreatedAt => DateFormatter.formatShort(createdAt);

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id']?.toString() ?? '-',
      noTiket: json['noTiket'] ?? 'Tidak ada nomor tiket',
      judul: json['judul'] ?? json['subject'] ?? 'Tanpa Judul',
      status: json['status'] ?? 'OPEN',
      createdAt:
          json['createdAt']?.toString() ??
          json['createdDate']?.toString() ??
          '-',
      jenisDukungan: json['jenisDukungan'] ?? '-',
      branch: json['noTiket'] ?? '-'
    );
  }
}
