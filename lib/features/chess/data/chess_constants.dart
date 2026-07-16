import 'package:flutter/material.dart';

class ChessConstants {
  static const boardSize = 8;
  static const lightSquareColor = Color(0xFFF0D9B5);
  static const darkSquareColor = Color(0xFFB58863);
  static const selectedSquareColor = Color(0xFF829769);
  static const legalMoveColor = Color(0xFF646E40);
  static const lastMoveColor = Color(0xFFCDD26A);
  static const checkColor = Color(0xFFFF4444);

  static const Map<String, String> pieceUnicode = {
    'K': '♔', 'Q': '♕', 'R': '♖', 'B': '♗', 'N': '♘', 'P': '♙',
    'k': '♚', 'q': '♛', 'r': '♜', 'b': '♝', 'n': '♞', 'p': '♟',
  };

  static const Map<String, int> pieceValues = {
    'p': 100, 'n': 320, 'b': 330, 'r': 500, 'q': 900, 'k': 20000,
    'P': 100, 'N': 320, 'B': 330, 'R': 500, 'Q': 900, 'K': 20000,
  };

  static const List<String> difficulties = [
    'Principiante',
    'Fácil',
    'Medio',
    'Difícil',
    'Maestro',
  ];

  static const List<int> eloLevels = [400, 800, 1200, 1800, 2400];
}
