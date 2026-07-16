import 'package:flutter/material.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF7B61FF),
      const Color(0xFFC96A2B),
      const Color(0xFF00BCD4),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF795548),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mi estanteria', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {},
                child: const Text('Ver toda >', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 14)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: colors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return Container(
                width: 110,
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Icon(Icons.book, color: Colors.white24, size: 40),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
