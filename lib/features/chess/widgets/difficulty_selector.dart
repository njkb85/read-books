import 'package:flutter/material.dart';
import '../data/chess_constants.dart';

class DifficultySelector extends StatefulWidget {
  final Function(int)? onSelect;
  const DifficultySelector({super.key, this.onSelect});
  @override
  State<DifficultySelector> createState() => _DifficultySelectorState();
}

class _DifficultySelectorState extends State<DifficultySelector> {
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF2A1A3E)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF3A3A5E), width: 0.5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('♟ AJEDREZ', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 8),
          const Text('Elige la dificultad', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 24),
          ...List.generate(ChessConstants.difficulties.length, (i) {
            final sel = _selected == i;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: sel ? const Color(0xFFD7A15D).withValues(alpha: 0.15) : const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: sel ? const Color(0xFFD7A15D) : const Color(0xFF3A3A5E), width: sel ? 2 : 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ChessConstants.difficulties[i], style: TextStyle(color: sel ? const Color(0xFFD7A15D) : Colors.white, fontSize: 16, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
                    Row(children: [Text('Elo ~${ChessConstants.eloLevels[i]}', style: const TextStyle(color: Colors.grey, fontSize: 13)), if (sel) const SizedBox(width: 8), if (sel) const Icon(Icons.check_circle, color: Color(0xFFD7A15D), size: 20)]),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => widget.onSelect?.call(_selected),
            child: Container(width: double.infinity, height: 52, decoration: BoxDecoration(color: const Color(0xFFD7A15D), borderRadius: BorderRadius.circular(16)), child: const Center(child: Text('Jugar', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)))),
          ),
        ],
      ),
    );
  }
}
