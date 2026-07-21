import 'package:flutter/material.dart';
import 'engine/chess_engine.dart';
import 'engine/chess_ai.dart';
import 'engine/chess_coach.dart';
import 'widgets/chess_board.dart';
import 'widgets/chess_controls.dart';
import 'widgets/difficulty_selector.dart';
import 'chess_lobby_screen.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key});
  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> with TickerProviderStateMixin {
  final ChessEngine _engine = ChessEngine();
  late ChessAI _ai;
  int? _selectedRow, _selectedCol;
  List<List<int>> _legalMoves = [];
  bool _gameStarted = false;
  int _difficulty = 1;
  bool _isPlayerTurn = true;
  String _coachComment = '';
  List<String> _insights = [];
  bool _aiThinking = false;

  void _startGame(int difficulty) {
    final elos = [400, 800, 1200, 1800, 2400];
    setState(() {
      _difficulty = difficulty;
      _ai = ChessAI(elo: elos[difficulty]);
      _gameStarted = true;
      _engine.reset();
      _isPlayerTurn = true;
      _coachComment = '♟ ¡Comienza la partida! Juegas con blancas';
      _insights = [];
      _aiThinking = false;
    });
  }

  void _onSquareTap(int row, int col) {
    if (_engine.gameOver || !_isPlayerTurn || _aiThinking) return;
    
    if (_selectedRow != null && _selectedCol != null) {
      if (_legalMoves.any((m) => m[0] == row && m[1] == col)) {
        int fromRow = _selectedRow!, fromCol = _selectedCol!;
        
        if (_difficulty == 0) {
          String analysis = ChessCoach.analyzeMove(fromRow, fromCol, row, col, _engine.board, _engine.moveHistory);
          setState(() {
            _coachComment = analysis;
            _insights = analysis.split('\n');
          });
        }

        setState(() {
          _engine.makeMove(fromRow, fromCol, row, col);
          _selectedRow = null;
          _selectedCol = null;
          _legalMoves = [];
          _isPlayerTurn = false;
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
    if (_engine.gameOver) return;
    setState(() => _aiThinking = true);
    Future.delayed(_ai.thinkingTime, () {
      if (!mounted || _engine.gameOver) return;
      setState(() {
        List<List<int>> allMoves = [];
        for (int r = 0; r < 8; r++) {
          for (int c = 0; c < 8; c++) {
            String? piece = _engine.board[r][c];
            if (piece != null && !_engine.isWhitePiece(piece)) {
              List<List<int>> moves = _engine.getLegalMoves(r, c);
              for (var m in moves) {
                allMoves.add([r, c, m[0], m[1]]);
              }
            }
          }
        }
        if (allMoves.isNotEmpty) {
          List<int>? chosen = _ai.selectMove(allMoves, _engine.board);
          if (chosen != null) _engine.makeMove(chosen[0], chosen[1], chosen[2], chosen[3]);
        }
        _isPlayerTurn = true;
        _aiThinking = false;
        _coachComment = 'Tu turno';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              // Selector de dificultad
              DifficultySelector(onSelect: _startGame),
              const SizedBox(height: 8),
              // Botón multijugador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChessLobbyScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1A2A3A), Color(0xFF2A1A3A)]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF3A5A7A), width: 0.5),
                    ),
                    child: Row(children: [
                      Container(width: 56, height: 56, decoration: BoxDecoration(color: const Color(0xFF4CAF50).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.people, color: Color(0xFF4CAF50), size: 30)),
                      const SizedBox(width: 16),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Multijugador Online', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Juega contra amigos o rivales del mundo', style: TextStyle(color: Colors.grey, fontSize: 13))])),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A2A5E), width: 0.5)),
            child: Row(children: [
              const Text('♟', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(_isPlayerTurn ? 'Tu turno' : _aiThinking ? 'IA pensando...' : 'IA movio', style: TextStyle(color: _isPlayerTurn ? const Color(0xFF4CAF50) : const Color(0xFFD7A15D), fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF2A2A4E), borderRadius: BorderRadius.circular(8)), child: Text('Nivel ${_difficulty + 1}', style: const TextStyle(color: Colors.grey, fontSize: 12))),
            ]),
          ),
          const SizedBox(height: 8),
          ChessBoard(engine: _engine, selectedRow: _selectedRow, selectedCol: _selectedCol, legalMoves: _legalMoves, isPlayerTurn: _isPlayerTurn, onSquareTap: _onSquareTap),
          const SizedBox(height: 8),
          if (_difficulty == 0 && _coachComment.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF1A2A3E)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFD7A15D).withValues(alpha: 0.2), width: 0.5)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.lightbulb_outline, color: Color(0xFFD7A15D), size: 16), SizedBox(width: 6), Text('Entrenador', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 13, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 8),
                ..._insights.map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(insight, style: TextStyle(color: insight.startsWith('✅') ? const Color(0xFF4CAF50) : insight.startsWith('⚠️') ? const Color(0xFFFFA726) : insight.startsWith('💡') ? const Color(0xFF64B5F6) : Colors.white70, fontSize: 12, height: 1.3)),
                )),
              ]),
            ),
          const SizedBox(height: 4),
          ChessControls(isPlayerTurn: _isPlayerTurn, gameStatus: _engine.gameStatus, evaluation: _ai.evaluatePosition(_engine.board), onResign: () => setState(() { _engine.gameOver = true; _engine.gameStatus = 'Te has rendido'; }), onNewGame: () => _startGame(_difficulty)),
        ]),
      ),
    );
  }
}
