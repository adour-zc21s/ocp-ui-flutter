import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';
import '../../services/ticket_service.dart';
import 'ticket_detail_screen.dart';
import '../../widgets/ticket_item_tile.dart'; // 👈 Import widget kartu

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final TicketService _ticketService = TicketService();
  late Future<List<Ticket>> _futureTickets;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    setState(() {
      _futureTickets = _ticketService.fetchOpenTickets();
    });
  }

  Future<void> _refreshTickets() async {
    _loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tickets Management'),
          bottom: const TabBar(
            indicatorColor: Colors.brown,
            labelColor: Colors.brown,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.lock_open), text: 'Ticket Open'),
              Tab(icon: Icon(Icons.lock), text: 'Ticket Close'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: TICKET OPEN
            RefreshIndicator(
              onRefresh: _refreshTickets,
              child: FutureBuilder<List<Ticket>>(
                future: _futureTickets,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Terjadi kesalahan: ${snapshot.error}'),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada tiket open.'));
                  }

                  final tickets = snapshot.data!;
                  return ListView.builder(
                    itemCount: tickets.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return TicketItemTile(
                        ticket: tickets[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketDetailScreen(
                                ticket: tickets[index],
                              ),
                            ),
                          );
                          // Aksi klik ke detail tiket
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // TAB 2: TICKET CLOSE
            const Center(child: Text('Daftar Ticket Close (Selesai)')),
          ],
        ),
      ),
    );
  }
}
