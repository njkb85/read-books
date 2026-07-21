import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/reel_top_bar.dart';
import 'widgets/reel_category_tabs.dart';
import 'widgets/reel_card.dart';
import 'create_reel_screen.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});
  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  String _selectedCategory = 'Sugeridos';
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reels').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Stack(
              children: [
                Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.video_library_outlined, color: Colors.grey, size: 64),
                    const SizedBox(height: 16),
                    const Text('No hay reels aun', style: TextStyle(color: Colors.grey, fontSize: 18)),
                    const SizedBox(height: 8),
                    const Text('Se el primero en publicar una frase', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateReelScreen())),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC96A2B)),
                      child: const Text('Crear Reel', style: TextStyle(color: Colors.white)),
                    ),
                  ]),
                ),
                Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: ReelTopBar(onCameraTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateReelScreen()))))),
                Positioned(top: 50, left: 0, right: 0, child: SafeArea(child: ReelCategoryTabs(onCategoryChanged: (cat) => setState(() => _selectedCategory = cat)))),
              ],
            );
          }

          final reels = snapshot.data!.docs;

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: reels.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final data = reels[index].data() as Map<String, dynamic>;
                  return ReelCard(
                    reel: ReelModelReal(
                      username: data['userName'] ?? 'Usuario',
                      quote: data['quote'] ?? '',
                      author: data['author'] ?? 'Anonimo',
                      description: data['question'] ?? '',
                      question: '',
                      musicInfo: 'Sonido original',
                      likes: data['likes'] ?? 0,
                      comments: data['comments'] ?? 0,
                      shares: data['shares'] ?? 0,
                      isVerified: false,
                    ),
                    isActive: true,
                  );
                },
              ),
              Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: ReelTopBar(onCameraTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateReelScreen()))))),
              Positioned(top: 50, left: 0, right: 0, child: SafeArea(child: ReelCategoryTabs(onCategoryChanged: (cat) => setState(() => _selectedCategory = cat)))),
              if (reels.isNotEmpty)
                Positioned(top: 100, left: 20, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)), child: Text('${_currentIndex + 1} de ${reels.length}', style: const TextStyle(color: Colors.white70, fontSize: 12)))),
            ],
          );
        },
      ),
    );
  }
}

class ReelModelReal {
  final String username, quote, author, description, question, musicInfo;
  final int likes, comments, shares;
  final bool isVerified;
  const ReelModelReal({required this.username, required this.quote, required this.author, required this.description, required this.question, required this.musicInfo, required this.likes, required this.comments, required this.shares, this.isVerified = false});
}
