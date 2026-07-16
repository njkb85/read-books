import 'chess_engine.dart';
import '../data/chess_constants.dart';

class MoveAnalyzer {
  static String analyzeMove(ChessEngine engine, int fromRow, int fromCol, int toRow, int toCol) {
    String? piece = engine.board[fromRow][fromCol];
    String? captured = engine.board[toRow][toCol];
    if (piece == null) return 'Sin pieza';

    List<String> comments = [];
    bool isWhite = engine.isWhitePiece(piece);
    String pieceName = _getPieceName(piece);
    String fromSquare = _toSquare(fromRow, fromCol);
    String toSquare = _toSquare(toRow, toCol);

    if (captured != null) {
      String capturedName = _getPieceName(captured);
      int pieceValue = ChessConstants.pieceValues[piece] ?? 0;
      int capturedValue = ChessConstants.pieceValues[captured] ?? 0;
      if (capturedValue >= pieceValue) {
        comments.add('✅ Excelente captura: $pieceName x $capturedName');
      } else if (capturedValue > 0) {
        comments.add('⚠️ Captura desfavorable');
      } else {
        comments.add('✓ Captura de $capturedName');
      }
    }

    if (_isCenter(toRow, toCol)) {
      comments.add('✅ Control del centro');
    }

    if (engine.moveHistory.length <= 10 && piece.toUpperCase() != 'P' && _isDeveloping(fromRow, isWhite)) {
      comments.add('✅ Desarrollo de pieza en la apertura');
    }

    if (piece.toUpperCase() == 'K' && (toCol - fromCol).abs() == 2) {
      comments.add('✅ Enroque: rey más seguro');
    }

    if (_isFork(engine, toRow, toCol, isWhite)) {
      comments.add('✅ ¡Tenedor! Atacas dos piezas');
    }

    if (engine.isInCheck(!isWhite)) {
      comments.add('✅ ¡Jaque!');
    }

    if (engine.moveHistory.length <= 8) {
      if (piece.toUpperCase() == 'N' && _isKnightOnRim(toRow, toCol)) {
        comments.add('⚠️ Capablanca: "Caballo en el borde, caballo sin orden"');
      }
      if (piece.toUpperCase() == 'Q' && engine.moveHistory.length <= 5) {
        comments.add('⚠️ Nimzowitsch: "No desarrolles la dama demasiado pronto"');
      }
    }

    if (comments.isEmpty) {
      comments.add('✓ Movimiento aceptable');
    }

    return '$pieceName $fromSquare → $toSquare: ${comments.join(' | ')}';
  }

  static String _getPieceName(String piece) {
    switch (piece.toUpperCase()) {
      case 'K': return '♔ Rey';
      case 'Q': return '♕ Dama';
      case 'R': return '♖ Torre';
      case 'B': return '♗ Alfil';
      case 'N': return '♘ Caballo';
      case 'P': return '♙ Peón';
      default: return piece;
    }
  }

  static String _toSquare(int row, int col) {
    return '${String.fromCharCode(97 + col)}${8 - row}';
  }

  static bool _isCenter(int row, int col) {
    return (row >= 3 && row <= 4 && col >= 3 && col <= 4);
  }

  static bool _isDeveloping(int row, bool isWhite) {
    return isWhite ? row == 7 : row == 0;
  }

  static bool _isFork(ChessEngine engine, int row, int col, bool isWhite) {
    int attackedPieces = 0;
    List<List<int>> moves = engine.getLegalMoves(row, col);
    for (var move in moves) {
      String? target = engine.board[move[0]][move[1]];
      if (target != null && engine.isWhitePiece(target) != isWhite) {
        int targetValue = ChessConstants.pieceValues[target] ?? 0;
        if (targetValue >= 300) attackedPieces++;
      }
    }
    return attackedPieces >= 2;
  }

  static bool _isKnightOnRim(int row, int col) {
    return row == 0 || row == 7 || col == 0 || col == 7;
  }
}
