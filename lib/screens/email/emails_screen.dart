import 'package:flutter/material.dart';
import '../../models/email_model.dart';
import '../../services/email_service.dart';
import '../../widgets/email_item_tile.dart';
import 'email_detail_screen.dart';
import 'dart:async';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final EmailService _emailService = EmailService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Email>> _futureEmails;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

@override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadEmails() {
    setState(() {
      _searchController.clear();
      _futureEmails = _emailService.fetchEmails();
    });
  }
  
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Tunggu 500ms setelah selesai mengetik sebelum panggil API
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() {
          _futureEmails = _emailService.fetchEmails();
        });
      } else {
        setState(() {
          _futureEmails = _emailService.searchEmails(query.trim());
        });
      }
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
      body: Column(
        children: [
          // Kolom Pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _loadEmails,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Daftar Email
          Expanded(
            child: RefreshIndicator(
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
                      child: Text('Tidak ada email yang ditemukan.'),
                    );
                  }

                  final emails = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: emails.length,
                    itemBuilder: (context, index) {
                      final email = emails[index];
                      return EmailItemTile(
                        email: email,
                        onTap: () {
                          // Menutup keyboard jika masih terbuka sebelum navigasi
                          FocusScope.of(context).unfocus();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EmailDetailScreen(email: email),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
