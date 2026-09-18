import 'package:flutter/material.dart';
import '../../models/device_model.dart';

class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

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
                _buildDetailRow('ID Device:', device.id),
                _buildDetailRow('Password:', device.password),
                _buildDetailRow('IP:', device.ipAddress),
                _buildDetailRow('Password Portal:', device.passwordPortal),
                _buildDetailRow('Description:', device.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk menggantikan ListTile agar tata letak lebih rapi dan efisien
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
