class OrderDetailItem {
  final int itemId;
  final String itemName;
  final int quantity;
  final double price;

  const OrderDetailItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) {
    final item = json['item'] ?? json['product'];
    final itemName = item is Map
        ? (item['name']?.toString() ?? item['itemName']?.toString() ?? 'Produk')
        : 'Produk';
    final itemMap = item is Map ? item : <String, dynamic>{};
    final rawPrice =
        json['price'] ??
        json['unitPrice'] ??
        json['itemPrice'] ??
        json['totalPrice'] ??
        itemMap['price'] ??
        itemMap['unitPrice'];
    final parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;

    return OrderDetailItem(
      itemId:
          int.tryParse((json['itemId'] ?? item?['id'] ?? '0').toString()) ?? 0,
      itemName: itemName,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: parsedPrice,
    );
  }
}

class Order {
  final String id;
  final String customerName;
  final String itemName;
  final double totalAmount;
  final String status;
  final String description;
  final String orderDate;
  final String branchName;
  final List<OrderDetailItem> orderDetails;

  const Order({
    required this.id,
    required this.customerName,
    required this.itemName,
    required this.totalAmount,
    required this.status,
    required this.description,
    required this.orderDate,
    required this.branchName,
    this.orderDetails = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final customerName =
        json['customerName']?.toString() ??
        json['customer_name']?.toString() ??
        'Customer';

    final details = json['orderDetails'] ?? json['order_details'];
    final parsedDetails = details is List
        ? details
              .whereType<Map>()
              .map(
                (item) =>
                    OrderDetailItem.fromJson(item.cast<String, dynamic>()),
              )
              .toList()
        : <OrderDetailItem>[];

    final itemNameFromList = parsedDetails.isNotEmpty
        ? parsedDetails.first.itemName
        : null;

    final total = json['totalAmount'] ?? json['amount'] ?? json['total'];
    final status = json['status']?.toString() ?? 'diproses';
    final description = json['description']?.toString() ?? 'Tidak ada keterangan';
    return Order(
      id: json['id']?.toString() ?? json['orderId']?.toString() ?? 'ORD-000',
      customerName: customerName,
      itemName:
          json['itemName']?.toString() ??
          json['item_name']?.toString() ??
          itemNameFromList ??
          'Produk',
      totalAmount: (total is num) ? total.toDouble() : 0.0,
      status: status,
      description: description,
      orderDate:
          json['orderDate']?.toString() ??
          json['createdAt']?.toString() ??
          json['created_at']?.toString() ??
          '2026-09-16',
      branchName:
          json['branchName']?.toString() ??
          json['branch_name']?.toString() ??
          json['branch']?.toString() ??
          'Cabang',
      orderDetails: parsedDetails,
    );
  }
}

class OrderItemRequest {
  final int itemId;
  final int quantity;

  const OrderItemRequest({required this.itemId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'item': {'id': itemId},
    'quantity': quantity,
  };
}

class CreateOrderRequest {
  final String customerName;
  final String description;
  final List<OrderItemRequest> orderDetails;

  const CreateOrderRequest({
    required this.customerName,
    required this.description,
    required this.orderDetails,
  });

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'description': description,
    'orderDetails': orderDetails.map((e) => e.toJson()).toList(),
  };
}
