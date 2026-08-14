import 'package:flutter/material.dart';

// Import halaman-halaman yang digunakan pada Bottom Navigation
import 'home/home_screen.dart';
import 'ticket/ticket_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar tampilan layar
  final List<Widget> _screens = const [
    HomeScreen(),
    TicketScreen(),
    // DevicesScreen(),
    // AccountsScreen(),
    // EmailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        // ini warna background dari bottom navigation bar
        backgroundColor: Colors.black45,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Ticket',
          ),
          // BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Accounts'),
          // BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Emails'),
        ],
      ),
    );
  }
}
