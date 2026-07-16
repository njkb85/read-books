import 'package:flutter/material.dart';
import '../data/chess_constants.dart';
import '../engine/chess_engine.dart';
import 'chess_piece.dart';

class ChessBoard extends StatelessWidget {
  final ChessEngine engine;
  final int? selectedRow;
  final int? selectedCol;
  final List<List<int>>? legalMoves;
  final bool isPlayerTurn;
  final Function(int row, int col)? onSquareTap;

  const ChessBoard({
    super.key,
    required this.engine,
    this.selectedRow,
    this.selectedCol,
    this.legalMoves,
    this.isPlayerTurn = true,
    this.onSquareTap,
  });

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width - 32;
    double squareSize = boardSize / 8;
    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF3A3A3A), width: 2)),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemCount: 64,
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;
          bool isLight = (row + col) % 2 == 0;
          bool isSelected = selectedRow == row && selectedCol == col;
          bool isLegal = legalMoves?.any((m) => m[0] == row && m[1] == col) ?? false;
          Color squareColor;
          if (isSelected) {
            squareColor = ChessConstants.selectedSquareColor;
          } else {
            squareColor = isLight ? ChessConstants.lightSquareColor : ChessConstants.darkSquareColor;
          }
          return GestureDetector(
            onTap: isPlayerTurn ? () => onSquareTap?.call(row, col) : null,
            child: Container(
              color: squareColor,
              child: Stack(
                children: [
                  if (isLegal) Center(
                    child: Container(
                      width: squareSize * 0.3,
                      height: squareSize * 0.3,
                      decoration: BoxDecoration(color: ChessConstants.legalMoveColor.withValues(alpha: 0.7), shape: BoxShape.circle),
                    ),
                  ),
                  if (engine.board[row][col] != null) Center(child: ChessPiece(piece: engine.board[row][col]!, size: squareSize * 0.8)),
                  if (col == 0) Positioned(left: 2, bottom: 1, child: Text('${8 - row}', style: TextStyle(color: isLight ? ChessConstants.darkSquareColor : ChessConstants.lightSquareColor, fontSize: 10, fontWeight: FontWeight.bold))),
                  if (row == 7) Positioned(right: 2, bottom: 1, child: Text(String.fromCharCode(97 + col), style: TextStyle(color: isLight ? ChessConstants.darkSquareColor : ChessConstants.lightSquareColor, fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
