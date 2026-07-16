import 'package:flutter/material.dart';
import '../sales_screen.dart';

class SaleCard extends StatefulWidget {
  final SaleItemReal item;
  const SaleCard({super.key, required this.item});

  @override
  State<SaleCard> createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final colors = [const Color(0xFF2A2A4E), const Color(0xFF3A1A1A), const Color(0xFF1A3A2A), const Color(0xFF3A2A1A)];
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Container(height: 130, width: double.infinity, color: colors[widget.item.id.hashCode.abs() % colors.length], child: const Center(child: Icon(Icons.shopping_bag, color: Colors.white24, size: 40)))),
          Positioned(top: 8, right: 8, child: GestureDetector(onTap: () => setState(() => _isSaved = !_isSaved), child: Container(width: 30, height: 30, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54), child: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: _isSaved ? const Color(0xFFD7A15D) : Colors.white, size: 16)))),
          Positioned(bottom: 8, right: 8, child: Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: Center(child: Text(widget.item.sellerInitial, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))))),
        ]),
        Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.item.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Text(widget.item.formattedPrice, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 16, fontWeight: FontWeight.bold))])),
      ]),
    );
  }
}
