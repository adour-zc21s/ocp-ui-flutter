import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/orders_model.dart';
import '../../models/item_model.dart';
import '../../services/order_service.dart';

class AddOrderScreen extends StatefulWidget {
  final Order? order;

  const AddOrderScreen({super.key, this.order});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final OrderService _orderService = OrderService();
  late Future<List<Item>> _futureItems;
  Item? _selectedItem;
  bool _isLoading = false;
  String _selectedStatus = 'diproses';

  final List<OrderItemRequest> _items = [];

  // Formatter Rupiah dengan pemisah ribuan
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _customerNameController.text = widget.order!.customerName;
      _descriptionController.text = widget.order!.description;
      _selectedStatus = widget.order!.status.isNotEmpty
          ? widget.order!.status
          : 'diproses';
      _items.addAll(
        widget.order!.orderDetails.map(
          (detail) => OrderItemRequest(
            itemId: detail.itemId,
            quantity: detail.quantity,
            priceAtPurchase: detail.price,
          ),
        ),
      );
    }
    _futureItems = _orderService.fetchOrderItems();
  }

  void _addItemToList() {
    final selectedItem = _selectedItem;
    final quantityText = _quantityController.text.trim();

    if (selectedItem == null || quantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item dan quantity wajib diisi.')),
      );
      return;
    }

    final itemId = int.tryParse(selectedItem.id);
    final quantity = int.tryParse(quantityText);

    if (itemId == null || quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity harus angka > 0.')),
      );
      return;
    }

    setState(() {
      _items.add(
        OrderItemRequest(
          itemId: itemId,
          quantity: quantity,
          priceAtPurchase: selectedItem.price,
        ),
      );
      _selectedItem = null;
      _quantityController.text = '1';
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambah minimal 1 item order.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.order != null) {
        await _orderService.updateOrder(
          id: widget.order!.id,
          customerName: _customerNameController.text.trim(),
          description: _descriptionController.text.trim(),
          status: _selectedStatus,
          orderDetails: _items,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order berhasil diperbarui.')),
          );
        }
      } else {
        await _orderService.createOrder(
          customerName: _customerNameController.text.trim(),
          description: _descriptionController.text.trim(),
          orderDetails: _items,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order berhasil dibuat.')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.order != null
                  ? 'Gagal memperbarui order: $e'
                  : 'Gagal membuat order: $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order != null ? 'Edit Order' : 'Tambah Order'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Customer',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Nama customer wajib diisi'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Masukkan deskripsi order',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Deskripsi wajib diisi'
                  : null,
            ),
            if (widget.order != null) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Order',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'diproses', child: Text('Diproses')),
                  DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                  }
                },
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Daftar Item',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Item>>(
                    future: _futureItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Item',
                            border: OutlineInputBorder(),
                          ),
                          child: SizedBox(
                            height: 24,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Item',
                            border: OutlineInputBorder(),
                          ),
                          child: Text('Gagal memuat item'),
                        );
                      }

                      final items = snapshot.data ?? <Item>[];
                      return DropdownButtonFormField<Item>(
                        initialValue: _selectedItem,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Pilih Item',
                          border: OutlineInputBorder(),
                        ),
                        items: items
                            .map(
                              (item) => DropdownMenuItem<Item>(
                                value: item,
                                child: Text(
                                  '${item.name} (${_currencyFormat.format(double.tryParse(item.price.toString()) ?? 0)})',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (item) {
                          setState(() => _selectedItem = item);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Qty',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              int currentValue =
                                  int.tryParse(_quantityController.text) ?? 0;
                              _quantityController.text = (currentValue + 1)
                                  .toString();
                            },
                            child: const Icon(Icons.arrow_drop_up, size: 18),
                          ),
                          InkWell(
                            onTap: () {
                              int currentValue =
                                  int.tryParse(_quantityController.text) ?? 0;
                              if (currentValue > 0) {
                                _quantityController.text = (currentValue - 1)
                                    .toString();
                              }
                            },
                            child: const Icon(Icons.arrow_drop_down, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addItemToList,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambah Item'),
              ),
            ),
            const SizedBox(height: 20),
            if (_items.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Item yang dipilih',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Item ID ${item.itemId}'),
                          Text('Qty ${item.quantity}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _items.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Belum ada item ditambahkan.'),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submitOrder,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _isLoading
                    ? 'Menyimpan...'
                    : (widget.order != null ? 'Update Order' : 'Simpan Order'),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
