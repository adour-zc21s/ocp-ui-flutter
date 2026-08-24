import 'package:flutter/material.dart';
import '../../models/device_model.dart';

class DeviceDetailScreen extends StatelessWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${device.deviceName}')),
      body: Padding(
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
                const Divider(),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ID Device:', style: TextStyle(fontSize: 12)),
                      Text(
                        device.id,
                        style: const TextStyle(color: Colors.grey, fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('User:', style: TextStyle(fontSize: 12)),
                      Text(
                        device.user,
                        style: const TextStyle(color: Colors.grey, fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Password:', style: TextStyle(fontSize: 12)),
                      Text(
                        device.password,
                        style: const TextStyle(color: Colors.grey, fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Description:', style: TextStyle(fontSize: 12),
                      ),
                      Expanded(
                        child: Text(
                          device.description,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.grey, fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
