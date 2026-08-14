// lib/widgets/dashboard_grid.dart
import 'package:flutter/material.dart';

class DashboardGrid extends StatelessWidget {
  final List<Map<String, dynamic>> menus;

  const DashboardGrid({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return MenuItemTile(
          menu: menu,
        ); // 👈 Dipisah lagi menjadi widget tile tersendiri
      },
    );
  }
}

class MenuItemTile extends StatelessWidget {
  final Map<String, dynamic> menu;

  const MenuItemTile({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (menu['screen'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => menu['screen'] as Widget),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Menu ${menu['title']} belum tersedia')),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (menu['color'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(menu['icon'], color: menu['color'], size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            menu['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
