import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../explore_books_screen.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Mi estanteria', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreBooksScreen())),
            child: const Text('+ Explorar >', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 14)),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      StreamBuilder<QuerySnapshot>(
        stream: user != null
            ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('bookshelf').orderBy('addedAt', descending: true).snapshots()
            : const Stream.empty(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreBooksScreen())),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF2A2A2A), width: 0.5)),
                child: const Column(children: [Icon(Icons.library_books_outlined, color: Color(0xFFD7A15D), size: 48), SizedBox(height: 12), Text('Tu estanteria esta vacia', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Explora libros gratuitos\ny añadelos a tu coleccion', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13))]),
              ),
            );
          }

          final books = snapshot.data!.docs;
          return SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: books.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final b = books[index].data() as Map<String, dynamic>;
                return Container(
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_colorFor(index), _colorFor(index + 3)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Text(b['title'] ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), maxLines: 3)),
                      Positioned(
                        top: 8, right: 8,
                        child: GestureDetector(
                          onTap: () => FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('bookshelf').doc(books[index].id).delete(),
                          child: Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.close, color: Colors.white, size: 14)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    ]);
  }

  Color _colorFor(int index) {
    final colors = [const Color(0xFF7B61FF), const Color(0xFFC96A2B), const Color(0xFF00BCD4), const Color(0xFF4CAF50), const Color(0xFF2196F3), const Color(0xFF795548), const Color(0xFFE53935)];
    return colors[index % colors.length];
  }
}
