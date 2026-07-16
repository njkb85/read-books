import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart' as app;
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Configuracion', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section('Cuenta'),
          _tile(Icons.person_outline, 'Editar perfil', () => Navigator.pop(context)),
          _tile(Icons.email_outlined, 'Cambiar email', () => _changeEmail(context)),
          _tile(Icons.lock_outline, 'Cambiar contrasena', () => _changePassword(context)),
          const SizedBox(height: 20),
          _section('Preferencias'),
          _switchTile(Icons.dark_mode, 'Modo oscuro', true, (v) {}),
          _switchTile(Icons.notifications_outlined, 'Notificaciones', true, (v) {}),
          const SizedBox(height: 20),
          _section('Soporte'),
          _tile(Icons.help_outline, 'Centro de ayuda', () {}),
          _tile(Icons.info_outline, 'Acerca de READ', () => _about(context)),
          const SizedBox(height: 30),
          Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                await context.read<app.AuthProvider>().logout();
                if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text('Cerrar sesion', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String t) => Padding(padding: const EdgeInsets.only(left: 8, bottom: 12), child: Text(t, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 14, fontWeight: FontWeight.bold)));
  Widget _tile(IconData icon, String title, VoidCallback onTap) => Container(margin: const EdgeInsets.only(bottom: 4), decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(14)), child: ListTile(leading: Icon(icon, color: Colors.grey[400], size: 22), title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)), trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 22), onTap: onTap, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  Widget _switchTile(IconData icon, String title, bool value, Function(bool) onChanged) => Container(margin: const EdgeInsets.only(bottom: 4), decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(14)), child: SwitchListTile(secondary: Icon(icon, color: Colors.grey[400], size: 22), title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)), value: value, onChanged: onChanged, activeColor: const Color(0xFFD7A15D)));

  void _changeEmail(BuildContext context) {
    final c = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: const Color(0xFF1A1A2E), title: const Text('Cambiar email', style: TextStyle(color: Colors.white)), content: TextField(controller: c, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Nuevo email', filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')), TextButton(onPressed: () { FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(c.text.trim()); Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Revisa tu email'), backgroundColor: Color(0xFF4CAF50))); }, child: const Text('Cambiar', style: TextStyle(color: Color(0xFFD7A15D))))]));
  }

  void _changePassword(BuildContext context) {
    final c = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: const Color(0xFF1A1A2E), title: const Text('Cambiar contrasena', style: TextStyle(color: Colors.white)), content: TextField(controller: c, obscureText: true, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Nueva contrasena', filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')), TextButton(onPressed: () { FirebaseAuth.instance.currentUser?.updatePassword(c.text.trim()); Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contrasena actualizada'), backgroundColor: Color(0xFF4CAF50))); }, child: const Text('Cambiar', style: TextStyle(color: Color(0xFFD7A15D))))]));
  }

  void _about(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: const Color(0xFF1A1A2E), title: const Text('READ', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 24, fontWeight: FontWeight.bold)), content: const Column(mainAxisSize: MainAxisSize.min, children: [Text('Version 1.0.0', style: TextStyle(color: Colors.white)), SizedBox(height: 8), Text('Tu red social de lectura', style: TextStyle(color: Colors.grey))]), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar', style: TextStyle(color: Color(0xFFD7A15D))))]));
  }
}
