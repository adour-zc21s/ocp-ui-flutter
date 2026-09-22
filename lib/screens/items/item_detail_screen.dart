import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        'Rp${NumberFormat('#,##0', 'id_ID').format(double.tryParse(item.price.toString()) ?? 0)}';

    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${item.name}')),
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
                    Icons.local_mall,
                    size: 40,
                    color: Colors.grey,
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text('Code: ${item.code}'),
                ),
                const Divider(height: 24),
                _DetailRow(label: 'ID Item:', value: item.id),
                _DetailRow(label: 'Item Name:', value: item.name),
                _DetailRow(
                  label: 'Price:',
                  value: formattedPrice,
                  valueColor: Colors.green,
                  isBold: true,
                ),
                _DetailRow(label: 'Description:', value: item.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.grey,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Text(
              displayValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
