import 'opening_book.dart';

class ChessCoach {
  static String analyzeMove(int fromRow, int fromCol, int toRow, int toCol, List<List<String?>> board, List<String> moveHistory) {
    String? piece = board[fromRow][fromCol];
    String? captured = board[toRow][toCol];
    if (piece == null) return '';

    List<String> insights = [];
    String from = '${String.fromCharCode(97 + fromCol)}${8 - fromRow}';
    String to = '${String.fromCharCode(97 + toCol)}${8 - toRow}';

    // 1. Verificar libro de aperturas
    if (moveHistory.length <= 8) {
      if (OpeningBook.isBookMove(fromRow, fromCol, toRow, toCol, board)) {
        String? opening = OpeningBook.getOpeningName(moveHistory);
        if (opening != null) {
          insights.add('📖 Sigues la $opening');
        } else {
          insights.add('✅ Jugada de libro');
        }
      } else if (moveHistory.length <= 4) {
        insights.add('⚠️ Te has salido del libro de aperturas');
      }
    }

    // 2. Capturas
    if (captured != null) {
      String capturedName = _pieceName(captured);
      String pieceName = _pieceName(piece);
      int pieceVal = _pieceValue(piece);
      int capturedVal = _pieceValue(captured);
      
      if (capturedVal >= pieceVal) {
        insights.add('✅ Excelente captura: $pieceName x $capturedName');
      } else if (capturedVal > 0) {
        insights.add('⚠️ Captura desfavorable');
      }
    }

    // 3. Control del centro
    if ((toRow >= 3 && toRow <= 4) && (toCol >= 3 && toCol <= 4)) {
      insights.add('✅ Control del centro ($to)');
    }

    // 4. Desarrollo
    if (moveHistory.length <= 10) {
      if (piece.toUpperCase() == 'N' || piece.toUpperCase() == 'B') {
        if (_isDeveloping(fromRow, piece == piece.toUpperCase())) {
          insights.add('✅ Desarrollo de pieza menor');
        }
      }
    }

    // 5. Seguridad del rey
    if (piece.toUpperCase() == 'K' && (toCol - fromCol).abs() == 2) {
      insights.add('🛡️ Enroque: rey seguro');
    }

    // 6. Amenazas
    if (_threatensMate(toRow, toCol, board, piece == piece.toUpperCase())) {
      insights.add('⚡ Amenaza de mate');
    }

    // 7. Caballo en el borde
    if (piece.toUpperCase() == 'N' && (toRow == 0 || toRow == 7 || toCol == 0 || toCol == 7)) {
      insights.add('💡 Capablanca: "Caballo en el borde, mala decision"');
    }

    // 8. Dama prematura
    if (piece.toUpperCase() == 'Q' && moveHistory.length <= 6) {
      insights.add('💡 Nimzowitsch: "No desarrolles la dama muy pronto"');
    }

    if (insights.isEmpty) {
      insights.add('✓ Jugada aceptable');
    }

    return '${_pieceName(piece)} $from → $to\n${insights.join('\n')}';
  }

  static String _pieceName(String piece) {
    return {
      'K': '♔ Rey', 'Q': '♕ Dama', 'R': '♖ Torre', 'B': '♗ Alfil', 'N': '♘ Caballo', 'P': '♙ Peon',
      'k': '♚ Rey', 'q': '♛ Dama', 'r': '♜ Torre', 'b': '♝ Alfil', 'n': '♞ Caballo', 'p': '♟ Peon',
    }[piece] ?? piece;
  }

  static int _pieceValue(String piece) {
    return {
      'P': 1, 'N': 3, 'B': 3, 'R': 5, 'Q': 9, 'K': 100,
      'p': 1, 'n': 3, 'b': 3, 'r': 5, 'q': 9, 'k': 100,
    }[piece] ?? 0;
  }

  static bool _isDeveloping(int row, bool isWhite) => isWhite ? row == 7 : row == 0;
  
  static bool _threatensMate(int row, int col, List<List<String?>> board, bool isWhite) {
    // Simplificado: buscar rey enemigo en casillas adyacentes
    String enemyKing = isWhite ? 'k' : 'K';
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        int tr = row + dr, tc = col + dc;
        if (tr >= 0 && tr < 8 && tc >= 0 && tc < 8) {
          if (board[tr][tc] == enemyKing) return true;
        }
      }
    }
    return false;
  }
}
