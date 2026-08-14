class Item {
  final String id;
  final String code;
  final String name;
  final double price;
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id']?.toString() ?? '-',
      name: json['name']?.toString() ?? 'Tanpa Nama',
      code: json['code']?.toString() ?? '-',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description']?.toString() ?? '-',
    );
  }
}

