import 'package:flutter/material.dart';
import '../../widgets/menu_secondary.dart';
import '../../widgets/logout_button.dart';
import '../../widgets/welcome_banner.dart';
import '../../widgets/main_menu_grid.dart';
import '../../services/ticket_service.dart';
import '../ticket/ticket_screen.dart';
import '../ticket/ticket_open_request_page.dart';
import '../devices/devices_screen.dart';
import '../branch/branch_screen.dart';
import '../monitoring/monitoring_screen.dart';
import '../items/item_screen.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TicketService _ticketService = TicketService();
  final AuthService _authService = AuthService();
  late Future<int> _openTicketCountFuture;
  late Future<String> _firstNameFuture;

  @override
  void initState() {
    super.initState();
    _fetchTicketCount();
    _firstNameFuture = _authService.getFirstName();
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
          'RIEK',
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
            // 🚀 BUNGKUS WELCOME BANNER
            FutureBuilder<String>(
              future: _firstNameFuture,
              builder: (context, snapshot) {
                final firstName = snapshot.data ?? 'Admin';
                return WelcomeBanner(firstName: firstName);
              },
            ),
            const SizedBox(height: 24),
            MainMenuGrid(menus: dashboardMenus, onRefresh: _fetchTicketCount),
            const SizedBox(height: 24),
            MenuSecondary(
              title: 'Open Request Tickets',
              subtitle: 'Laporan permintaan tiket belum selesai',
              icon: Icons.assignment_outlined,
              iconColor: Colors.orange.shade800,
              iconBackgroundColor: Colors.orange.shade50,
              targetScreen: const TicketOpenRequestPage(),
              countFuture: _openTicketCountFuture,
            ),
            // ...
          ],
        ),
      ),
    );
  }
}
