import 'package:flutter/material.dart';
import '../ai_writer_screen.dart';

class AiWriterCard extends StatelessWidget {
  const AiWriterCard({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiWriterScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A1A2A), Color(0xFF3A1A3A)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF5A2A5A), width: 0.5)),
        child: Row(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: const Color(0xFFD7A15D).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.auto_awesome, color: Color(0xFFD7A15D), size: 28)),
          const SizedBox(width: 16),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Escritor IA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Genera ideas, personajes, mundos y capitulos con IA.', style: TextStyle(color: Colors.grey, fontSize: 13))])),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ]),
      ),
    );
  }
}
