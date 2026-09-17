import 'package:flutter/material.dart';
import '../../models/orders_model.dart';
import 'add_order_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final details = order.orderDetails.isEmpty
        ? [
            OrderDetailItem(
              itemId: 0,
              itemName: order.itemName,
              quantity: 1,
              price: order.totalAmount,
            ),
          ]
        : order.orderDetails;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit order',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrderScreen(order: order),
                ),
              );

              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Order',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _infoRow('Order ID', order.id),
                  _infoRow('Customer', order.customerName),
                  _infoRow('Status', order.status),
                  _infoRow(
                    'Total',
                    'Rp ${order.totalAmount.toStringAsFixed(0)}',
                  ),
                  _infoRow('Tanggal', order.orderDate),
                  _infoRow('Keterangan', order.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Detail Item',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...details.map(
            (detail) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.shopping_bag_outlined),
                ),
                title: Text(detail.itemName),
                subtitle: Text('Qty: ${detail.quantity}'),
                trailing: Text(
                  'Rp ${detail.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
