import 'package:flutter/material.dart';
import '../data/chess_constants.dart';

class ChessPiece extends StatelessWidget {
  final String piece;
  final double size;
  const ChessPiece({super.key, required this.piece, this.size = 40});

  @override
  Widget build(BuildContext context) {
    String unicode = ChessConstants.pieceUnicode[piece] ?? '?';
    bool isWhite = piece == piece.toUpperCase();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 2, offset: const Offset(1, 1))],
      ),
      child: Text(
        unicode,
        style: TextStyle(
          fontSize: size * 0.75,
          color: isWhite ? Colors.white : Colors.black,
          shadows: [Shadow(color: isWhite ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.3), blurRadius: 1)],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
