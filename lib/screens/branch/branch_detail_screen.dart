import 'package:flutter/material.dart';
import '../../models/branch_model.dart';

class BranchDetailScreen extends StatelessWidget {
  final Branch branch;

  const BranchDetailScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${branch.name}')),
      body: Padding(
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
                  leading: const Icon(
                    Icons.flag,
                    size: 40,
                    color: Colors.grey,
                  ),
                  title: Text(
                    branch.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text('${branch.namaPt}'),
                ),
                const Divider(),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ID Branch:', style: TextStyle(fontSize: 12)),
                      Text(
                        branch.id,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ISP 1:', style: TextStyle(fontSize: 12)),
                      Text(
                        '${branch.namaIsp1} | ${branch.noIsp1}',
                        style: const TextStyle(color: Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ISP 2:', style: TextStyle(fontSize: 12)),
                      Text(
                        '${branch.namaIsp2} | ${branch.noIsp2}',
                        style: const TextStyle(color: Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Alamat:', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          branch.address,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
