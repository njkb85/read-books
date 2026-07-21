import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});
  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _showAssistant = false;
  final _assistantController = TextEditingController();
  final List<String> _assistantMessages = [];
  bool _assistantTyping = false;

  final List<HelpArticle> _articles = [
    HelpArticle('Como crear una cuenta', 'Ve a Registro, ingresa tu nombre, email y contrasena. Toca "Registrarse".'),
    HelpArticle('Como publicar un post', 'En Inicio, toca "Que estas leyendo?", escribe y publica.'),
    HelpArticle('Como buscar usuarios', 'Toca la lupa en Inicio y escribe el nombre o @usuario.'),
    HelpArticle('Como jugar ajedrez', 'Ve a tu Perfil > Centro Creativo > Ajedrez.'),
    HelpArticle('Como vender un libro', 'Ve a Ventas, toca "+ Publicar venta".'),
    HelpArticle('Como cambiar contrasena', 'Configuracion > Cambiar contrasena.'),
  ];

  List<HelpArticle> get _filtered {
    if (_query.isEmpty) return _articles;
    return _articles.where((a) => a.title.toLowerCase().contains(_query.toLowerCase()) || a.content.toLowerCase().contains(_query.toLowerCase())).toList();
  }

  void _sendToAssistant(String msg) {
    if (msg.trim().isEmpty) return;
    setState(() {
      _assistantMessages.add('Tu: $msg');
      _assistantTyping = true;
    });
    _assistantController.clear();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _assistantTyping = false;
          String reply = _generateReply(msg);
          _assistantMessages.add('Asistente: $reply');
        });
      }
    });
  }

  String _generateReply(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('post') || lower.contains('publicar')) return 'Para publicar, ve a Inicio y toca "Que estas leyendo?". Escribe tu texto y toca Publicar. Puedes agregar una foto tambien.';
    if (lower.contains('buscar') || lower.contains('usuario')) return 'Toca la lupa en la esquina superior izquierda de Inicio. Escribe el nombre o @usuario que buscas.';
    if (lower.contains('contraseña') || lower.contains('contrasena')) return 'Ve a Configuracion > Cambiar contrasena. Ingresa tu nueva contrasena y confirma.';
    if (lower.contains('ajedrez')) return 'El ajedrez esta en tu Perfil > Centro Creativo > Entrena tu mente. Puedes jugar contra IA o contra un amigo.';
    if (lower.contains('vender') || lower.contains('venta')) return 'Ve a la pestana Ventas y toca "+ Publicar venta". Llena los datos de tu libro y publica.';
    if (lower.contains('perfil') || lower.contains('editar')) return 'En tu Perfil, toca el icono de lapiz para editar tu nombre, usuario y bio.';
    return 'Gracias por tu mensaje. Puedes buscar en los articulos de ayuda o preguntarme algo mas especifico. Estoy aqui para ayudarte.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Centro de Ayuda', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(_showAssistant ? Icons.article_outlined : Icons.auto_awesome, color: _showAssistant ? const Color(0xFFD7A15D) : Colors.grey),
            onPressed: () => setState(() => _showAssistant = !_showAssistant),
            tooltip: 'Asistente IA',
          ),
        ],
      ),
      body: _showAssistant ? _buildAssistant() : _buildArticles(),
    );
  }

  Widget _buildArticles() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Buscar en ayuda...',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Color(0xFFD7A15D)),
            filled: true, fillColor: const Color(0xFF1B1B1B),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
      ),
      Expanded(
        child: _filtered.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.help_outline, color: Colors.grey, size: 64), const SizedBox(height: 16), Text(_query.isEmpty ? 'Busca tu pregunta o usa el asistente IA' : 'Sin resultados', style: const TextStyle(color: Colors.grey))]))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filtered.length,
                itemBuilder: (context, i) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(14)),
                  child: ExpansionTile(
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: const Color(0xFF1A1A2E),
                    collapsedBackgroundColor: const Color(0xFF181818),
                    title: Text(_filtered[i].title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                    children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Text(_filtered[i].content, style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5)))],
                  ),
                ),
              ),
      ),
    ]);
  }

  Widget _buildAssistant() {
    return Column(children: [
      Expanded(
        child: _assistantMessages.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.auto_awesome, color: Color(0xFFD7A15D), size: 64), const SizedBox(height: 16), const Text('Asistente IA de READ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Preguntame lo que necesites', style: TextStyle(color: Colors.grey))]))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _assistantMessages.length + (_assistantTyping ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _assistantMessages.length) {
                    return const Padding(padding: EdgeInsets.all(8), child: Row(children: [CircularProgressIndicator(color: Color(0xFFD7A15D), strokeWidth: 2), SizedBox(width: 12), Text('Escribiendo...', style: TextStyle(color: Colors.grey))]));
                  }
                  final msg = _assistantMessages[i];
                  final isUser = msg.startsWith('Tu:');
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFFD7A15D) : const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                          bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                        ),
                      ),
                      child: Text(msg.replaceFirst(isUser ? 'Tu: ' : 'Asistente: ', ''), style: TextStyle(color: isUser ? Colors.black : Colors.white, fontSize: 14)),
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
          Expanded(child: TextField(controller: _assistantController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Escribe tu pregunta...', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16)))),
          const SizedBox(width: 8),
          GestureDetector(onTap: () => _sendToAssistant(_assistantController.text), child: Container(width: 44, height: 44, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: const Icon(Icons.send, color: Colors.black, size: 20))),
        ]),
      ),
    ]);
  }
}

class HelpArticle {
  final String title, content;
  const HelpArticle(this.title, this.content);
}
