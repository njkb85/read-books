import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  final Function(String)? onCategoryChanged;
  const CategoryChips({super.key, this.onCategoryChanged});
  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selected = 1;
  static const _categories = [
    'Siguiendo',
    'Sugeridos',
    'Mas leidos',
    'Leidos recientemente',
    'Autores',
    'Editoriales',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isActive = _selected == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onCategoryChanged?.call(_categories[i]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1B4D4D) : const Color(0xFF181818),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isActive ? const Color(0xFF1B4D4D) : const Color(0xFF2A2A2A), width: 1),
              ),
              child: Text(_categories[i], style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }
}
