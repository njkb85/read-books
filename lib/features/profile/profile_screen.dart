import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/providers/auth_provider.dart' as app_provider;
import 'data/user_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/user_info.dart' as ui;
import 'widgets/progress_card.dart';
import 'widgets/quick_access.dart';
import 'widgets/bookshelf.dart';
import 'widgets/creative_center.dart';
import 'widgets/settings_list.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<app_provider.AuthProvider>();
    final profile = auth.userProfile;
    final currentUser = FirebaseAuth.instance.currentUser;
    final isGuest = currentUser == null || currentUser.isAnonymous;

    final userModel = !isGuest && profile != null
        ? UserModel(name: profile['name'] ?? 'Usuario', username: profile['username'] ?? '@usuario', bio: profile['bio'] ?? 'Lector de READ', booksRead: profile['booksRead'] ?? 0, followers: profile['followers'] ?? 0, following: profile['following'] ?? 0, level: profile['level'] ?? 1, progress: 0.78, booksToNextLevel: 3, streakDays: profile['streakDays'] ?? 0, avgRating: (profile['avgRating'] ?? 0).toDouble())
        : const UserModel(name: 'Invitado', username: '@invitado', bio: 'Inicia sesion para personalizar tu perfil', booksRead: 0, followers: 0, following: 0, level: 1, streakDays: 0, avgRating: 0.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(children: [
            ProfileHeader(onEditTap: isGuest ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            const SizedBox(height: 16),
            ui.UserInfo(user: userModel, onEditProfile: isGuest ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            if (isGuest) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Container(margin: const EdgeInsets.symmetric(horizontal: 40), padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD7A15D), Color(0xFFC96A2B)]), borderRadius: BorderRadius.circular(16)), child: const Center(child: Text('Iniciar sesion / Registrarse', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)))),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF2A2A2A), thickness: 0.5, indent: 20, endIndent: 20),
            const SizedBox(height: 16),
            const QuickAccess(),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF2A2A2A), thickness: 0.5, indent: 20, endIndent: 20),
            const SizedBox(height: 16),
            const Bookshelf(),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF2A2A2A), thickness: 0.5, indent: 20, endIndent: 20),
            const SizedBox(height: 16),
            if (!isGuest) ProgressCard(user: userModel),
            const SizedBox(height: 16),
            const CreativeCenter(),
            const SizedBox(height: 16),
            if (!isGuest) SettingsList(onLogout: () async { await auth.logout(); if (context.mounted) Navigator.pushReplacementNamed(context, '/login'); }),
          ]),
        ),
      ),
    );
  }
}
