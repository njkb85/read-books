import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/home_header.dart';
import 'widgets/category_chips.dart';
import 'widgets/post_card.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _testSearch() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    print('=== USUARIOS EN FIRESTORE ===');
    print('Total: ${users.docs.length}');
    for (var doc in users.docs) {
      print('${doc.id}: ${doc.data()}');
    }
    print('=============================');
  }

  @override
  Widget build(BuildContext context) {
    _testSearch();
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(children: [
          const HomeHeader(),
          const SizedBox(height: 4),
          const CategoryChips(),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostScreen())),
            child: Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A2A2A))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFFD7A15D), Color(0xFFC96A2B)])), child: const Icon(Icons.add, color: Colors.black, size: 24)), const SizedBox(width: 12), const Text('Que estas leyendo?', style: TextStyle(color: Colors.grey, fontSize: 15)), const Spacer(), const Icon(Icons.image_outlined, color: Color(0xFF4CAF50), size: 22)])),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('posts').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No hay publicaciones', style: TextStyle(color: Colors.grey)));
                final posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final data = posts[index].data() as Map<String, dynamic>;
                    final isLiked = (data['likedBy'] as List?)?.contains(FirebaseAuth.instance.currentUser?.uid) ?? false;
                    return PostCard(
                      post: PostModelReal(id: posts[index].id, username: data['userName'] ?? 'Usuario', handle: data['userHandle'] ?? '@usuario', userInitial: (data['userName'] ?? 'U').toString()[0].toUpperCase(), text: data['text'] ?? '', likes: data['likes'] ?? 0, comments: data['comments'] ?? 0, reposts: data['reposts'] ?? 0, timeAgo: _fmt(data['createdAt']), isLiked: isLiked),
                      onLike: () async {
                        final ref = FirebaseFirestore.instance.collection('posts').doc(posts[index].id);
                        if (isLiked) { ref.update({'likes': FieldValue.increment(-1), 'likedBy': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])}); }
                        else { ref.update({'likes': FieldValue.increment(1), 'likedBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])}); }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  String _fmt(dynamic ts) {
    if (ts == null) return '';
    final d = (ts as Timestamp).toDate();
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class PostModelReal {
  final String id, username, handle, userInitial, text;
  final int likes, comments, reposts;
  final String timeAgo;
  final bool isVerified, isLiked;
  const PostModelReal({required this.id, required this.username, required this.handle, required this.userInitial, required this.text, required this.likes, required this.comments, required this.reposts, required this.timeAgo, this.isVerified = false, this.isLiked = false});
  String get formattedLikes => likes >= 1000 ? '${(likes / 1000).toStringAsFixed(1)}K' : likes.toString();
  String get formattedComments => comments >= 1000 ? '${(comments / 1000).toStringAsFixed(1)}K' : comments.toString();
}
