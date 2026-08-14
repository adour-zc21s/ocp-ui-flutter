// lib/widgets/ticket_header_card.dart
import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class TicketHeaderCard extends StatelessWidget {
  final Ticket ticket;

  const TicketHeaderCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.judul,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('ID Tiket: ${ticket.id}'),
            Text('Status: ${ticket.status}'),
            Text('Dibuat: ${ticket.formattedCreatedAt}'),
          ],
        ),
      ),
    );
  }
}
