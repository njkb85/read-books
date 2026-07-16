import 'package:flutter/material.dart';

class SalesHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;
  const SalesHeader({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          const Text('Ventas', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(Icons.more_vert, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
