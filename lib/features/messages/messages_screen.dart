import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/messages_header.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const MessagesHeader(),
          // Buscador único
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase().trim()),
              decoration: InputDecoration(
                hintText: 'Buscar usuarios...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); }) : const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.auto_awesome, color: Color(0xFFD7A15D))),
                filled: true, fillColor: const Color(0xFF1B1B1B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').orderBy('name').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D)));
                var users = snapshot.data!.docs.where((d) => d.id != currentUid).toList();
                if (_searchQuery.isNotEmpty) users = users.where((d) => (d['name'] ?? '').toString().toLowerCase().contains(_searchQuery) || (d['username'] ?? '').toString().toLowerCase().contains(_searchQuery)).toList();
                if (users.isEmpty) return Center(child: Text(_searchQuery.isEmpty ? 'No hay usuarios' : 'No encontrado', style: const TextStyle(color: Colors.grey)));
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: users.length,
                  itemBuilder: (context, i) {
                    final u = users[i].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withOpacity(0.2)), child: Center(child: Text((u['name'] ?? '?').toString()[0].toUpperCase(), style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 18)))),
                      title: Text(u['name'] ?? 'Usuario', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: Text(u['username'] ?? '@usuario', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      trailing: const Icon(Icons.message_outlined, color: Color(0xFFD7A15D)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(receiverId: users[i].id, receiverName: u['name'] ?? 'Usuario'))),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
