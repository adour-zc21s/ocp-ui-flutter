import 'package:flutter/material.dart';
import '../models/email_model.dart';

class EmailItemTile extends StatelessWidget {
  final Email email;
  final VoidCallback? onTap;

  const EmailItemTile({super.key, required this.email, this.onTap});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.contact_mail,
            color: Colors.black54,
          ),
        ),
        title: Text(
          email.perfectName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        // subtitle: Text('email: ${email.email} | Pass: ${email.password}',
        subtitle: Text(
          'email: ${email.email}',
        style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
