import 'package:flutter/material.dart';

class QuickAccess extends StatelessWidget {
  const QuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(icon: '📚', label: 'Biblioteca'),
      _QuickItem(icon: '✍️', label: 'Escritor'),
      _QuickItem(icon: '♟️', label: 'Ajedrez'),
      _QuickItem(icon: '🛍️', label: 'Ventas'),
      _QuickItem(icon: '❤️', label: 'Favoritos'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Accesos Rapidos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: items[index].onTap,
                child: Container(
                  width: 95,
                  decoration: BoxDecoration(
                    color: const Color(0xFF181818),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(items[index].icon, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(items[index].label, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickItem {
  final String icon;
  final String label;
  final VoidCallback? onTap;
  const _QuickItem({required this.icon, required this.label, this.onTap});
}
