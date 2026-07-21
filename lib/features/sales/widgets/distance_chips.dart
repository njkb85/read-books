import 'package:flutter/material.dart';

class DistanceChips extends StatefulWidget {
  const DistanceChips({super.key});
  @override
  State<DistanceChips> createState() => _DistanceChipsState();
}

class _DistanceChipsState extends State<DistanceChips> {
  int _selected = 1;
  static const _chips = ['5 km', '2 km', '3 km', 'Filtros'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isActive = _selected == i;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFD7A15D) : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(_chips[i], style: TextStyle(color: isActive ? Colors.black : Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }
}
