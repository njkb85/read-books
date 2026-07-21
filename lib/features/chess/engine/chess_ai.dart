import 'dart:math';
import '../data/chess_constants.dart';

class ChessAI {
  final Random _random = Random();
  final int elo;

  ChessAI({this.elo = 1200});

  // Tiempo de "pensamiento": menos ELO = más lento
  Duration get thinkingTime {
    if (elo <= 400) return const Duration(milliseconds: 2500);   // Principiante: duda mucho
    if (elo <= 800) return const Duration(milliseconds: 1800);   // Fácil: duda bastante
    if (elo <= 1200) return const Duration(milliseconds: 1200);  // Medio: piensa un poco
    if (elo <= 1800) return const Duration(milliseconds: 600);   // Difícil: rápido
    return const Duration(milliseconds: 300);                     // Maestro: instantáneo
  }

  // Precisión: más ELO = más preciso
  double get accuracy {
    if (elo <= 400) return 0.10;    // 10% de acierto
    if (elo <= 800) return 0.30;    // 30%
    if (elo <= 1200) return 0.55;   // 55%
    if (elo <= 1800) return 0.80;   // 80%
    return 0.95;                     // 95% maestro
  }

  int evaluatePosition(List<List<String?>> board) {
    int score = 0;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece != null) {
          int value = ChessConstants.pieceValues[piece] ?? 0;
          bool isWhite = piece == piece.toUpperCase();
          if ((r >= 3 && r <= 4) && (c >= 3 && c <= 4)) value += 50;
          score += isWhite ? value : -value;
        }
      }
    }
    return score;
  }

  List<int>? selectMove(List<List<int>> allMoves, List<List<String?>> board) {
    if (allMoves.isEmpty) return null;

    List<_ScoredMove> scoredMoves = [];
    for (var move in allMoves) {
      int score = _rateMove(move, board);
      scoredMoves.add(_ScoredMove(move, score));
    }
    scoredMoves.sort((a, b) => b.score.compareTo(a.score));

    int topCount = (accuracy * scoredMoves.length).ceil().clamp(1, scoredMoves.length);
    int randomIndex = _random.nextInt(topCount);
    
    return scoredMoves[randomIndex].move;
  }

  int _rateMove(List<int> move, List<List<String?>> board) {
    int fromRow = move[0], fromCol = move[1];
    int toRow = move[2], toCol = move[3];
    
    String? piece = board[fromRow][fromCol];
    String? captured = board[toRow][toCol];
    int score = 0;

    if (captured != null) {
      int capturedValue = ChessConstants.pieceValues[captured] ?? 0;
      int pieceValue = ChessConstants.pieceValues[piece ?? ''] ?? 0;
      score += capturedValue * 10 - pieceValue;
    }

    if ((toRow >= 3 && toRow <= 4) && (toCol >= 3 && toCol <= 4)) score += 30;
    if (piece != null && piece.toUpperCase() != 'P') {
      int distToCenter = (toRow - 3.5).abs().toInt() + (toCol - 3.5).abs().toInt();
      score += (4 - distToCenter) * 5;
    }
    if (piece == 'p' && toRow >= 6) score += 50;
    if (piece == 'P' && toRow <= 1) score += 50;

    return score;
  }
}

class _ScoredMove {
  final List<int> move;
  final int score;
  _ScoredMove(this.move, this.score);
}
