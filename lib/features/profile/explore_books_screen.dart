import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/free_books.dart';

class ExploreBooksScreen extends StatefulWidget {
  const ExploreBooksScreen({super.key});
  @override
  State<ExploreBooksScreen> createState() => _ExploreBooksScreenState();
}

class _ExploreBooksScreenState extends State<ExploreBooksScreen> {
  String _selectedLang = 'ES';
  final List<String> _languages = ['ES', 'EN', 'PT', 'FR'];
  final Map<String, String> _langNames = {'ES': '🇪🇸 Espanol', 'EN': '🇬🇧 English', 'PT': '🇧🇷 Portugues', 'FR': '🇫🇷 Francais'};

  List<FreeBook> get _filtered => freeBooks.where((b) => _selectedLang == 'ALL' || b.language == _selectedLang).toList();

  Future<void> _addToShelf(FreeBook book) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('bookshelf').add({
      'title': book.title,
      'author': book.author,
      'coverUrl': book.coverUrl,
      'language': book.language,
      'category': book.category,
      'downloadUrl': book.downloadUrl,
      'addedAt': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${book.title} añadido a tu estanteria'), backgroundColor: const Color(0xFF4CAF50)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Explorar Libros', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        // Selector de idioma
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: _languages.map((lang) {
              final isSelected = _selectedLang == lang;
              return GestureDetector(
                onTap: () => setState(() => _selectedLang = lang),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFD7A15D) : const Color(0xFF1B1B1B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_langNames[lang]!, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
        ),
        // Lista de libros
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final book = _filtered[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  // Portada
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 60, height: 90,
                      color: const Color(0xFF2A2A4E),
                      child: book.coverUrl.isNotEmpty
                          ? Image.network(book.coverUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Center(child: Icon(Icons.book, color: Colors.white24)))
                          : const Center(child: Icon(Icons.book, color: Colors.white24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(book.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2),
                      const SizedBox(height: 4),
                      Text(book.author, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(book.description, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 2),
                    ]),
                  ),
                  Column(children: [
                    IconButton(icon: const Icon(Icons.bookmark_add, color: Color(0xFFD7A15D)), onPressed: () => _addToShelf(book), tooltip: 'Añadir a estanteria'),
                    IconButton(icon: const Icon(Icons.download, color: Color(0xFF4CAF50)), onPressed: () => launchUrl(Uri.parse(book.downloadUrl)), tooltip: 'Descargar gratis'),
                  ]),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
