import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/branch_model.dart';

class BranchDetailScreen extends StatelessWidget {
  final Branch branch;

  const BranchDetailScreen({super.key, required this.branch});

  void _copyToClipboard(BuildContext context, String text, String label) {
    if (text.isEmpty) return;
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
    final String isp1Info = '${branch.namaIsp1} | ${branch.noIsp1}';
    final String isp2Info = '${branch.namaIsp2} | ${branch.noIsp2}';

    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${branch.name}')),
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
                  leading: const Icon(Icons.flag, size: 40, color: Colors.grey),
                  title: Text(
                    branch.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(branch.namaPt),
                ),
                const Divider(height: 24),
                _buildDetailRow(context, 'ID Branch:', branch.id),
                _buildDetailRow(context, 'ISP 1:', isp1Info),
                _buildDetailRow(context, 'ISP 2:', isp2Info),
                _buildDetailRow(
                  context,
                  'Alamat:',
                  branch.address,
                  isCopyable: true,
                ),
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
    final displayValue = value.trim().isEmpty ? '-' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    displayValue,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true,
                  ),
                ),
                if (isCopyable && value.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: Colors.blue),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Salin ${label.replaceAll(':', '')}',
                    onPressed: () => _copyToClipboard(
                      context,
                      value,
                      label.replaceAll(':', ''),
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
