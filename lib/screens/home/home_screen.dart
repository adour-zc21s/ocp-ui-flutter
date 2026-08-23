// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/dashboard_grid.dart';
import '../../widgets/menu_secondary.dart'; // 👈 Import MenuSecondary
import '../../widgets/logout_button.dart';
import '../../services/ticket_service.dart';
import '../ticket/ticket_screen.dart';
import '../ticket/ticket_open_request_page.dart';
import '../devices/devices_screen.dart';
import '../branch/branch_screen.dart';
import '../monitoring/monitoring_screen.dart';
import '../items/item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TicketService _ticketService = TicketService();
  late Future<int> _openTicketCountFuture;

  @override
  void initState() {
    super.initState();
    _fetchTicketCount();
  }

  void _fetchTicketCount() {
    setState(() {
      _openTicketCountFuture = _ticketService.fetchOpenRequestTickets().then(
        (list) => list.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashboardMenus = [
      {
        'title': 'Monitoring',
        'icon': Icons.monitor_heart,
        'color': Colors.green.shade700,
        'screen': const MonitoringScreen(),
      },
      {
        'title': 'Tickets',
        'icon': Icons.confirmation_number,
        'color': Colors.green.shade700,
        'screen': const TicketScreen(),
      },
      {
        'title': 'Devices',
        'icon': Icons.devices,
        'color': Colors.green.shade700,
        'screen': const DeviceScreen(),
      },
      {
        'title': 'Accounts',
        'icon': Icons.person,
        'color': Colors.green.shade700,
      },
      {'title': 'Emails', 'icon': Icons.email, 'color': Colors.green.shade700},
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'color': Colors.green.shade700,
      },
      {
        'title': 'Branches',
        'icon': Icons.flag,
        'color': Colors.green.shade700,
        'screen': const BranchScreen(),
      },
      {
        'title': 'Items',
        'icon': Icons.storefront,
        'color': Colors.green.shade700,
        'screen': const ItemScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TrackIT',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LogoutButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeBanner(),
            const SizedBox(height: 24),
            const Text(
              'Main Menu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Dashboard Grid
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
              child: DashboardGrid(menus: dashboardMenus),
            ),

            const SizedBox(height: 24),

            // 🚀 MENU SECONDARY
            MenuSecondary(
              title: 'Open Request Tickets',
              subtitle: 'Laporan permintaan tiket belum selesai',
              icon: Icons.assignment_outlined, // Icon Report
              iconColor: Colors.orange.shade800,
              iconBackgroundColor: Colors.orange.shade50,
              targetScreen: const TicketOpenRequestPage(),
              countFuture: _openTicketCountFuture,
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.green, Colors.white70]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, Admin',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Mau mengelola apa hari ini?',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
