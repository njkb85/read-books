import 'package:flutter/material.dart';

class ChessControls extends StatelessWidget {
  final bool isPlayerTurn;
  final String gameStatus;
  final int evaluation;
  final VoidCallback? onUndo;
  final VoidCallback? onResign;
  final VoidCallback? onNewGame;

  const ChessControls({
    super.key,
    required this.isPlayerTurn,
    required this.gameStatus,
    this.evaluation = 0,
    this.onUndo,
    this.onResign,
    this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isPlayerTurn ? 'Tu turno' : 'Pensando...', style: TextStyle(color: isPlayerTurn ? const Color(0xFF4CAF50) : const Color(0xFFD7A15D), fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Eval: ${evaluation > 0 ? "+" : ""}$evaluation', style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          if (gameStatus.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF2A2A3E), borderRadius: BorderRadius.circular(8)), child: Text(gameStatus, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 14, fontWeight: FontWeight.bold))),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _btn(Icons.undo, 'Deshacer', onUndo),
              _btn(Icons.flag, 'Rendirse', onResign, true),
              _btn(Icons.refresh, 'Nueva', onNewGame),
            ],
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String label, VoidCallback? onTap, [bool red = false]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: red ? const Color(0xFFE53935).withValues(alpha: 0.2) : const Color(0xFF2A2A4E), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: red ? const Color(0xFFE53935) : Colors.white, size: 22)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: red ? const Color(0xFFE53935) : Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
