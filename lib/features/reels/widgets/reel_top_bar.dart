import 'package:flutter/material.dart';

class ReelTopBar extends StatelessWidget {
  final VoidCallback? onCameraTap;

  const ReelTopBar({super.key, this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hora actual
          const Text(
            '',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          // Botón cámara
          GestureDetector(
            onTap: onCameraTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
            ),
          ),
          // Espacio vacío
          const SizedBox(width: 60),
        ],
      ),
    );
  }
}
