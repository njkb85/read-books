import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final VoidCallback? onMoreTap;

  const FeaturedCard({
    super.key,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF181D21),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            // Avatares superpuestos
            SizedBox(
              width: 72,
              height: 48,
              child: Stack(
                children: [
                  _buildAvatar(
                    color: const Color(0xFF7B61FF),
                    initial: 'L',
                    left: 0,
                  ),
                  _buildAvatar(
                    color: const Color(0xFF4CAF50),
                    initial: 'A',
                    left: 24,
                  ),
                  _buildAvatar(
                    color: const Color(0xFFC96A2B),
                    initial: 'M',
                    left: 48,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Textos
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: 'Sigue leyendo, '),
                        TextSpan(
                          text: 'te están esperando',
                          style: TextStyle(
                            color: Color(0xFFC96A2B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Nuevas conversaciones y recomendaciones',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Botón más
            GestureDetector(
              onTap: onMoreTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF262B2F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({
    required Color color,
    required String initial,
    required double left,
  }) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF181D21),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
