// lib/widgets/comment_bubble_tile.dart
import 'package:flutter/material.dart';
import '../models/ticket_comment_model.dart';

class CommentBubbleTile extends StatelessWidget {
  final TicketComment comment;

  const CommentBubbleTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            comment.author.isNotEmpty ? comment.author[0].toUpperCase() : '?',
          ),
        ),
        title: Text(
          comment.author,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(comment.comment),
        trailing: Text(
          comment.createdAt,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }
}
