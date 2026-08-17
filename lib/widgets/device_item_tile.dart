import 'package:flutter/material.dart';
import '../models/device_model.dart';

class DeviceItemTile extends StatelessWidget {
  final Device device;
  final VoidCallback? onTap;

  const DeviceItemTile({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.devices,
            color: Colors.black54,
          ),
        ),
        title: Text(
          device.deviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('User: ${device.user} | Branch: ${device.branchName}'),
      ),
    );
  }
}
