class Branch {
  final String id;
  final String name;
  final String namaPt;
  final String namaIsp1;
  final String namaIsp2;
  final String noIsp1;
  final String noIsp2;
  final String address;

  Branch({
    required this.id,
    required this.name,
    required this.namaPt,
    required this.namaIsp1,
    required this.namaIsp2,
    required this.noIsp1,
    required this.noIsp2,
    required this.address,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id']?.toString() ?? '-',
      name: json['name']?.toString() ?? 'Tanpa Nama',
      namaPt: json['namaPt']?.toString() ?? 'Tanpa Nama PT',
      namaIsp1: json['namaIsp1']?.toString() ?? '-',
      namaIsp2: json['namaIsp2']?.toString() ?? '-',
      noIsp1: json['noIsp1']?.toString() ?? '-',
      noIsp2: json['noIsp2']?.toString() ?? '-',
      address: json['address']?.toString() ?? '-',
    );
  }
}