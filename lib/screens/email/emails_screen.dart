import 'package:flutter/material.dart';
import '../../models/email_model.dart';
import '../../services/email_service.dart';
import '../../widgets/email_item_tile.dart';
import 'email_detail_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final EmailService _emailService = EmailService();
  late Future<List<Email>> _futureEmails;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  void _loadEmails() {
    setState(() {
      _futureEmails = _emailService.fetchEmails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Email'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadEmails),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadEmails(),
        child: FutureBuilder<List<Email>>(
          future: _futureEmails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Tidak ada email yang tersedia.'),
              );
            }

            final emails = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: emails.length,
              itemBuilder: (context, index) {
                return EmailItemTile(
                  email: emails[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmailDetailScreen(email: emails[index]),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
