import 'package:flutter/material.dart';
import '../data/sale_item.dart';

class SaleCard extends StatelessWidget {
  final SaleItem item;
  final VoidCallback? onTap;
  const SaleCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    color: _getColor(item.id),
                    child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 40)),
                  ),
                ),
                // Distancia
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                    child: Text(item.formattedDistance, style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
                // Guardar
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30, height: 30,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                      child: Icon(item.isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white, size: 16),
                    ),
                  ),
                ),
                // Avatar vendedor
                Positioned(
                  bottom: 8, right: 8,
                  child: Container(
                    width: 28, height: 28,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)),
                    child: Center(child: Text(item.sellerInitial, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(item.formattedPrice, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String id) {
    final colors = [const Color(0xFF2A2A4E), const Color(0xFF3A1A1A), const Color(0xFF1A3A2A), const Color(0xFF3A2A1A), const Color(0xFF1A2A3A), const Color(0xFF2A3A1A)];
    return colors[id.hashCode.abs() % colors.length];
  }
}
