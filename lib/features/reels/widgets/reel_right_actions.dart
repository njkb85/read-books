import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReelRightActions extends StatefulWidget {
  final int likes;
  final int comments;
  final int shares;
  final bool isSaved;
  final Function(bool)? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final Function(bool)? onSave;

  const ReelRightActions({super.key, required this.likes, required this.comments, required this.shares, this.isSaved = false, this.onLike, this.onComment, this.onShare, this.onSave});

  @override
  State<ReelRightActions> createState() => _ReelRightActionsState();
}

class _ReelRightActionsState extends State<ReelRightActions> {
  late bool _isLiked;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _isSaved = widget.isSaved;
  }

  String _format(int count) => count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}K' : count.toString();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _btn(Icons.person_add_outlined, 'Seguir'),
      const SizedBox(height: 20),
      GestureDetector(
        onTap: () { setState(() => _isLiked = !_isLiked); widget.onLike?.call(_isLiked); },
        child: Column(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle), child: Icon(_isLiked ? Icons.favorite : Icons.favorite_outline, color: _isLiked ? const Color(0xFFC96A2B) : Colors.white, size: 24)),
          const SizedBox(height: 4), Text(_format(widget.likes), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
        ]),
      ),
      const SizedBox(height: 20),
      GestureDetector(onTap: () => _showComments(context), child: _btn(Icons.chat_bubble_outline, _format(widget.comments))),
      const SizedBox(height: 20),
      GestureDetector(onTap: () => Share.share('Mira este reel en READ LIBROS!'), child: _btn(Icons.send_outlined, _format(widget.shares))),
      const SizedBox(height: 20),
      GestureDetector(onTap: () { setState(() => _isSaved = !_isSaved); widget.onSave?.call(_isSaved); }, child: _btn(_isSaved ? Icons.bookmark : Icons.bookmark_outline, 'Guardar')),
    ]);
  }

  Widget _btn(IconData icon, String label) {
    return Column(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 24)),
      const SizedBox(height: 4), Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w500)),
    ]);
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Comentarios', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Se el primero en comentar', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Comentar...', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)))),
            const SizedBox(width: 8),
            GestureDetector(onTap: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comentario publicado'), backgroundColor: Color(0xFF4CAF50))); }, child: const Icon(Icons.send, color: Color(0xFFD7A15D), size: 24)),
          ]),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
