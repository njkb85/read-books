import 'package:flutter/material.dart';

class SettingsList extends StatelessWidget {
  final VoidCallback? onLogout;

  const SettingsList({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item(Icons.person_outline, 'Cuenta', () {}),
      _Item(Icons.lock_outline, 'Privacidad', () {}),
      _Item(Icons.notifications_outlined, 'Notificaciones', () {}),
      _Item(Icons.dark_mode_outlined, 'Modo oscuro', () {}),
      _Item(Icons.help_outline, 'Ayuda', () {}),
      _Item(Icons.logout, 'Cerrar sesion', onLogout, true),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Configuracion', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(item.icon, color: item.isDestructive ? const Color(0xFFE53935) : Colors.grey[400], size: 22),
                title: Text(item.title, style: TextStyle(color: item.isDestructive ? const Color(0xFFE53935) : Colors.white, fontSize: 15)),
                trailing: Icon(Icons.chevron_right, color: Colors.grey[600], size: 22),
                onTap: item.onTap,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;
  const _Item(this.icon, this.title, this.onTap, [this.isDestructive = false]);
}
