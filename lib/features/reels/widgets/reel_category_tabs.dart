import 'package:flutter/material.dart';

class ReelCategoryTabs extends StatefulWidget {
  final Function(String)? onCategoryChanged;
  const ReelCategoryTabs({super.key, this.onCategoryChanged});
  @override
  State<ReelCategoryTabs> createState() => _ReelCategoryTabsState();
}

class _ReelCategoryTabsState extends State<ReelCategoryTabs> {
  int _selectedIndex = 0;
  final List<String> _categories = [
    'Vistos',
    'Sugeridos',
    'Seguidos',
    'Mios',
    'IA',
    'Historial',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onCategoryChanged?.call(_categories[index]);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC96A2B) : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFB0B0B0),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
