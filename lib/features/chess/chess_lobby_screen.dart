import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/multiplayer_service.dart';
import 'multiplayer_game_screen.dart';

class ChessLobbyScreen extends StatefulWidget {
  const ChessLobbyScreen({super.key});
  @override
  State<ChessLobbyScreen> createState() => _ChessLobbyScreenState();
}

class _ChessLobbyScreenState extends State<ChessLobbyScreen> {
  final MultiplayerChessService _service = MultiplayerChessService();
  final TextEditingController _searchCtrl = TextEditingController();
  bool _searching = false;
  String _status = '';

  Future<void> _createGame() async {
    setState(() { _searching = true; _status = 'Creando partida...'; });
    final gameId = await _service.createGame();
    setState(() { _searching = false; _status = 'Esperando oponente...'; });
    _waitForOpponent(gameId);
  }

  Future<void> _joinRandomGame() async {
    setState(() { _searching = true; _status = 'Buscando partida...'; });
    final gameId = await _service.joinRandomGame();
    if (gameId != null) {
      _startGame(gameId, isWhite: false);
    } else {
      setState(() { _searching = false; _status = 'No hay partidas. Crea una!'; });
    }
  }

  Future<void> _challengeUser(String username) async {
    setState(() { _searching = true; _status = 'Retando a $username...'; });
    final gameId = await _service.challengeUser(username);
    if (gameId != null) {
      setState(() { _searching = false; _status = 'Reto enviado! Esperando...'; });
      _waitForOpponent(gameId);
    } else {
      setState(() { _searching = false; _status = 'Usuario no encontrado'; });
    }
  }

  void _waitForOpponent(String gameId) {
    _service.listenToGame(gameId).listen((snap) {
      final data = snap.data() as Map<String, dynamic>;
      if (data['status'] == 'playing') {
        _startGame(gameId, isWhite: true);
      }
    });
  }

  void _startGame(String gameId, {required bool isWhite}) {
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MultiplayerGameScreen(gameId: gameId, isWhite: isWhite)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Multijugador Online', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: _searching
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const CircularProgressIndicator(color: Color(0xFFD7A15D)), const SizedBox(height: 20), Text(_status, style: const TextStyle(color: Colors.white, fontSize: 18))]))
          : Column(children: [
              // Botones principales
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(
                    onPressed: _createGame, icon: const Icon(Icons.add, color: Colors.black), label: const Text('Crear Partida', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD7A15D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  )),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(
                    onPressed: _joinRandomGame, icon: const Icon(Icons.search, color: Colors.white), label: const Text('Unirse a Partida Aleatoria', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A2E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: const BorderSide(color: Color(0xFFD7A15D))),
                  )),
                ]),
              ),
              const Padding(padding: EdgeInsets.all(16), child: Text('— o reta a alguien —', style: TextStyle(color: Colors.grey))),
              // Buscar usuario para retar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Escribe @usuario para retar...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.person_search, color: Color(0xFFD7A15D)),
                    suffixIcon: IconButton(icon: const Icon(Icons.send, color: Color(0xFFD7A15D)), onPressed: () => _challengeUser(_searchCtrl.text.trim())),
                    filled: true, fillColor: const Color(0xFF1B1B1B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Partidas disponibles
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _service.getAvailableGames(),
                  builder: (context, snap) {
                    if (!snap.hasData || snap.data!.docs.isEmpty) return const Center(child: Text('No hay partidas disponibles', style: TextStyle(color: Colors.grey)));
                    return ListView.builder(
                      itemCount: snap.data!.docs.length,
                      itemBuilder: (context, i) {
                        final g = snap.data!.docs[i].data() as Map<String, dynamic>;
                        return ListTile(
                          leading: const Icon(Icons.sports_esports, color: Color(0xFFD7A15D)),
                          title: Text('${g['whiteName'] ?? 'Jugador'} te reta', style: const TextStyle(color: Colors.white)),
                          subtitle: Text(g['whiteUsername'] ?? '', style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 12)),
                          trailing: ElevatedButton(onPressed: () => _challengeUser(g['whiteUsername'] ?? ''), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)), child: const Text('Aceptar')),
                        );
                      },
                    );
                  },
                ),
              ),
            ]),
    );
  }
}
