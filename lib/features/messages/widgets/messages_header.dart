import 'package:flutter/material.dart';

class MessagesHeader extends StatelessWidget {
  final VoidCallback? onMoreTap;

  const MessagesHeader({
    super.key,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mensajes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onMoreTap,
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
