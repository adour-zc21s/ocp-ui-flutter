class TicketComment {
  final String id;
  final String ticketId;
  final String comment;
  final String author;
  final String createdAt;

  TicketComment({
    required this.id,
    required this.ticketId,
    required this.comment,
    required this.author,
    required this.createdAt,
  });

  factory TicketComment.fromJson(Map<String, dynamic> json) {
    return TicketComment(
      id: json['id']?.toString() ?? '',
      ticketId: json['ticketId']?.toString() ?? '',
      comment: json['comment'] ?? '',
      author: json['commentedBy'] ?? json['user'] ?? 'Unknown',
      createdAt: json['createdAt']?.toString() ?? '-',
    );
  }
}
