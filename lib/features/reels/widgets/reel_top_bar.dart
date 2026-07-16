import 'package:flutter/material.dart';

class ReelTopBar extends StatelessWidget {
  final VoidCallback? onCameraTap;

  const ReelTopBar({
    super.key,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hora
          const Text(
            '10:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
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
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          // Señal, WiFi, Batería
          const Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Icon(Icons.battery_std, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
