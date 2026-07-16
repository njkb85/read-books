import 'package:flutter/material.dart';

class SalesCategoryTabs extends StatefulWidget {
  final Function(int)? onTabChanged;
  const SalesCategoryTabs({super.key, this.onTabChanged});

  @override
  State<SalesCategoryTabs> createState() => _SalesCategoryTabsState();
}

class _SalesCategoryTabsState extends State<SalesCategoryTabs> {
  int _selected = 0;
  static const _tabs = ['Vender', 'Categorias'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ...List.generate(_tabs.length, (i) {
            final isActive = _selected == i;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isActive ? const Color(0xFFD7A15D) : Colors.transparent, width: 2)),
                ),
                child: Text(_tabs[i], style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            );
          }),
          const Spacer(),
          const Icon(Icons.location_on_outlined, color: Color(0xFFD7A15D), size: 22),
        ],
      ),
    );
  }
}
