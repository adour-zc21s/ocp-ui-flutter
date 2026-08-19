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
  final _departmentController = TextEditingController();
  final _branchController = TextEditingController();

  String? _selectedEmailNotification;
  late Future<List<String>> _futureAccounts;
  final TicketService _ticketService = TicketService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Memuat data email dari API saat screen pertama kali dibuka
    _futureAccounts = _ticketService.fetchTicketAccounts();
  }

  Future<void> _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Panggil method add/create ticket dari TicketService
        await _ticketService.createTicket(
          judul: _judulController.text,
          emailNotification: _selectedEmailNotification!,
          branch: _branchController
              .text, // Atau _branchController.text jika berupa TextField
          departemen: _departmentController.text,
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
              FutureBuilder<List<String>>(
                future: _futureAccounts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const OutlineDropdownLoading(
                      label: 'Memuat Email...',
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Gagal memuat daftar email: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada akun email tersedia');
                  }

                  final emailList = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    value: _selectedEmailNotification,
                    decoration: const InputDecoration(
                      labelText: 'Email Notification',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    // Hanya menampilkan teks email pada item dropdown
                    items: emailList.map((email) {
                      return DropdownMenuItem<String>(
                        value: email,
                        child: Text(email),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEmailNotification = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email notification wajib dipilih'
                        : null,
                  );
                },
              ),

              // 3. DEPARTMENT
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Department wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              // 4. BRANCH
              TextFormField(
                controller: _branchController,
                decoration: const InputDecoration(
                  labelText: 'Branch',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Branch wajib diisi'
                    : null,
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
          )
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
