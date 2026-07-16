import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/conversation_model.dart';
import 'widgets/messages_header.dart';
import 'widgets/search_bar_ai.dart';
import 'widgets/featured_card.dart';
import 'widgets/message_tabs.dart';
import 'widgets/conversation_tile.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSearch = false;

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs
        .where((doc) => doc.id != FirebaseAuth.instance.currentUser?.uid)
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MessagesHeader(),
            GestureDetector(
              onTap: () => setState(() => _showSearch = true),
              child: const SearchBarWithAI(),
            ),
            if (_showSearch) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar usuarios...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFD7A15D)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _showSearch = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1B1B1B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase().trim()),
                ),
              ),
            ],
            if (!_showSearch) ...[
              const FeaturedCard(),
              const MessageTabs(),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline, color: Colors.grey, size: 64),
                          const SizedBox(height: 16),
                          const Text('No hay usuarios registrados', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => setState(() {}),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD7A15D)),
                            child: const Text('Recargar', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    );
                  }

                  var users = snapshot.data!;
                  if (_searchQuery.isNotEmpty) {
                    users = users.where((u) {
                      final name = (u['name'] ?? '').toString().toLowerCase();
                      return name.contains(_searchQuery);
                    }).toList();
                  }

                  if (users.isEmpty) {
                    return Center(
                      child: Text('No se encontro: "$_searchQuery"', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userData = users[index];
                      final name = userData['name'] ?? 'Sin nombre';
                      final email = userData['email'] ?? '';
                      return ConversationTile(
                        conversation: ConversationModel(
                          id: userData['id'],
                          name: name.toString(),
                          lastMessage: email.toString(),
                          time: '',
                          unreadCount: 0,
                          avatarColor: 0xFFD7A15D,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                receiverId: userData['id'],
                                receiverName: name.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
