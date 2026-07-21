import 'package:flutter/material.dart';

class LibraryGrid extends StatelessWidget {
  final VoidCallback? onViewAll;

  const LibraryGrid({
    super.key,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mi biblioteca',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'Ver toda mi biblioteca',
                  style: TextStyle(
                    color: Color(0xFFD7A15D),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildBookCover(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover(int index) {
    final colors = [
      const Color(0xFF2A2A4E),
      const Color(0xFF4A2A2A),
      const Color(0xFF2A4A2A),
      const Color(0xFF4A4A2A),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[index],
            colors[index].withValues(alpha: 0.6),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.book,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
