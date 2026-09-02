import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 Tambahkan import ini untuk SystemUiOverlayStyle
import '../../widgets/menu_secondary.dart';
import '../../widgets/logout_button.dart';
import '../../widgets/welcome_banner.dart';
import '../../widgets/main_menu_grid.dart';
import '../../services/ticket_service.dart';
import '../ticket/ticket_screen.dart';
import '../email/emails_screen.dart';
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
      {
        'title': 'Emails',
        'icon': Icons.contact_mail,
        'color': Colors.green.shade700,
        'screen': const EmailScreen(),
      },
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

    // Mengatur agar sistem navigasi Android menjadi transparan
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent, // 👈 Membikin bar bawah transparan
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true, 
        extendBody: true, // 👈 1. PENTING: Memperluas body sampai paling bawah layar
        appBar: AppBar(
          title: const Text(
            'RIEK',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [LogoutButton()],
        ),
        body: SizedBox.expand( // 👈 2. Memaksa Stack memenuhi 100% tinggi dan lebar layar HP
          child: Stack(
            children: [
              // 🖼️ LAYER BACKGROUND FULLSCREEN
              Positioned.fill(
                child: Image.asset(
                  'assets/homescreen_background.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'Gagal memuat latar: $error',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 📱 LAYER KONTEN UTAMA
              Positioned.fill(
                child: SafeArea(
                  bottom: false, // 👈 3. PENTING: Mematikan pembatasan aman di bagian bawah
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 32.0, // Beri sedikit jarak padding bawah agar konten tidak tertutup
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🚀 WELCOME BANNER
                        FutureBuilder<String>(
                          future: _firstNameFuture,
                          builder: (context, snapshot) {
                            final firstName = snapshot.data ?? 'Admin';
                            return WelcomeBanner(firstName: firstName);
                          },
                        ),
                        const SizedBox(height: 24),
                        MainMenuGrid(
                          menus: dashboardMenus,
                          onRefresh: _fetchTicketCount,
                        ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}