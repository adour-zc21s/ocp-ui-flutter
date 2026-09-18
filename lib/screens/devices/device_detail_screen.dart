import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib di-import untuk Clipboard
import '../../models/device_model.dart';

class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  // Fungsi helper untuk menyalin teks ke clipboard
  void _copyToClipboard(BuildContext context, String label, String text) {
    if (text.isEmpty || text == '-') return;

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${device.deviceName}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.devices,
                    size: 40,
                    color: Colors.grey,
                  ),
                  title: Text(
                    device.deviceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text('Branch: ${device.branchName}'),
                ),
                const Divider(height: 24),
                _buildDetailRow(context, 'ID Device:', device.id),
                _buildDetailRow(
                  context,
                  'Password:',
                  device.password,
                  isCopyable: true,
                ),
                _buildDetailRow(
                  context,
                  'IP:',
                  device.ipAddress),
                _buildDetailRow(
                  context,
                  'Password Portal:',
                  device.passwordPortal,
                  isCopyable: true,
                ),
                _buildDetailRow(context, 'Description:', device.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isCopyable = false,
  }) {
    final displayValue = value.isEmpty ? '-' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
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
                    icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Salin $label',
                    onPressed: () => _copyToClipboard(
                      context,
                      label.replaceAll(':', ''),
                      value,
                    ),
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
