class OpeningBook {
  // Las mejores aperturas documentadas (notación: [fila, col, fila, col] desde perspectiva negras)
  static final Map<String, List<int>> openings = {
    // Defensa Siciliana
    'e7-e5': [1, 4, 3, 4], // c5
    // Defensa Francesa
    'e7-e6': [1, 4, 3, 4], // e6 -> d5
    // Gambito de Dama
    'd7-d5': [0, 3, 1, 3], // d5
  };

  // Comprobar si una jugada sigue el libro de aperturas
  static bool isBookMove(int fromRow, int fromCol, int toRow, int toCol, List<List<String?>> board) {
    // Implementación simplificada: verificar patrones básicos
    String? piece = board[fromRow][fromCol];
    if (piece == null) return false;
    
    // Las negras deben controlar el centro
    if (piece == piece.toLowerCase() && piece.toUpperCase() == 'P') {
      // Peones negros: mover hacia e5 o d5 es bueno
      if (toRow == 4 && (toCol == 3 || toCol == 4)) return true;
    }
    
    // Desarrollo de caballos
    if (piece.toLowerCase() == 'n') {
      if (toCol >= 2 && toCol <= 5 && toRow >= 2 && toRow <= 5) return true;
    }
    
    return false;
  }

  // Obtener el nombre de la apertura
  static String? getOpeningName(List<String> moves) {
    if (moves.isEmpty) return null;
    
    String first = moves.first;
    if (first.contains('c5')) return 'Defensa Siciliana';
    if (first.contains('e6')) return 'Defensa Francesa';
    if (first.contains('d5')) return 'Gambito de Dama Rehusado';
    if (first.contains('c6')) return 'Defensa Caro-Kann';
    
    return null;
  }
}
