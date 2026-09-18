import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/email_model.dart';

class EmailDetailScreen extends StatelessWidget {
  final Email email;

  const EmailDetailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${email.perfectName}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.contact_mail, size: 40, color: Colors.grey),
                  title: Text(
                    email.perfectName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('Perfect Name: ${email.perfectName}'),
                ),
                const Divider(height: 24),
                _DetailRow(label: 'ID Device:', value: email.id),
                _DetailRow(label: 'Email Address:', value: email.email, isCopyable: true),
                _DetailRow(label: 'Password:', value: email.password, isCopyable: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget privat terpisah agar kode utama tetap ringkas & reusable
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCopyable;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isCopyable = false,
  });

  void _copyToClipboard(BuildContext context) {
    if (value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    final cleanLabel = label.replaceAll(':', '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$cleanLabel berhasil disalin!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = value.isEmpty ? '-' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    displayValue,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCopyable && value.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.blue),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Salin ${label.replaceAll(':', '')}',
                    onPressed: () => _copyToClipboard(context),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}