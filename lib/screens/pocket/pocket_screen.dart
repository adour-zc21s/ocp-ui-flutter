import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/pocket_service.dart';

class PocketScreen extends StatefulWidget {
  const PocketScreen({super.key});

  @override
  State<PocketScreen> createState() => _PocketScreenState();
}

class _PocketScreenState extends State<PocketScreen> {
  final PocketService _pocketService = PocketService();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  late Future<List<Map<String, dynamic>>> _futurePockets;

  @override
  void initState() {
    super.initState();
    _futurePockets = _pocketService.fetchPockets();
  }

  Future<void> _loadPockets() async {
    final future = _pocketService.fetchPockets();
    setState(() => _futurePockets = future);
    await future;
  }

  Future<void> _openAddItem(int pocketId) async {
    final addedEntry = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPocketItemScreen(pocketId: pocketId),
      ),
    );
    if (addedEntry == null || !mounted) return;

    final currentPockets = await _futurePockets;
    final updatedPockets = currentPockets.map((pocket) {
      if (pocket['id'].toString() != pocketId.toString()) return pocket;

      final items = (pocket['items'] is List)
          ? List<Map<String, dynamic>>.from(
              (pocket['items'] as List).whereType<Map>().map(
                (item) => item.cast<String, dynamic>(),
              ),
            )
          : <Map<String, dynamic>>[];
      items.insert(0, addedEntry);

      final amount = (addedEntry['amount'] as num).toDouble();
      final oldBalance = (pocket['totalBalance'] ?? pocket['balance'] ?? 0);
      final balance = oldBalance is num
          ? oldBalance.toDouble()
          : double.tryParse(oldBalance.toString()) ?? 0;
      final isExpense = addedEntry['type'] == 'PENGELUARAN';

      return {
        ...pocket,
        'items': items,
        'totalBalance': balance + (isExpense ? -amount : amount),
      };
    }).toList();

    setState(() => _futurePockets = Future.value(updatedPockets));
    _refreshAndKeepAddedEntry(pocketId, addedEntry);
  }

  Future<void> _refreshAndKeepAddedEntry(
    int pocketId,
    Map<String, dynamic> addedEntry,
  ) async {
    try {
      final refreshedPockets = await _pocketService.fetchPockets();
      final serverPocket = refreshedPockets
          .cast<Map<String, dynamic>?>()
          .firstWhere(
            (pocket) => pocket?['id'].toString() == pocketId.toString(),
            orElse: () => null,
          );
      if (serverPocket == null || !_containsEntry(serverPocket, addedEntry)) {
        return;
      }
      if (!mounted) return;
      setState(() => _futurePockets = Future.value(refreshedPockets));
    } catch (_) {
      // The optimistic list already shows the successfully created entry.
    }
  }

  bool _containsEntry(Map<String, dynamic> pocket, Map<String, dynamic> entry) {
    final items = pocket['items'];
    if (items is! List) return false;
    return items.whereType<Map>().any(
      (item) =>
          item['title'] == entry['title'] &&
          item['type'] == entry['type'] &&
          (item['amount'] as num?)?.toDouble() ==
              (entry['amount'] as num?)?.toDouble(),
    );
  }

  String _pocketTitle(Map<String, dynamic> pocket) =>
      (pocket['name'] ??
              pocket['pocketName'] ??
              pocket['title'] ??
              pocket['description'] ??
              pocket['id'] ??
              'Pocket')
          .toString();

  String _formatAmount(dynamic amount) {
    final value = amount is num
        ? amount.toDouble()
        : double.tryParse(amount?.toString() ?? '') ?? 0;
    return _currencyFormat.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket'),
        actions: [
          IconButton(
            onPressed: _loadPockets,
            tooltip: 'Muat ulang pocket',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futurePockets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat pocket: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loadPockets,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final pockets = snapshot.data ?? [];
          if (pockets.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => _loadPockets(),
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('Belum ada data pocket.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadPockets(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pockets.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final pocket = pockets[index];
                final rawItems = pocket['items'];
                final items = rawItems is List
                    ? rawItems
                          .whereType<Map>()
                          .map((item) => item.cast<String, dynamic>())
                          .toList()
                    : <Map<String, dynamic>>[];
                final description = pocket['description']?.toString();
                final pocketId = int.tryParse(pocket['id']?.toString() ?? '');

                return Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: const CircleAvatar(
                      child: Icon(Icons.account_balance_wallet_outlined),
                    ),
                    title: Text(_pocketTitle(pocket)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (description != null && description.isNotEmpty)
                          Text(description),
                        Text(
                          'Saldo: ${_formatAmount(pocket['totalBalance'] ?? pocket['balance'])}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        dense: true,
                        title: const Text('Tambah transaksi'),
                        trailing: IconButton(
                          tooltip: 'Tambah ke ${_pocketTitle(pocket)}',
                          onPressed: pocketId == null
                              ? null
                              : () => _openAddItem(pocketId),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ),
                      if (items.isEmpty)
                        const ListTile(
                          dense: true,
                          title: Text('Belum ada transaksi'),
                        )
                      else
                        ...items.map((item) {
                          final type = item['type']?.toString() ?? '';
                          final isExpense = type.toUpperCase() == 'PENGELUARAN';
                          final transactionDate = item['transactionDate']
                              ?.toString();
                          return ListTile(
                            dense: true,
                            title: Text(
                              item['title']?.toString() ?? 'Transaksi',
                            ),
                            subtitle: Text(
                              [
                                type,
                                if (transactionDate != null &&
                                    transactionDate.isNotEmpty)
                                  transactionDate,
                              ].join(' · '),
                            ),
                            trailing: Text(
                              '${isExpense ? '-' : '+'}${_formatAmount(item['amount'])}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );
                        }),
                    ],
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

class AddPocketItemScreen extends StatefulWidget {
  final int pocketId;

  const AddPocketItemScreen({super.key, required this.pocketId});

  @override
  State<AddPocketItemScreen> createState() => _AddPocketItemScreenState();
}

class _AddPocketItemScreenState extends State<AddPocketItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _pocketService = PocketService();
  static const _entryTypes = {
    'GAJI': 'GAJI',
    'PEMASUKAN LAIN': 'PEMASUKAN_LAIN',
    'PENGELUARAN': 'PENGELUARAN',
  };
  String? _selectedType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    setState(() => _isSubmitting = true);
    try {
      await _pocketService.addPocketEntry(
        title: _titleController.text.trim(),
        amount: amount,
        type: _selectedType!,
        pocketId: widget.pocketId,
      );
      if (mounted) {
        Navigator.pop<Map<String, dynamic>>(context, {
          'title': _titleController.text.trim(),
          'amount': amount,
          'type': _selectedType!,
          'transactionDate': DateTime.now().toIso8601String(),
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan item: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Item ${widget.pocketId}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Judul wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final amount = double.tryParse(
                  (value ?? '').trim().replaceAll(',', '.'),
                );
                return amount == null || amount <= 0
                    ? 'Masukkan nominal lebih dari 0.'
                    : null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Jenis',
                border: OutlineInputBorder(),
              ),
              items: _entryTypes.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.value,
                      child: Text(entry.key),
                    ),
                  )
                  .toList(),
              onChanged: (type) => setState(() => _selectedType = type),
              validator: (type) => type == null ? 'Pilih jenis.' : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              label: Text('Simpan ke Pocket ${widget.pocketId}'),
            ),
          ],
        ),
      ),
    );
  }
}
