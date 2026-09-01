import 'package:flutter/material.dart';

import 'home/home_screen.dart';
import 'ticket/ticket_screen.dart';
import 'account/my_account_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    TicketScreen(),
    HomeScreen(),
    MyAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      // 🚀 CONTAINER MENEMPEL DI BAWAH DENGAN SUDUT ATAS MEMBULAT
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0), // Melengkung di sudut kiri atas
            topRight: Radius.circular(24.0), // Melengkung di sudut kanan atas
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Bayangan ke arah atas
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey.shade100,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black87,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number),
                label: 'Ticket',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home), 
                label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Accounts',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
