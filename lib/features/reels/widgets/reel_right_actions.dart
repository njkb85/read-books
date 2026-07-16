import 'package:flutter/material.dart';

class ReelRightActions extends StatefulWidget {
  final int likes;
  final int comments;
  final int shares;
  final bool isSaved;
  final Function(bool)? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final Function(bool)? onSave;

  const ReelRightActions({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isSaved = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
  });

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

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Perfil
        _buildActionButton(
          icon: Icons.person_add_outlined,
          label: 'Seguir',
          onTap: () {},
        ),
        const SizedBox(height: 20),
        // Me gusta
        _buildActionButton(
          icon: _isLiked ? Icons.favorite : Icons.favorite_outline,
          label: _formatCount(widget.likes),
          color: _isLiked ? const Color(0xFFC96A2B) : Colors.white,
          onTap: () {
            setState(() {
              _isLiked = !_isLiked;
            });
            widget.onLike?.call(_isLiked);
          },
        ),
        const SizedBox(height: 20),
        // Comentarios
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: _formatCount(widget.comments),
          onTap: widget.onComment,
        ),
        const SizedBox(height: 20),
        // Compartir
        _buildActionButton(
          icon: Icons.send_outlined,
          label: _formatCount(widget.shares),
          onTap: widget.onShare,
        ),
        const SizedBox(height: 20),
        // Guardar
        _buildActionButton(
          icon: _isSaved ? Icons.bookmark : Icons.bookmark_outline,
          label: 'Guardar',
          onTap: () {
            setState(() {
              _isSaved = !_isSaved;
            });
            widget.onSave?.call(_isSaved);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
