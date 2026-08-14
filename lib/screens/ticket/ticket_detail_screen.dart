import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';
import '../../models/ticket_comment_model.dart';
import '../../services/ticket_service.dart';
import '../../widgets/ticket_header_card.dart'; // 👈 Import Header Widget
import '../../widgets/ticket_item_tile.dart'; // 👈 Import Item Tile Widget

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TicketService _ticketService = TicketService();
  final TextEditingController _commentController = TextEditingController();

  late Future<List<TicketComment>> _futureComments;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _futureComments = _ticketService.fetchTicketComments(widget.ticket.id);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);

    try {
      await _ticketService.addComment(widget.ticket.id, text,);
      _commentController.clear();
      _loadComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengirim komentar: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Tiket #${widget.ticket.id}')),
      body: Column(
        children: [
          // 1. PEMANGGILAN WIDGET TICKET HEADER CARD
          TicketHeaderCard(ticket: widget.ticket),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Komentar & Pesan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          // 2. LIST KOMENTAR DARI ENDPOINT GET /comments
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadComments(),
              child: FutureBuilder<List<TicketComment>>(
                future: _futureComments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Belum ada komentar pada tiket ini.'),
                    );
                  }

                  final comments = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              comment.author.isNotEmpty
                                  ? comment.author[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                          ),
                          title: Text(
                            comment.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(comment.comment),
                          ),
                          trailing: Text(
                            comment.createdAt,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // 3. WIDGET CONTOH PEMANGGILAN TICKET ITEM TILE (Jika ingin menampilkan ringkasan di bagian bawah)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TicketItemTile(
              ticket: widget.ticket,
              onTap: null, // Tanpa aksi navigasi ulang
            ),
          ),

          // 4. FORM INPUT TAMBAH KOMENTAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis balasan komentar...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _submitComment,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
