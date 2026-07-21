import 'package:flutter/material.dart';

class AiWriterScreen extends StatefulWidget {
  const AiWriterScreen({super.key});
  @override
  State<AiWriterScreen> createState() => _AiWriterScreenState();
}

class _AiWriterScreenState extends State<AiWriterScreen> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _thinking = false;

  void _sendPrompt() {
    if (_controller.text.trim().isEmpty) return;
    final prompt = _controller.text.trim();
    
    setState(() {
      _messages.add({'role': 'user', 'text': prompt});
      _thinking = true;
    });
    _controller.clear();

    // Simular respuesta IA (aquí conectarías con OpenAI)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _thinking = false;
          String response = _generateIdea(prompt);
          _messages.add({'role': 'ai', 'text': response});
        });
      }
    });
  }

  String _generateIdea(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('personaje')) return 'Te presento a Elena Vega, una restauradora de libros antiguos que descubre un manuscrito maldito en la Biblioteca Nacional. Es inteligente, curiosa y tiene un oscuro pasado que la conecta con el libro.';
    if (lower.contains('mundo') || lower.contains('universo')) return 'Imagina un mundo donde los libros son portales a otras dimensiones. Cada libro te transporta al mundo que describe. Pero hay un libro prohibido que contiene todos los mundos a la vez.';
    if (lower.contains('capitulo') || lower.contains('historia')) return 'El capítulo comienza en una librería de viejo en Praga. Una joven encuentra un diario del siglo XIX entre las páginas de un libro. Al abrirlo, descubre que el diario está escrito con su propia letra.';
    if (lower.contains('final') || lower.contains('giro')) return 'El protagonista descubre que ha estado viviendo dentro de un libro todo este tiempo. Cada decisión que tomó ya estaba escrita. Pero ahora tiene la oportunidad de reescribir su propio final.';
    if (lower.contains('villano') || lower.contains('antagonista')) return 'El villano es un bibliotecario inmortal que ha leído todos los libros del mundo. Cree que la humanidad ya no merece nuevas historias y planea destruir la imaginación para siempre.';
    return 'Basado en tu idea, te sugiero desarrollar un personaje principal que sea un lector empedernido. Comienza describiendo su relación con los libros: ¿lee para escapar? ¿para aprender? ¿para recordar? De ahí surgirá todo.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Escritor IA', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        // Sugerencias rápidas
        if (_messages.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(spacing: 8, children: [
              _chip('Crear personaje'),
              _chip('Construir mundo'),
              _chip('Primer capítulo'),
              _chip('Giro final'),
              _chip('Villano'),
            ]),
          ),
        // Chat
        Expanded(
          child: _messages.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.auto_awesome, color: Color(0xFFD7A15D), size: 64), SizedBox(height: 16), Text('Describeme tu idea y te ayudare\na desarrollarla', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16))]))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_thinking ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == _messages.length) {
                      return const Padding(padding: EdgeInsets.all(8), child: Row(children: [CircularProgressIndicator(color: Color(0xFFD7A15D), strokeWidth: 2), SizedBox(width: 12), Text('Escribiendo...', style: TextStyle(color: Colors.grey))]));
                    }
                    final msg = _messages[i];
                    final isUser = msg['role'] == 'user';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFFD7A15D) : const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                            bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
                            bottomRight: isUser ? Radius.zero : const Radius.circular(18),
                          ),
                        ),
                        child: Text(msg['text']!, style: TextStyle(color: isUser ? Colors.black : Colors.white, fontSize: 14, height: 1.5)),
                      ),
                    );
                  },
                ),
        ),
        // Input
        Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0xFF1A1A2E),
          child: Row(children: [
            Expanded(child: TextField(controller: _controller, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Ej: Creame un personaje para novela fantastica...', hintStyle: const TextStyle(color: Colors.grey, fontSize: 13), filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16)))),
            const SizedBox(width: 8),
            GestureDetector(onTap: _sendPrompt, child: Container(width: 44, height: 44, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: const Icon(Icons.auto_awesome, color: Colors.black, size: 20))),
          ]),
        ),
      ]),
    );
  }

  Widget _chip(String label) {
    return GestureDetector(
      onTap: () {
        _controller.text = label;
        _sendPrompt();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF3A3A5E))),
        child: Text(label, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 13)),
      ),
    );
  }
}
