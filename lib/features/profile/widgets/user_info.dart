import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../data/user_model.dart';
import '../followers_screen.dart';

class UserInfo extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEditProfile;
  final VoidCallback? onShare;
  final VoidCallback? onSettings;

  const UserInfo({super.key, required this.user, this.onEditProfile, this.onShare, this.onSettings});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        String? photoUrl;
        String? photoBase64;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          photoUrl = data['photoUrl'];
          photoBase64 = data['photoBase64'];
        }

        Widget photoWidget;
        if (photoBase64 != null && photoBase64.toString().isNotEmpty) {
          photoWidget = Image.memory(base64Decode(photoBase64.toString()), fit: BoxFit.cover, width: 85, height: 85);
        } else if (photoUrl != null && photoUrl.toString().isNotEmpty) {
          photoWidget = Image.network(photoUrl.toString(), fit: BoxFit.cover, width: 85, height: 85, errorBuilder: (_, _, _) => Center(child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))));
        } else {
          photoWidget = Center(child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Row(children: [
              Stack(children: [
                Container(width: 85, height: 85, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD7A15D), width: 2), color: const Color(0xFF1A1A2E)), child: ClipOval(child: photoWidget)),
                Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: const Icon(Icons.camera_alt, color: Colors.black, size: 14))),
              ]),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.username, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 14)),
                const SizedBox(height: 6),
                Text(user.bio.isNotEmpty ? user.bio : 'Agrega una bio', style: TextStyle(color: user.bio.isNotEmpty ? Colors.grey : Colors.grey[600], fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
              ])),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _stat('', 'Libros'),
              GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersScreen(userId: currentUser?.uid ?? '', isFollowers: true))), child: _stat(user.formattedFollowers, 'Seguidores')),
              GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersScreen(userId: currentUser?.uid ?? '', isFollowers: false))), child: _stat('', 'Siguiendo')),
            ]),
            Row(children: [
              Expanded(flex: 3, child: GestureDetector(onTap: onEditProfile, child: Container(height: 44, decoration: BoxDecoration(color: const Color(0xFF2A1A0A), borderRadius: BorderRadius.circular(22)), child: const Center(child: Text('Editar perfil', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 14, fontWeight: FontWeight.w600)))))),
              const SizedBox(width: 10),
              GestureDetector(onTap: () => Share.share('READ: '), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.share_outlined, color: Colors.grey, size: 20))),
              const SizedBox(width: 10),
              GestureDetector(onTap: onSettings, child: Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.settings_outlined, color: Colors.grey, size: 20))),
            ]),
          ]),
        );
      },
    );
  }

  Widget _stat(String value, String label) {
    return Column(children: [Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))]);
  }
}
