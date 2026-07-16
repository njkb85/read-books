import 'package:flutter/material.dart';

class SearchBarWithAI extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onAITap;

  const SearchBarWithAI({
    super.key,
    this.onTap,
    this.onAITap,
  });

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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(
                Icons.search,
                color: Colors.grey,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Buscar / preguntar a IA',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAITap,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFD7A15D),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
