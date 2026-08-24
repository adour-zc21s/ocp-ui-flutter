import 'package:flutter/material.dart';
import '../models/branch_model.dart';

class BranchItemTile extends StatelessWidget {
  final Branch branch;
  final VoidCallback? onTap;

  const BranchItemTile({super.key, required this.branch, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        isThreeLine: true,
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.flag,
            color: Colors.black54,
          ),
        ),
        title: Text(
          branch.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        subtitle: Text(
          branch.namaPt,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}