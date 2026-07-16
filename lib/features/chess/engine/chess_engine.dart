import '../data/chess_constants.dart';

class ChessEngine {
  late List<List<String?>> board;
  bool isWhiteTurn = true;
  bool gameOver = false;
  String? winner;
  String gameStatus = '';
  List<String> moveHistory = [];
  Map<String, bool> castlingRights = {'K': true, 'Q': true, 'k': true, 'q': true};
  List<int>? enPassantTarget;

  ChessEngine() {
    board = _createInitialBoard();
  }

  List<List<String?>> _createInitialBoard() {
    return [
      ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
      ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
      [null, null, null, null, null, null, null, null],
      [null, null, null, null, null, null, null, null],
      [null, null, null, null, null, null, null, null],
      [null, null, null, null, null, null, null, null],
      ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
      ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
    ];
  }

  void reset() {
    board = _createInitialBoard();
    isWhiteTurn = true;
    gameOver = false;
    winner = null;
    gameStatus = '';
    moveHistory = [];
    castlingRights = {'K': true, 'Q': true, 'k': true, 'q': true};
    enPassantTarget = null;
  }

  bool isWhitePiece(String? piece) {
    if (piece == null) return false;
    return piece == piece.toUpperCase();
  }

  bool isValidPosition(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  int? findKing(bool isWhite) {
    String king = isWhite ? 'K' : 'k';
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] == king) return r * 8 + c;
      }
    }
    return null;
  }

  List<List<int>> getLegalMoves(int row, int col) {
    String? piece = board[row][col];
    if (piece == null) return [];
    List<List<int>> moves = [];
    bool isWhite = isWhitePiece(piece);
    String pieceType = piece.toUpperCase();
    switch (pieceType) {
      case 'P': moves = _getPawnMoves(row, col, isWhite); break;
      case 'N': moves = _getKnightMoves(row, col, isWhite); break;
      case 'B': moves = _getBishopMoves(row, col, isWhite); break;
      case 'R': moves = _getRookMoves(row, col, isWhite); break;
      case 'Q': moves = [..._getBishopMoves(row, col, isWhite), ..._getRookMoves(row, col, isWhite)]; break;
      case 'K': moves = _getKingMoves(row, col, isWhite); break;
    }
    return moves.where((move) => !_wouldBeInCheck(row, col, move[0], move[1], isWhite)).toList();
  }

  List<List<int>> _getPawnMoves(int row, int col, bool isWhite) {
    List<List<int>> moves = [];
    int direction = isWhite ? -1 : 1;
    int startRow = isWhite ? 6 : 1;
    if (isValidPosition(row + direction, col) && board[row + direction][col] == null) {
      moves.add([row + direction, col]);
      if (row == startRow && board[row + 2 * direction][col] == null) {
        moves.add([row + 2 * direction, col]);
      }
    }
    for (int dc in [-1, 1]) {
      int newCol = col + dc;
      if (isValidPosition(row + direction, newCol)) {
        String? target = board[row + direction][newCol];
        if (target != null && isWhitePiece(target) != isWhite) {
          moves.add([row + direction, newCol]);
        }
        if (enPassantTarget != null && enPassantTarget![0] == row + direction && enPassantTarget![1] == newCol) {
          moves.add([row + direction, newCol]);
        }
      }
    }
    return moves;
  }

  List<List<int>> _getKnightMoves(int row, int col, bool isWhite) {
    List<List<int>> moves = [];
    List<List<int>> knightMoves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]];
    for (var move in knightMoves) {
      int newRow = row + move[0];
      int newCol = col + move[1];
      if (isValidPosition(newRow, newCol)) {
        String? target = board[newRow][newCol];
        if (target == null || isWhitePiece(target) != isWhite) {
          moves.add([newRow, newCol]);
        }
      }
    }
    return moves;
  }

  List<List<int>> _getBishopMoves(int row, int col, bool isWhite) {
    return _getSlidingMoves(row, col, isWhite, [[-1, -1], [-1, 1], [1, -1], [1, 1]]);
  }

  List<List<int>> _getRookMoves(int row, int col, bool isWhite) {
    return _getSlidingMoves(row, col, isWhite, [[-1, 0], [1, 0], [0, -1], [0, 1]]);
  }

  List<List<int>> _getSlidingMoves(int row, int col, bool isWhite, List<List<int>> directions) {
    List<List<int>> moves = [];
    for (var dir in directions) {
      for (int i = 1; i < 8; i++) {
        int newRow = row + dir[0] * i;
        int newCol = col + dir[1] * i;
        if (!isValidPosition(newRow, newCol)) break;
        String? target = board[newRow][newCol];
        if (target == null) {
          moves.add([newRow, newCol]);
        } else {
          if (isWhitePiece(target) != isWhite) moves.add([newRow, newCol]);
          break;
        }
      }
    }
    return moves;
  }

  List<List<int>> _getKingMoves(int row, int col, bool isWhite) {
    List<List<int>> moves = [];
    List<List<int>> kingMoves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];
    for (var move in kingMoves) {
      int newRow = row + move[0];
      int newCol = col + move[1];
      if (isValidPosition(newRow, newCol)) {
        String? target = board[newRow][newCol];
        if (target == null || isWhitePiece(target) != isWhite) {
          moves.add([newRow, newCol]);
        }
      }
    }
    if (isWhite) {
      if (castlingRights['K'] == true && board[7][5] == null && board[7][6] == null && !_isSquareAttacked(7, 4, false) && !_isSquareAttacked(7, 5, false) && !_isSquareAttacked(7, 6, false)) {
        moves.add([7, 6]);
      }
      if (castlingRights['Q'] == true && board[7][3] == null && board[7][2] == null && board[7][1] == null && !_isSquareAttacked(7, 4, false) && !_isSquareAttacked(7, 3, false) && !_isSquareAttacked(7, 2, false)) {
        moves.add([7, 2]);
      }
    } else {
      if (castlingRights['k'] == true && board[0][5] == null && board[0][6] == null && !_isSquareAttacked(0, 4, true) && !_isSquareAttacked(0, 5, true) && !_isSquareAttacked(0, 6, true)) {
        moves.add([0, 6]);
      }
      if (castlingRights['q'] == true && board[0][3] == null && board[0][2] == null && board[0][1] == null && !_isSquareAttacked(0, 4, true) && !_isSquareAttacked(0, 3, true) && !_isSquareAttacked(0, 2, true)) {
        moves.add([0, 2]);
      }
    }
    return moves;
  }

  bool _isSquareAttacked(int row, int col, bool byWhite) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece != null && isWhitePiece(piece) == byWhite) {
          List<List<int>> attacks;
          String pieceType = piece.toUpperCase();
          if (pieceType == 'P') {
            int pawnDir = byWhite ? -1 : 1;
            attacks = [[r + pawnDir, c - 1], [r + pawnDir, c + 1]];
            for (var attack in attacks) {
              if (attack[0] == row && attack[1] == col) return true;
            }
          } else if (pieceType == 'K') {
            attacks = [[r - 1, c - 1], [r - 1, c], [r - 1, c + 1], [r, c - 1], [r, c + 1], [r + 1, c - 1], [r + 1, c], [r + 1, c + 1]];
            for (var attack in attacks) {
              if (attack[0] == row && attack[1] == col) return true;
            }
          } else {
            List<List<int>> pieceMoves = [];
            switch (pieceType) {
              case 'N': pieceMoves = _getKnightMoves(r, c, byWhite); break;
              case 'B': pieceMoves = _getBishopMoves(r, c, byWhite); break;
              case 'R': pieceMoves = _getRookMoves(r, c, byWhite); break;
              case 'Q': pieceMoves = [..._getBishopMoves(r, c, byWhite), ..._getRookMoves(r, c, byWhite)]; break;
            }
            for (var move in pieceMoves) {
              if (move[0] == row && move[1] == col) return true;
            }
          }
        }
      }
    }
    return false;
  }

  bool _wouldBeInCheck(int fromRow, int fromCol, int toRow, int toCol, bool isWhite) {
    String? captured = board[toRow][toCol];
    board[toRow][toCol] = board[fromRow][fromCol];
    board[fromRow][fromCol] = null;
    int kingRow = -1, kingCol = -1;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] == (isWhite ? 'K' : 'k')) {
          kingRow = r;
          kingCol = c;
        }
      }
    }
    bool inCheck = _isSquareAttacked(kingRow, kingCol, !isWhite);
    board[fromRow][fromCol] = board[toRow][toCol];
    board[toRow][toCol] = captured;
    return inCheck;
  }

  bool isInCheck(bool isWhite) {
    int kingRow = -1, kingCol = -1;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] == (isWhite ? 'K' : 'k')) {
          kingRow = r;
          kingCol = c;
        }
      }
    }
    return _isSquareAttacked(kingRow, kingCol, !isWhite);
  }

  bool isCheckmate(bool isWhite) {
    if (!isInCheck(isWhite)) return false;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece != null && isWhitePiece(piece) == isWhite) {
          if (getLegalMoves(r, c).isNotEmpty) return false;
        }
      }
    }
    return true;
  }

  bool isStalemate(bool isWhite) {
    if (isInCheck(isWhite)) return false;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece != null && isWhitePiece(piece) == isWhite) {
          if (getLegalMoves(r, c).isNotEmpty) return false;
        }
      }
    }
    return true;
  }

  bool makeMove(int fromRow, int fromCol, int toRow, int toCol) {
    List<List<int>> legalMoves = getLegalMoves(fromRow, fromCol);
    bool isLegal = legalMoves.any((move) => move[0] == toRow && move[1] == toCol);
    if (!isLegal) return false;
    String? piece = board[fromRow][fromCol];
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = null;
    if (piece!.toUpperCase() == 'P' && toCol != fromCol && board[toRow][toCol] == null) {
      board[fromRow][toCol] = null;
    }
    if (piece == 'K' && fromCol == 4 && toCol == 6) { board[7][5] = board[7][7]; board[7][7] = null; }
    if (piece == 'K' && fromCol == 4 && toCol == 2) { board[7][3] = board[7][0]; board[7][0] = null; }
    if (piece == 'k' && fromCol == 4 && toCol == 6) { board[0][5] = board[0][7]; board[0][7] = null; }
    if (piece == 'k' && fromCol == 4 && toCol == 2) { board[0][3] = board[0][0]; board[0][0] = null; }
    if (piece == 'P' && toRow == 0) board[toRow][toCol] = 'Q';
    if (piece == 'p' && toRow == 7) board[toRow][toCol] = 'q';
    enPassantTarget = null;
    if (piece.toUpperCase() == 'P' && (toRow - fromRow).abs() == 2) {
      enPassantTarget = [(fromRow + toRow) ~/ 2, fromCol];
    }
    if (piece == 'K') { castlingRights['K'] = false; castlingRights['Q'] = false; }
    if (piece == 'k') { castlingRights['k'] = false; castlingRights['q'] = false; }
    if (piece == 'R' && fromRow == 7 && fromCol == 0) castlingRights['Q'] = false;
    if (piece == 'R' && fromRow == 7 && fromCol == 7) castlingRights['K'] = false;
    if (piece == 'r' && fromRow == 0 && fromCol == 0) castlingRights['q'] = false;
    if (piece == 'r' && fromRow == 0 && fromCol == 7) castlingRights['k'] = false;
    moveHistory.add('${String.fromCharCode(97 + fromCol)}${8 - fromRow}-${String.fromCharCode(97 + toCol)}${8 - toRow}');
    isWhiteTurn = !isWhiteTurn;
    bool currentPlayer = isWhiteTurn;
    if (isCheckmate(currentPlayer)) {
      gameOver = true;
      winner = currentPlayer ? 'Negras' : 'Blancas';
      gameStatus = 'Jaque mate - Ganaron las $winner';
    } else if (isStalemate(currentPlayer)) {
      gameOver = true;
      gameStatus = 'Tablas por ahogado';
    }
    return true;
  }

  int evaluatePosition() {
    int score = 0;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = board[r][c];
        if (piece != null) {
          int value = ChessConstants.pieceValues[piece] ?? 0;
          score += isWhitePiece(piece) ? value : -value;
        }
      }
    }
    return score;
  }
}
