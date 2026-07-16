import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../data/user_model.dart';

class UserInfo extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEditProfile;
  final VoidCallback? onShare;
  final VoidCallback? onSettings;

  const UserInfo({super.key, required this.user, this.onEditProfile, this.onShare, this.onSettings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Stack(children: [
                Container(width: 85, height: 85, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD7A15D), width: 2), gradient: const LinearGradient(colors: [Color(0xFF2A2A4E), Color(0xFF1A1A2E)])), child: Center(child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)))),
                Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: const Icon(Icons.camera_alt, color: Colors.black, size: 14))),
              ]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user.username, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(children: [const Icon(Icons.menu_book, color: Color(0xFFD7A15D), size: 16), const SizedBox(width: 4), Expanded(child: Text(user.bio, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis))]),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 3, child: GestureDetector(onTap: onEditProfile, child: Container(height: 44, decoration: BoxDecoration(color: const Color(0xFF2A1A0A), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFD7A15D).withOpacity(0.3), width: 0.5)), child: const Center(child: Text('Editar perfil', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 14, fontWeight: FontWeight.w600)))))),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final link = 'https://read-libros.web.app/perfil/${user.username}';
                  Share.share('Mira mi perfil en READ LIBROS: $link', subject: 'Perfil de ${user.name}');
                },
                child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.share_outlined, color: Colors.grey, size: 20)),
              ),
              const SizedBox(width: 10),
              GestureDetector(onTap: onSettings, child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.settings_outlined, color: Colors.grey, size: 20))),
            ],
          ),
        ],
      ),
    );
  }
}
