import 'package:flutter/material.dart';
import '../../settings/settings_screen.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onEditTap;
  const ProfileHeader({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 26),
          const Text('Perfil', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            child: const Icon(Icons.settings, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }
}
