import 'package:flutter/material.dart';
import 'dashboard_grid.dart';

class MainMenuGrid extends StatelessWidget {
  final List<Map<String, dynamic>> menus;
  final VoidCallback onRefresh;

  const MainMenuGrid({super.key, required this.menus, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Main Menu',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DashboardGrid(menus: menus, onRefresh: onRefresh),
        ),
      ],
    );
  }
}
