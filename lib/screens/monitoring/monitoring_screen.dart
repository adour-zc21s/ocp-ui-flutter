import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/branch_model.dart';
import '../../models/branch_status_model.dart';
import '../../services/branch_service.dart';
import '../../widgets/ip_status_card.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  final BranchService _branchService = BranchService();

  List<Branch> _branches = [];
  final Map<int, BranchStatus> _statuses = {};
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchAndCheckAll();

    // Auto-refresh semua status branch setiap 30 detik
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkAllBranchStatuses();
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
      final list = await _branchService.fetchBranches();
      if (mounted) {
        setState(() {
          _branches = list;
          _isLoading = false;
        });
        _checkAllBranchStatuses();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data branch: $e')));
      }
    }
  }

  // Cek status ke semua branch
  Future<void> _checkAllBranchStatuses() async {
    for (var branch in _branches) {
      final id = int.tryParse(branch.id) ?? 0;
      if (id != 0) {
        try {
          final status = await _branchService.checkBranchStatus(id);
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
  Future<void> _testSingleBranch(int branchId, String branchName) async {
    setState(() {
      _statuses.remove(branchId);
    });

    try {
      final status = await _branchService.checkBranchStatus(branchId);
      if (!mounted) return;

      setState(() {
        _statuses[branchId] = status;
      });

      final isOnline = status.isOnline;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isOnline
                ? 'Koneksi $branchName ONLINE (${status.ipPublic})'
                : 'Koneksi $branchName OFFLINE / Terputus',
          ),
          backgroundColor: isOnline ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal tes koneksi $branchName: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung statistik ringkas
    final total = _branches.length;
    final onlineCount = _statuses.values.where((s) => s.isOnline).length;
    final offlineCount = _statuses.values.where((s) => !s.isOnline).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Branch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Semua',
            onPressed: _fetchAndCheckAll,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _branches.isEmpty
          ? const Center(child: Text('Tidak ada data branch.'))
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
                          _buildStatItem('Total Branch', '$total', Colors.blue),
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

                  // Daftar Card Monitoring Setiap Branch
                  ..._branches.map((branch) {
                    final id = int.tryParse(branch.id) ?? 0;
                    final status = _statuses[id];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IpStatusCard(
                        branchName: branch.name,
                        ipPublic: branch.noIsp1,
                        status: status,
                        isLoading: status == null,
                        onTestPressed: () => _testSingleBranch(id, branch.name),
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
