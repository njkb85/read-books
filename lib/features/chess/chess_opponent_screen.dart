import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chess_lobby_screen.dart';

class ChessOpponentScreen extends StatelessWidget {
  const ChessOpponentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Multijugador', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: Column(
        children: [
          // Botón de partida rápida
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChessLobbyScreen())),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD7A15D), Color(0xFFC96A2B)]), borderRadius: BorderRadius.circular(20)),
              child: const Row(children: [Text('♟', style: TextStyle(fontSize: 40)), SizedBox(width: 16), Expanded(child: Text('PARTIDA RAPIDA\nBuscar oponente ya!', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)))])),
          ),
          const Padding(padding: EdgeInsets.all(16), child: Text('O reta a un amigo:', style: TextStyle(color: Colors.white, fontSize: 16))),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final users = snapshot.data!.docs.where((doc) => doc.id != FirebaseAuth.instance.currentUser?.uid).toList();
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final data = users[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withValues(alpha: 0.2)), child: Center(child: Text((data['name'] ?? '?')[0].toUpperCase(), style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold)))),
                      title: Text(data['name'] ?? 'Usuario', style: const TextStyle(color: Colors.white)),
                      trailing: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChessLobbyScreen())), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD7A15D)), child: const Text('Retar', style: TextStyle(color: Colors.black))),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
