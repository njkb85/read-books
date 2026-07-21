import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MultiplayerChessService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Crear partida y esperar oponente
  Future<String> createGame() async {
    final user = _auth.currentUser!;
    final gameRef = await _db.collection('chess_games').add({
      'white': user.uid,
      'whiteName': '',
      'whiteUsername': '',
      'black': '',
      'blackName': '',
      'blackUsername': '',
      'board': _initialBoard(),
      'turn': 'white',
      'status': 'waiting', // waiting, playing, finished
      'createdAt': FieldValue.serverTimestamp(),
      'lastMove': null,
      'winner': null,
      'moves': [],
    });

    // Obtener nombre del creador
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};
    await gameRef.update({
      'whiteName': userData['name'] ?? 'Jugador 1',
      'whiteUsername': userData['username'] ?? '@jugador1',
    });

    return gameRef.id;
  }

  // Buscar partida disponible y unirse
  Future<String?> joinRandomGame() async {
    final user = _auth.currentUser!;
    
    // Buscar partidas en espera
    final query = await _db.collection('chess_games')
        .where('status', isEqualTo: 'waiting')
        .where('black', isEqualTo: '')
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final gameRef = query.docs.first;
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    await gameRef.reference.update({
      'black': user.uid,
      'blackName': userData['name'] ?? 'Jugador 2',
      'blackUsername': userData['username'] ?? '@jugador2',
      'status': 'playing',
    });

    return gameRef.id;
  }

  // Retar a un usuario específico por username
  Future<String?> challengeUser(String targetUsername) async {
    final user = _auth.currentUser!;
    
    // Buscar al usuario por username
    final userQuery = await _db.collection('users')
        .where('username', isEqualTo: targetUsername)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) return null;

    final targetUser = userQuery.docs.first;
    final targetData = targetUser.data();
    final targetId = targetUser.id;

    // Verificar que no se rete a sí mismo
    if (targetId == user.uid) return null;

    final userDoc = await _db.collection('users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    // Crear partida directa
    final gameRef = await _db.collection('chess_games').add({
      'white': user.uid,
      'whiteName': userData['name'] ?? 'Jugador 1',
      'whiteUsername': userData['username'] ?? '@jugador1',
      'black': targetId,
      'blackName': targetData['name'] ?? 'Jugador 2',
      'blackUsername': targetData['username'] ?? '@jugador2',
      'board': _initialBoard(),
      'turn': 'white',
      'status': 'waiting', // Esperando que el retado acepte
      'createdAt': FieldValue.serverTimestamp(),
      'lastMove': null,
      'winner': null,
      'moves': [],
    });

    return gameRef.id;
  }

  // Aceptar reto
  Future<void> acceptChallenge(String gameId) async {
    await _db.collection('chess_games').doc(gameId).update({'status': 'playing'});
  }

  // Hacer un movimiento
  Future<void> makeMove(String gameId, int fromRow, int fromCol, int toRow, int toCol) async {
    final gameDoc = await _db.collection('chess_games').doc(gameId).get();
    final data = gameDoc.data()!;
    
    List<dynamic> board = List.from(data['board']);
    String? piece = board[fromRow][fromCol] as String?;
    
    // Actualizar tablero
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = null;
    
    // Cambiar turno
    String nextTurn = data['turn'] == 'white' ? 'black' : 'white';
    
    // Registrar movimiento
    List<dynamic> moves = List.from(data['moves'] ?? []);
    moves.add({
      'from': '${String.fromCharCode(97 + fromCol)}${8 - fromRow}',
      'to': '${String.fromCharCode(97 + toCol)}${8 - toRow}',
      'piece': piece,
      'by': data['turn'] == 'white' ? 'white' : 'black',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _db.collection('chess_games').doc(gameId).update({
      'board': board,
      'turn': nextTurn,
      'lastMove': {'fromRow': fromRow, 'fromCol': fromCol, 'toRow': toRow, 'toCol': toCol, 'piece': piece},
      'moves': moves,
    });
  }

  // Escuchar partida en tiempo real
  Stream<DocumentSnapshot> listenToGame(String gameId) {
    return _db.collection('chess_games').doc(gameId).snapshots();
  }

  // Buscar partidas disponibles (para unirse)
  Stream<QuerySnapshot> getAvailableGames() {
    return _db.collection('chess_games')
        .where('status', isEqualTo: 'waiting')
        .where('black', isEqualTo: '')
        .snapshots();
  }

  // Mis partidas activas
  Stream<QuerySnapshot> getMyGames() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    
    return _db.collection('chess_games')
        .where('status', whereIn: ['waiting', 'playing'])
        .snapshots();
  }

  // Rendirse
  Future<void> resign(String gameId) async {
    final user = _auth.currentUser!;
    final gameDoc = await _db.collection('chess_games').doc(gameId).get();
    final data = gameDoc.data()!;
    
    String winner = data['white'] == user.uid ? 'black' : 'white';
    
    await _db.collection('chess_games').doc(gameId).update({
      'status': 'finished',
      'winner': winner,
    });
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
}
