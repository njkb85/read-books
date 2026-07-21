import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/category_chips.dart';
import 'widgets/post_card.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Sugeridos';
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refresh,
          color: const Color(0xFFD7A15D),
          backgroundColor: const Color(0xFF1A1A2E),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: HomeHeader()),
              SliverToBoxAdapter(child: const SizedBox(height: 4)),
              SliverToBoxAdapter(child: CategoryChips(onCategoryChanged: (cat) => setState(() => _selectedCategory = cat))),
              SliverToBoxAdapter(child: const SizedBox(height: 8)),
              SliverToBoxAdapter(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostScreen())), child: Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: isDark ? const Color(0xFF181818) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A2A2A))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFFD7A15D), Color(0xFFC96A2B)])), child: const Icon(Icons.add, color: Colors.black, size: 24)), const SizedBox(width: 12), Text('Que estas leyendo?', style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600], fontSize: 15)), const Spacer(), const Icon(Icons.image_outlined, color: Color(0xFF4CAF50), size: 22)])))),
              SliverToBoxAdapter(child: const SizedBox(height: 8)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').orderBy('createdAt', descending: true).limit(20).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.article_outlined, color: Colors.grey, size: 64), const SizedBox(height: 16), const Text('No hay publicaciones', style: TextStyle(color: Colors.grey, fontSize: 16)), const SizedBox(height: 8), const Text('Se el primero en publicar', style: TextStyle(color: Colors.grey, fontSize: 13))])));
                  }
                  final posts = snapshot.data!.docs;
                  return SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    final data = posts[index].data() as Map<String, dynamic>;
                    final isLiked = (data['likedBy'] as List?)?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;
                    return PostCard(post: PostModelReal(id: posts[index].id, username: data['userName'] ?? 'Usuario', handle: data['userHandle'] ?? '@usuario', userInitial: (data['userName'] ?? 'U').toString()[0].toUpperCase(), text: data['text'] ?? '', likes: data['likes'] ?? 0, comments: data['comments'] ?? 0, reposts: data['reposts'] ?? 0, timeAgo: _fmt(data['createdAt']), isLiked: isLiked), onLike: () async {
                      final ref = FirebaseFirestore.instance.collection('posts').doc(posts[index].id);
                      if (isLiked) { ref.update({'likes': FieldValue.increment(-1), 'likedBy': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])}); }
                      else { ref.update({'likes': FieldValue.increment(1), 'likedBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])}); }
                    });
                  }, childCount: posts.length));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(dynamic ts) { if (ts == null) return ''; final d = (ts as Timestamp).toDate(); final diff = DateTime.now().difference(d); if (diff.inMinutes < 60) return 'min'; if (diff.inHours < 24) return 'h'; return 'd'; }
}

class PostModelReal { final String id, username, handle, userInitial, text; final int likes, comments, reposts; final String timeAgo; final bool isVerified, isLiked; const PostModelReal({required this.id, required this.username, required this.handle, required this.userInitial, required this.text, required this.likes, required this.comments, required this.reposts, required this.timeAgo, this.isVerified = false, this.isLiked = false}); String get formattedLikes => likes >= 1000 ? 'K' : likes.toString(); String get formattedComments => comments >= 1000 ? 'K' : comments.toString(); }
