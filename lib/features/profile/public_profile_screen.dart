import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicProfileScreen extends StatelessWidget {
  final String username;
  const PublicProfileScreen({super.key, required this.username});

  Future<Map<String, dynamic>?> _getUser() async {
    final query = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).limit(1).get();
    if (query.docs.isNotEmpty) return query.docs.first.data() as Map<String, dynamic>;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Perfil', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) return const Center(child: Text('Usuario no encontrado', style: TextStyle(color: Colors.grey, fontSize: 18)));
          final u = snapshot.data!;
          return Center(
            child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD7A15D), width: 3), gradient: const LinearGradient(colors: [Color(0xFF2A2A4E), Color(0xFF1A1A2E)])), child: Center(child: Text((u['name'] ?? '?')[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 20),
              Text(u['name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(u['username'] ?? '', style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 18)),
              const SizedBox(height: 8),
              Text(u['bio'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD7A15D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Enviar solicitud', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)))),
            ])),
          );
        },
      ),
    );
  }
}
