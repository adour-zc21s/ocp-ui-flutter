import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/monitoring_model.dart';
import '../../services/monitoring_service.dart';
import '../../widgets/ip_status_card.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  final MonitoringService _monitoringService = MonitoringService();

  List<Monitoring> _monitoring = [];
  final Map<int, Monitoring> _statuses = {};
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchAndCheckAll();

    // Auto-refresh semua status branch setiap 30 detik
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Panggil method untuk memuat ulang daftar aplikasi dan statusnya
      _fetchAndCheckAll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Load daftar branch sekaligus cek statusnya
  Future<void> _fetchAndCheckAll() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final list = await _monitoringService.fetchMonitoring();
      if (mounted) {
        setState(() {
          _monitoring = list;
          _isLoading = false;
        });
        _checkAllMonitoringStatuses();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data monitoring: $e')));
      }
    }
  }

  // Cek status ke semua branch
  Future<void> _checkAllMonitoringStatuses() async {
    for (var monitor in _monitoring) {
      final id = monitor.id ?? 0;
      if (id != 0) {
        try {
          final status = await _monitoringService.checkMonitoringStatus(id);
          if (mounted) {
            setState(() {
              _statuses[id] = status;
            });
          }
        } catch (_) {}
      }
    }
  }

  // Test koneksi manual per item
  Future<void> _testSingleApplication(int id, String name) async {
    setState(() {
      _statuses.remove(id);
    });

    try {
      final status = await _monitoringService.checkMonitoringStatus(id);
      if (!mounted) return;

      setState(() {
        _statuses[id] = status;
      });

      final isOnline = status.isOnline;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isOnline
                ? 'Koneksi $name ONLINE (${status.ip})'
                : 'Koneksi $name OFFLINE / Terputus',
          ),
          backgroundColor: isOnline ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal tes koneksi $name: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung statistik ringkas
    final total = _monitoring.length;
    final onlineCount = _statuses.values.where((s) => s.isOnline).length;
    final offlineCount = _statuses.values.where((s) => !s.isOnline).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Application'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh All',
            onPressed: _fetchAndCheckAll,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _monitoring.isEmpty
          ? const Center(child: Text('Tidak ada data application.'))
          : RefreshIndicator(
              onRefresh: _fetchAndCheckAll,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Ringkasan Status Total
                  Card(
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Total Application', '$total', Colors.blue),
                          _buildStatItem(
                            'Online',
                            '$onlineCount',
                            Colors.green,
                          ),
                          _buildStatItem(
                            'Offline',
                            '$offlineCount',
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daftar Card Monitoring Setiap Application
                  ..._monitoring.map((monitor) {
                    final id = monitor.id ?? 0;
                    final status = _statuses[id];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IpStatusCard(
                        name: monitor.name,
                        ip: monitor.ip,
                        status: status,
                        isLoading: status == null,
                        onTestPressed: () => _testSingleApplication(id, monitor.name),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
