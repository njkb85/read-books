import 'package:flutter/material.dart';
import '../write_book_screen.dart';

class WritingCard extends StatelessWidget {
  const WritingCard({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WriteBookScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A1A3E), Color(0xFF2A1A3E)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF3A2A5E), width: 0.5)),
        child: Row(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: const Color(0xFF7B61FF).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.edit_note, color: Color(0xFF7B61FF), size: 30)),
          const SizedBox(width: 16),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Escribe tu libro', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Empieza una novela, guarda borradores y continua donde lo dejaste.', style: TextStyle(color: Colors.grey, fontSize: 13))])),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ]),
      ),
    );
  }
}
