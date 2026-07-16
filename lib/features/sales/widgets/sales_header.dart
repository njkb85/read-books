import 'package:flutter/material.dart';
import '../../settings/settings_screen.dart';

class SalesHeader extends StatelessWidget {
  const SalesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          const Text('Ventas', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
