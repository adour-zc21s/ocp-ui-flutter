class BranchStatus {
  final int branchId;
  final String ipPublic;
  final bool isOnline;

  BranchStatus({
    required this.branchId,
    required this.ipPublic,
    required this.isOnline,
  });

  factory BranchStatus.fromJson(Map<String, dynamic> json) {
    return BranchStatus(
      branchId: json['id'] ?? 0,
      ipPublic: json['noIsp1']?.toString() ?? '-',
      isOnline: json['online'] ?? false,
    );
  }
}
