import 'package:flutter/material.dart';
import '../../models/branch_model.dart';
import '../../services/branch_service.dart';
import '../../widgets/branch_item_tile.dart';
import 'branch_detail_screen.dart';
import 'dart:async';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final BranchService _branchService = BranchService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Branch>> _futureBranches;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadBranches() {
    setState(() {
      _searchController.clear();
      _futureBranches = _branchService.fetchBranches();
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Tunggu 500ms setelah selesai mengetik sebelum panggil API
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() {
          _futureBranches = _branchService.fetchBranches();
        });
      } else {
        setState(() {
          _futureBranches = _branchService.searchBranches(query.trim());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Branch'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadBranches),
        ],
      ),
      body: Column(
        children: [
          // Kolom Pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama branch...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _loadBranches,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Daftar Branch
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadBranches(),
              child: FutureBuilder<List<Branch>>(
                future: _futureBranches,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada branch yang ditemukan.'),
                    );
                  }

                  final branches = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: branches.length,
                    itemBuilder: (context, index) {
                      final branch = branches[index];
                      return BranchItemTile(
                        branch: branch,
                        onTap: () {
                          // Menutup keyboard jika masih terbuka sebelum navigasi
                          FocusScope.of(context).unfocus();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BranchDetailScreen(branch: branch),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
