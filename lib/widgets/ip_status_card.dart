import 'package:flutter/material.dart';
import '../models/monitoring_model.dart';

class IpStatusCard extends StatelessWidget {
  final String name;
  final String? ip;
  final Monitoring? status;
  final bool isLoading;
  final VoidCallback? onTestPressed;

  const IpStatusCard({
    super.key,
    required this.name,
    this.ip,
    this.status,
    this.isLoading = false,
    this.onTestPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = status?.isOnline ?? false;
    final statusColor = isOnline ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Indikator Warna Status
            isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : CircleAvatar(backgroundColor: statusColor, radius: 8),
            const SizedBox(width: 12),

            // Informasi Branch
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines:
                        1, // 👈 Agar teks tidak meluap jika terlalu panjang
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'IP: ${ip ?? status?.ip ?? 'Memuat...'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Badge Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                isLoading ? 'PINGING...' : (isOnline ? 'ONLINE' : 'OFFLINE'),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),

            // Tombol Test Koneksi Manual
            IconButton(
              icon: const Icon(Icons.monitor_heart, color: Colors.blue),
              tooltip: 'Test Koneksi',
              onPressed: isLoading ? null : onTestPressed,
            ),
          ],
        ),
      ),
    );
  }
}
