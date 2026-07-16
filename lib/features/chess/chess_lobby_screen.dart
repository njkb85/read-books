import 'package:flutter/material.dart';
import 'services/multiplayer_service.dart';
import 'multiplayer_chess_screen.dart';

class ChessLobbyScreen extends StatefulWidget {
  const ChessLobbyScreen({super.key});
  @override
  State<ChessLobbyScreen> createState() => _ChessLobbyScreenState();
}

class _ChessLobbyScreenState extends State<ChessLobbyScreen> {
  final MultiplayerService _service = MultiplayerService();
  bool _searching = false;

  Future<void> _createGame() async {
    setState(() => _searching = true);
    String gameId = await _service.createGame();
    _waitForOpponent(gameId);
  }

  Future<void> _joinGame() async {
    setState(() => _searching = true);
    String? gameId = await _service.joinRandomGame();
    if (gameId != null) {
      _startGame();
    } else {
      setState(() => _searching = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay partidas disponibles. Crea una!')));
    }
  }

  void _waitForOpponent(String gameId) {
    _service.listenGame().listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      if (data['status'] == 'playing') {
        _startGame();
      }
    });
  }

  void _startGame() {
    setState(() => _searching = false);
    Navigator.push(context, MaterialPageRoute(builder: (_) => MultiplayerChessScreen(service: _service)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Multijugador', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: Center(
        child: _searching
            ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: Color(0xFFD7A15D)), SizedBox(height: 20), Text('Buscando oponente...', style: TextStyle(color: Colors.white, fontSize: 18))])
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('♟', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 20),
                  const Text('Ajedrez Multijugador', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  SizedBox(width: 250, height: 52, child: ElevatedButton(onPressed: _createGame, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD7A15D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Crear Partida', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)))),
                  const SizedBox(height: 16),
                  SizedBox(width: 250, height: 52, child: ElevatedButton(onPressed: _joinGame, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Unirse a Partida', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))),
                ],
              ),
      ),
    );
  }
}
