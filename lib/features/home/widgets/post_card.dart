import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';

class PostCard extends StatefulWidget {
  final PostModelReal post;
  final VoidCallback? onLike;

  const PostCard({super.key, required this.post, this.onLike});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _isLiked;
  late bool _isSaved;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _isSaved = false;
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    widget.onLike?.call();
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.post.id);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Comentarios', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: postRef.collection('comments').orderBy('createdAt').snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData || snap.data!.docs.isEmpty) return const Text('No hay comentarios', style: TextStyle(color: Colors.grey));
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, i) {
                      final c = snap.data!.docs[i].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withOpacity(0.2)), child: Center(child: Text((c['userName'] ?? '?')[0], style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 14)))),
                        title: Text(c['userName'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Text(c['text'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _commentController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Escribe un comentario...', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)))),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_commentController.text.trim().isNotEmpty) {
                    postRef.collection('comments').add({
                      'userName': FirebaseAuth.instance.currentUser?.displayName ?? 'Usuario',
                      'text': _commentController.text.trim(),
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    postRef.update({'comments': FieldValue.increment(1)});
                    _commentController.clear();
                  }
                },
                child: const Icon(Icons.send, color: Color(0xFFD7A15D), size: 24),
              ),
            ]),
            const SizedBox(height: 20),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withOpacity(0.2)), child: Center(child: Text(widget.post.userInitial, style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 16)))),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text(widget.post.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), if (widget.post.isVerified) ...[const SizedBox(width: 4), Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFD7A15D), shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.black, size: 9))]]),
            Text(widget.post.handle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          const Spacer(),
          Text(widget.post.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
        const SizedBox(height: 10),
        Text(widget.post.text, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          GestureDetector(onTap: _showComments, child: Row(children: [const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20), const SizedBox(width: 4), Text(widget.post.formattedComments, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
          GestureDetector(onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reposteado'), backgroundColor: Color(0xFF4CAF50))), child: const Icon(Icons.repeat, color: Colors.grey, size: 20)),
          GestureDetector(onTap: _toggleLike, child: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : Colors.grey, size: 20)),
          GestureDetector(onTap: () => setState(() => _isSaved = !_isSaved), child: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: _isSaved ? const Color(0xFFD7A15D) : Colors.grey, size: 20)),
          GestureDetector(onTap: () => Share.share('${widget.post.username}: ${widget.post.text} - READ LIBROS'), child: const Icon(Icons.share_outlined, color: Colors.grey, size: 20)),
        ]),
      ]),
    );
  }
}
