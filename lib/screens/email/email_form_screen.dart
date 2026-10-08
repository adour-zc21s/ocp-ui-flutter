import 'package:flutter/material.dart';
import '../../models/email_model.dart';
import '../../services/email_service.dart';

class EmailFormScreen extends StatefulWidget {
  final Email? email;

  const EmailFormScreen({super.key, this.email});

  @override
  State<EmailFormScreen> createState() => _EmailFormScreenState();
}

class _EmailFormScreenState extends State<EmailFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _perfectNameController = TextEditingController();
  final _emailService = EmailService();
  bool _isSubmitting = false;

  bool get _isEditing => widget.email != null;

  @override
  void initState() {
    super.initState();
    final email = widget.email;
    if (email != null) {
      _emailController.text = email.email;
      _passwordController.text = email.password;
      _perfectNameController.text = email.perfectName;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _perfectNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final perfectName = _perfectNameController.text.trim();

    try {
      if (_isEditing) {
        await _emailService.updateEmail(
          id: widget.email!.id,
          email: email,
          password: password,
          perfectName: perfectName,
        );
      } else {
        await _emailService.addEmail(
          email: email,
          password: password,
          perfectName: perfectName,
        );
      }
      if (mounted) {
        Navigator.pop(
          context,
          Email(
            id: widget.email?.id ?? '',
            email: email,
            password: password,
            perfectName: perfectName,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan email: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Email' : 'Tambah Email')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final address = value?.trim() ?? '';
                if (address.isEmpty) return 'Email wajib diisi.';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(address)) {
                  return 'Format email tidak valid.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Password wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _perfectNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Perfect Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Perfect Name wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _save,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isEditing ? 'Simpan Perubahan' : 'Simpan Email'),
            ),
          ],
        ),
      ),
    );
  }
}
