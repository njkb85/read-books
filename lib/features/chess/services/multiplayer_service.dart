import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MultiplayerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? currentGameId;
  String? playerColor; // 'white' o 'black'

  // Crear partida y esperar oponente
  Future<String> createGame() async {
    final user = _auth.currentUser!;
    final gameRef = await _db.collection('chess_games').add({
      'white': user.uid,
      'black': '',
      'board': _initialBoard(),
      'turn': 'white',
      'status': 'waiting',
      'createdAt': FieldValue.serverTimestamp(),
    });
    currentGameId = gameRef.id;
    playerColor = 'white';
    return gameRef.id;
  }

  // Buscar partida disponible y unirse
  Future<String?> joinRandomGame() async {
    final user = _auth.currentUser!;
    final query = await _db.collection('chess_games')
        .where('status', isEqualTo: 'waiting')
        .where('black', isEqualTo: '')
        .limit(1)
        .get();
    
    if (query.docs.isEmpty) return null;
    
    final gameRef = query.docs.first;
    await gameRef.reference.update({
      'black': user.uid,
      'status': 'playing',
    });
    currentGameId = gameRef.id;
    playerColor = 'black';
    return gameRef.id;
  }

  // Escuchar la partida
  Stream<DocumentSnapshot> listenGame() {
    if (currentGameId == null) return const Stream.empty();
    return _db.collection('chess_games').doc(currentGameId!).snapshots();
  }

  // Hacer movimiento
  Future<void> makeMove(int fromRow, int fromCol, int toRow, int toCol, String piece) async {
    if (currentGameId == null) return;
    
    final gameDoc = await _db.collection('chess_games').doc(currentGameId!).get();
    final data = gameDoc.data()!;
    List<dynamic> board = data['board'];
    
    // Actualizar tablero
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = null;
    
    // Cambiar turno
    String nextTurn = data['turn'] == 'white' ? 'black' : 'white';
    
    await _db.collection('chess_games').doc(currentGameId!).update({
      'board': board,
      'turn': nextTurn,
      'lastMove': {'fromRow': fromRow, 'fromCol': fromCol, 'toRow': toRow, 'toCol': toCol, 'piece': piece},
    });
  }

  bool isMyTurn(String turn) {
    return playerColor == turn;
  }

  List<List<String?>> _initialBoard() {
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

  void leaveGame() {
    if (currentGameId != null) {
      _db.collection('chess_games').doc(currentGameId!).update({'status': 'finished'});
      currentGameId = null;
      playerColor = null;
    }
  }
}
