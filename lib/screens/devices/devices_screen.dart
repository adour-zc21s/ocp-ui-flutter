import 'package:flutter/material.dart';
import '../../models/device_model.dart';
import '../../services/device_service.dart';
import '../../widgets/device_item_tile.dart';
import 'device_detail_screen.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final DeviceService _deviceService = DeviceService();
  late Future<List<Device>> _futureDevices;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    setState(() {
      _futureDevices = _deviceService.fetchDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Device'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDevices),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadDevices(),
        child: FutureBuilder<List<Device>>(
          future: _futureDevices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Tidak ada device yang tersedia.'),
              );
            }

            final devices = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DeviceItemTile(
                  device: devices[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceDetailScreen(device: devices[index]),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
