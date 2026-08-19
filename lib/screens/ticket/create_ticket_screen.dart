import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controller & Variable State
  final _judulController = TextEditingController();
  // Selected Values
  String? _selectedDepartment;
  String? _selectedBranch;
  String? _selectedEmailNotification;
  // Futures
  late Future<List<Map<String, String>>> _futureAccounts;
  late Future<List<Map<String, String>>> _futureDepartments;
  late Future<List<Map<String, String>>> _futureBranches;
  final TicketService _ticketService = TicketService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Memuat seluruh data pendukung dari API
    _futureAccounts = _ticketService.fetchTicketAccounts();
    _futureDepartments = _ticketService.fetchTicketDepartments();
    _futureBranches = _ticketService.fetchTicketBranches();
  }

  Future<void> _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Panggil method add/create ticket dari TicketService
        await _ticketService.createTicket(
          judul: _judulController.text,
          emailNotification: _selectedEmailNotification!,
          branch: _selectedBranch!,
          departemen: _selectedDepartment!,
        );

        if (mounted) {
          // Kirim nilai true ke layar sebelumnya untuk memicu refresh
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal membuat tiket: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Tiket Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. JUDUL TIKET
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tiket',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // 2. EMAIL NOTIFICATION
              FutureBuilder<List<Map<String, String>>>(
                future: _futureAccounts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const OutlineDropdownLoading(
                      label: 'Memuat Akun...',
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Gagal memuat akun: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada akun tersedia');
                  }

                  final accounts = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    value:
                        _selectedEmailNotification, // Variabel ini tetap menampung String (email)
                    decoration: const InputDecoration(
                      labelText: 'Email Notification',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    items: accounts.map((account) {
                      return DropdownMenuItem<String>(
                        value:
                            account['email'], // 👈 Nilai EMAIL yang akan disimpan/dikirim ke API
                        child: Text(
                          account['name']!,
                        ), // 👈 Nilai NAMA yang ditampilkan di layar
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEmailNotification =
                            value; // Menyimpan email yang dipilih
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email notification wajib dipilih'
                        : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // 3. DEPARTMENT DROPDOWN
              FutureBuilder<List<Map<String, String>>>(
                future: _futureDepartments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const OutlineDropdownLoading(
                      label: 'Memuat Department...',
                    );
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Text('Gagal memuat department');
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem<String>(
                        value:
                            item['name'], // Gunakan item['id'] jika backend menerima ID
                        child: Text(item['name']!),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedDepartment = val),
                    validator: (val) =>
                        val == null ? 'Department wajib dipilih' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // 4. BRANCH DROPDOWN
              FutureBuilder<List<Map<String, String>>>(
                future: _futureBranches,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const OutlineDropdownLoading(
                      label: 'Memuat Branch...',
                    );
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Text('Gagal memuat branch');
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedBranch,
                    decoration: const InputDecoration(
                      labelText: 'Branch',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    items: snapshot.data!.map((item) {
                      return DropdownMenuItem<String>(
                        value:
                            item['name'], // Gunakan item['id'] jika backend menerima ID
                        child: Text(item['name']!),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedBranch = val),
                    validator: (val) =>
                        val == null ? 'Branch wajib dipilih' : null,
                  );
                },
              ),
              const SizedBox(height: 24),

              // TOMBOL SIMPAN
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isLoading ? null : _submitTicket,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan Tiket',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Loading Placeholer untuk Dropdown
class OutlineDropdownLoading extends StatelessWidget {
  final String label;
  const OutlineDropdownLoading({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email),
      ),
      child: const SizedBox(
        height: 20,
        width: 20,
        child: Align(
          alignment: Alignment.centerLeft,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
