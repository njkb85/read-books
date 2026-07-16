import 'package:flutter/material.dart';
import '../data/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _isLiked;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _isSaved = widget.post.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFD7A15D).withOpacity(0.2), shape: BoxShape.circle), child: Center(child: Text(widget.post.userInitial, style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 16)))),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(widget.post.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  if (widget.post.isVerified) ...[const SizedBox(width: 4), Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFD7A15D), shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.black, size: 9))],
                ]),
                Text(widget.post.handle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
              const Spacer(),
              Text(widget.post.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Text(widget.post.text, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14, height: 1.4)),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Container(height: 220, width: double.infinity, color: const Color(0xFF1A1A2E), child: const Center(child: Icon(Icons.book, color: Colors.white24, size: 48)))),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _btn(Icons.chat_bubble_outline, widget.post.formattedComments),
            _btn(Icons.repeat, widget.post.formattedReposts),
            GestureDetector(onTap: () => setState(() => _isLiked = !_isLiked), child: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : Colors.grey, size: 20)),
            GestureDetector(onTap: () => setState(() => _isSaved = !_isSaved), child: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: _isSaved ? const Color(0xFFD7A15D) : Colors.grey, size: 20)),
            const Icon(Icons.share_outlined, color: Colors.grey, size: 20),
          ]),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String label) {
    return Row(children: [Icon(icon, color: Colors.grey, size: 20), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }
}
