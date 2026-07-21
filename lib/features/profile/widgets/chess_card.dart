import 'package:flutter/material.dart';
import '../../chess/chess_screen.dart';

class ChessCard extends StatelessWidget {
  const ChessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChessScreen())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF0D1B2A), Color(0xFF1B2838)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
          boxShadow: [
            BoxShadow(color: const Color(0xFFD7A15D).withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            // Tablero de ajedrez decorativo de fondo
            Positioned(
              right: -20,
              top: -10,
              child: Opacity(
                opacity: 0.08,
                child: Icon(Icons.grid_4x4, size: 180, color: const Color(0xFFD7A15D).withValues(alpha: 0.3)),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icono del ajedrez
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFD7A15D), Color(0xFFC96A2B)]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: const Color(0xFFD7A15D).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.sports_esports, color: Color(0xFF0D0D0D), size: 28),
                  ),
                  const SizedBox(width: 16),
                  // Textos
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajedrez',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Entrena tu mente con partidas\ncontra la IA o contra amigos',
                          style: TextStyle(color: Color(0xFF8899AA), fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  // Piezas decorativas
                  const Text('♟', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 32)),
                  const SizedBox(width: 4),
                  const Text('♚', style: TextStyle(color: Color(0xFFC96A2B), fontSize: 28)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
