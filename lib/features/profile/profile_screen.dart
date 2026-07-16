import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import 'data/user_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/user_info.dart';
import 'widgets/progress_card.dart';
import 'widgets/quick_access.dart';
import 'widgets/bookshelf.dart';
import 'widgets/settings_list.dart';
import 'edit_profile_screen.dart';
import '../chess/chess_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = auth.userProfile;

    final userModel = profile != null
        ? UserModel(name: profile['name'] ?? 'Elena Gomez', username: profile['username'] ?? '@elenag_reads', bio: profile['bio'] ?? 'Apasionada por la lectura.', booksRead: profile['booksRead'] ?? 148, followers: profile['followers'] ?? 3200, following: profile['following'] ?? 640, level: profile['level'] ?? 18, progress: 0.78, booksToNextLevel: 3, streakDays: profile['streakDays'] ?? 27, avgRating: (profile['avgRating'] ?? 4.9).toDouble())
        : const UserModel(name: 'Elena Gomez', username: '@elenag_reads', bio: 'Apasionada por la lectura.', booksRead: 148, followers: 3200, following: 640, level: 18, streakDays: 27, avgRating: 4.9);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              ProfileHeader(onEditTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
              const SizedBox(height: 16),
              UserInfo(user: userModel, onEditProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
              const SizedBox(height: 16),
              // BOTON DE AJEDREZ DIRECTAMENTE
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChessScreen())),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('♟ JUGAR AJEDREZ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                ),
              ),
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
              ProgressCard(user: userModel),
              const SizedBox(height: 16),
              SettingsList(onLogout: () async { await auth.logout(); if (context.mounted) Navigator.pushReplacementNamed(context, '/login'); }),
            ],
          ),
        ),
      ),
    );
  }
}
