// lib/screens/items/item_screen.dart
import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../services/item_service.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final ItemService _itemService = ItemService();
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = _itemService.fetchItems();
  }

  void _refreshItems() {
    setState(() {
      _futureItems = _itemService.fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Item'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshItems),
        ],
      ),
      body: FutureBuilder<List<Item>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data item.'));
          }

          final items = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _refreshItems(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              // 👈 Pengaturan Grid 2 Kolom
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 Kolom per baris
                crossAxisSpacing: 10, // Jarak antar kolom (samping)
                mainAxisSpacing: 10, // Jarak antar baris (atas-bawah)
                childAspectRatio:
                    2, // Rasio tinggi-lebar card (sesuaikan jika teks terpotong)
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Item
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Harga Item
                        Text(
                          '${(double.tryParse(item.price.toString()) ?? 0).toStringAsFixed(0)}K',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Deskripsi Item (Mengisi sisa ruang)
                        if (item.description.isNotEmpty)
                          Expanded(
                            child: Text(
                              item.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
