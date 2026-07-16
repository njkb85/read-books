import 'package:flutter/material.dart';
import 'engine/chess_engine.dart';
import 'engine/move_analyzer.dart';
import 'widgets/chess_board.dart';
import 'widgets/chess_controls.dart';
import 'widgets/difficulty_selector.dart';
import 'chess_opponent_screen.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key});
  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  final ChessEngine _engine = ChessEngine();
  int? _selectedRow;
  int? _selectedCol;
  List<List<int>> _legalMoves = [];
  bool _gameStarted = false;
  bool _isPlayerTurn = true;
  int _evaluation = 0;
  String _moveComment = '';

  void _onSquareTap(int row, int col) {
    if (_engine.gameOver || !_isPlayerTurn) return;
    if (_selectedRow != null && _selectedCol != null) {
      if (_legalMoves.any((m) => m[0] == row && m[1] == col)) {
        int fromRow = _selectedRow!;
        int fromCol = _selectedCol!;
        String analysis = MoveAnalyzer.analyzeMove(_engine, fromRow, fromCol, row, col);
        setState(() {
          _engine.makeMove(fromRow, fromCol, row, col);
          _moveComment = analysis;
          _selectedRow = null;
          _selectedCol = null;
          _legalMoves = [];
          _isPlayerTurn = false;
          _evaluation = _engine.evaluatePosition();
        });
        _makeAIMove();
        return;
      }
    }
    setState(() {
      String? piece = _engine.board[row][col];
      if (piece != null && _engine.isWhitePiece(piece) == _engine.isWhiteTurn) {
        _selectedRow = row;
        _selectedCol = col;
        _legalMoves = _engine.getLegalMoves(row, col);
      } else {
        _selectedRow = null;
        _selectedCol = null;
        _legalMoves = [];
      }
    });
  }

  void _makeAIMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_engine.gameOver) return;
      setState(() {
        List<List<int>> allMoves = [];
        for (int r = 0; r < 8; r++) {
          for (int c = 0; c < 8; c++) {
            String? piece = _engine.board[r][c];
            if (piece != null && !_engine.isWhitePiece(piece)) {
              List<List<int>> moves = _engine.getLegalMoves(r, c);
              for (var move in moves) allMoves.add([r, c, move[0], move[1]]);
            }
          }
        }
        if (allMoves.isNotEmpty) {
          allMoves.shuffle();
          var move = allMoves.first;
          _engine.makeMove(move[0], move[1], move[2], move[3]);
          _moveComment = 'IA movio';
        }
        _isPlayerTurn = true;
        _evaluation = _engine.evaluatePosition();
      });
    });
  }

  void _startGame(int difficulty) {
    setState(() {
      _gameStarted = true;
      _engine.reset();
      _isPlayerTurn = true;
      _selectedRow = null;
      _selectedCol = null;
      _legalMoves = [];
      _evaluation = 0;
      _moveComment = 'Juegas con blancas';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DifficultySelector(onSelect: _startGame),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChessOpponentScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: const Color(0xFFD7A15D), borderRadius: BorderRadius.circular(16)),
                      child: const Center(child: Text('Jugar contra un amigo', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text('AJEDREZ - MODO ENTRENADOR', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ChessBoard(engine: _engine, selectedRow: _selectedRow, selectedCol: _selectedCol, legalMoves: _legalMoves, isPlayerTurn: _isPlayerTurn, onSquareTap: _onSquareTap),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)),
              child: Text(_moveComment, style: TextStyle(color: _moveComment.contains('✅') ? const Color(0xFF4CAF50) : Colors.white, fontSize: 13)),
            ),
            ChessControls(isPlayerTurn: _isPlayerTurn, gameStatus: _engine.gameStatus, evaluation: _evaluation, onResign: () => setState(() { _engine.gameOver = true; _engine.gameStatus = 'Te has rendido'; }), onNewGame: () => _startGame(1)),
          ],
        ),
      ),
    );
  }
}
