import 'package:flutter/material.dart';
import 'services/multiplayer_service.dart';

class MultiplayerChessScreen extends StatefulWidget {
  final MultiplayerService service;
  const MultiplayerChessScreen({super.key, required this.service});
  @override
  State<MultiplayerChessScreen> createState() => _MultiplayerChessScreenState();
}

class _MultiplayerChessScreenState extends State<MultiplayerChessScreen> {
  List<List<String?>> _board = [];
  String _turn = 'white';
  int? _selectedRow, _selectedCol;
  String _status = 'Jugando...';

  @override
  void initState() {
    super.initState();
    widget.service.listenGame().listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _board = (data['board'] as List).map((row) => (row as List).map((e) => e as String?).toList()).toList();
        _turn = data['turn'] ?? 'white';
        if (!widget.service.isMyTurn(_turn)) {
          _status = 'Turno del oponente';
        } else {
          _status = 'Tu turno';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_board.isEmpty) return const Scaffold(backgroundColor: Color(0xFF0D0D0D), body: Center(child: CircularProgressIndicator()));
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.service.playerColor == 'white' ? 'Juegas con Blancas' : 'Juegas con Negras', style: const TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () { widget.service.leaveGame(); Navigator.pop(context); })),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text(_status, style: TextStyle(color: _status == 'Tu turno' ? const Color(0xFF4CAF50) : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildBoard(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    double size = MediaQuery.of(context).size.width - 32;
    double square = size / 8;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF3A3A3A), width: 2)),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemCount: 64,
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;
          bool isLight = (row + col) % 2 == 0;
          bool isSelected = _selectedRow == row && _selectedCol == col;
          String? piece = _board[row][col];
          
          return GestureDetector(
            onTap: () {
              if (!widget.service.isMyTurn(_turn)) return;
              setState(() {
                if (_selectedRow != null && _selectedCol != null) {
                  widget.service.makeMove(_selectedRow!, _selectedCol!, row, col, _board[_selectedRow!][_selectedCol!] ?? '');
                  _selectedRow = null;
                  _selectedCol = null;
                } else if (piece != null) {
                  _selectedRow = row;
                  _selectedCol = col;
                }
              });
            },
            child: Container(
              color: isSelected ? const Color(0xFF829769) : (isLight ? const Color(0xFFF0D9B5) : const Color(0xFFB58863)),
              child: Center(child: Text(_pieceUnicode(piece), style: TextStyle(fontSize: square * 0.7, color: piece != null && piece == piece.toUpperCase() ? Colors.white : Colors.black))),
            ),
          );
        },
      ),
    );
  }

  String _pieceUnicode(String? piece) {
    const Map<String, String> map = {'K': '♔', 'Q': '♕', 'R': '♖', 'B': '♗', 'N': '♘', 'P': '♙', 'k': '♚', 'q': '♛', 'r': '♜', 'b': '♝', 'n': '♞', 'p': '♟'};
    return map[piece] ?? '';
  }
}
