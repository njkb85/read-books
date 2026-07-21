import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'services/multiplayer_service.dart';

class MultiplayerGameScreen extends StatefulWidget {
  final String gameId;
  final bool isWhite;
  const MultiplayerGameScreen({super.key, required this.gameId, required this.isWhite});
  @override
  State<MultiplayerGameScreen> createState() => _MultiplayerGameScreenState();
}

class _MultiplayerGameScreenState extends State<MultiplayerGameScreen> {
  final MultiplayerChessService _service = MultiplayerChessService();
  List<List<String?>> _board = [];
  String _turn = 'white';
  String _status = 'Cargando...';
  int? _selectedRow, _selectedCol;
  StreamSubscription? _gameSubscription;

  @override
  void initState() {
    super.initState();
    _gameSubscription = _service.listenToGame(widget.gameId).listen((snap) {
      final data = snap.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _board = (data['board'] as List).map((r) => (r as List).map((e) => e as String?).toList()).toList();
          _turn = data['turn'] ?? 'white';
          _status = data['status'] ?? 'playing';
          
          if (data['status'] == 'finished') {
            _status = data['winner'] == (widget.isWhite ? 'white' : 'black') ? '¡Ganaste!' : 'Perdiste';
          } else {
            bool myTurn = (widget.isWhite && _turn == 'white') || (!widget.isWhite && _turn == 'black');
            _status = myTurn ? 'Tu turno' : 'Turno del oponente';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _gameSubscription?.cancel();
    super.dispose();
  }

  void _onTap(int row, int col) {
    if (_status == 'Turno del oponente' || _status.contains('Ganaste') || _status.contains('Perdiste')) return;
    
    if (_selectedRow != null && _selectedCol != null) {
      _service.makeMove(widget.gameId, _selectedRow!, _selectedCol!, row, col);
      setState(() { _selectedRow = null; _selectedCol = null; });
    } else if (_board[row][col] != null) {
      bool isMyPiece = widget.isWhite 
          ? _board[row][col] == _board[row][col]?.toUpperCase()
          : _board[row][col] == _board[row][col]?.toLowerCase();
      if (isMyPiece) {
        setState(() { _selectedRow = row; _selectedCol = col; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_board.isEmpty) return const Scaffold(backgroundColor: Color(0xFF0D0D0D), body: Center(child: CircularProgressIndicator()));
    
    double boardSize = MediaQuery.of(context).size.width - 32;
    double square = boardSize / 8;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(_status, style: const TextStyle(color: Colors.white))),
      body: Column(children: [
        Text('Juegas con ', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          width: boardSize, height: boardSize,
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF3A3A3A), width: 2)),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemCount: 64,
            itemBuilder: (context, i) {
              int r = i ~/ 8, c = i % 8;
              bool light = (r + c) % 2 == 0;
              bool sel = _selectedRow == r && _selectedCol == c;
              String? p = _board[r][c];
              return GestureDetector(
                onTap: () => _onTap(r, c),
                child: Container(
                  color: sel ? const Color(0xFF829769) : (light ? const Color(0xFFF0D9B5) : const Color(0xFFB58863)),
                  child: Center(child: Text(_unicode(p), style: TextStyle(fontSize: square * 0.7, color: p != null && p == p.toUpperCase() ? Colors.white : Colors.black))),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  String _unicode(String? p) => {'K':'?','Q':'?','R':'?','B':'?','N':'?','P':'?','k':'?','q':'?','r':'?','b':'?','n':'?','p':'?'}[p] ?? '';
}
