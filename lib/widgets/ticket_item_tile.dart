import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class TicketItemTile extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onTap;

  const TicketItemTile({super.key, required this.ticket, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: Color.fromRGBO(224, 224, 224, 1),
          child: Icon(Icons.confirmation_number, color: Colors.black54),
        ),
        title: Text(
          ticket.noTiket,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        subtitle: Text(
          'Subject: ${ticket.judul}\nDibuat: ${ticket.formattedCreatedAt}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ticket.status.toUpperCase() == 'OPEN'
                ? Colors.green.shade100
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            ticket.status,
            style: TextStyle(
              color: ticket.status.toUpperCase() == 'OPEN'
                  ? Colors.green.shade800
                  : Colors.grey.shade800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
