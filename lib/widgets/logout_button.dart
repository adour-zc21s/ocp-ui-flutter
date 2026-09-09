import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Log Out'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context, rootNavigator: true);
              Navigator.of(dialogContext, rootNavigator: true).pop();

              await AuthService().logout();

              if (context.mounted) {
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (routeContext) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.black87),
      tooltip: 'Log Out',
      onPressed: () => _showLogoutDialog(context),
    );
  }
}
