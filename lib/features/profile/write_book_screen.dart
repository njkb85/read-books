import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteBookScreen extends StatefulWidget {
  const WriteBookScreen({super.key});
  @override
  State<WriteBookScreen> createState() => _WriteBookScreenState();
}

class _WriteBookScreenState extends State<WriteBookScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final List<String> _chapters = [];
  bool _loading = false;

  Future<void> _saveChapter() async {
    if (_contentController.text.trim().isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('books').add({
        'userId': user.uid,
        'title': _titleController.text.trim().isEmpty ? 'Sin titulo' : _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'chapter': _chapters.length + 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _chapters.add(_contentController.text.trim());
        _contentController.clear();
      });

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Capitulo guardado!'), backgroundColor: Color(0xFF4CAF50)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Escribe tu libro', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [TextButton(onPressed: _loading ? null : _saveChapter, child: Text(_loading ? '...' : 'Guardar', style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold)))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(hintText: 'Titulo de tu libro...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 16, height: 1.6),
              decoration: InputDecoration(
                hintText: 'Empieza a escribir...\n\nTu historia comienza aqui.',
                hintStyle: TextStyle(color: Colors.grey[600], height: 1.6),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          // Capítulos guardados
          if (_chapters.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Capitulos (${_chapters.length})', style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(_chapters.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    Text('Cap ${i + 1}: ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Expanded(child: Text(_chapters[i].length > 50 ? '${_chapters[i].substring(0, 50)}...' : _chapters[i], style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  ]),
                )),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}
