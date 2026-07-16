import 'package:flutter/material.dart';

class SalesSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const SalesSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1B),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.search, color: Colors.grey, size: 22),
              SizedBox(width: 12),
              Text('Buscar articulos, libros, categorias...', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
