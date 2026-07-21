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
  final _currentUser = FirebaseAuth.instance.currentUser;

  bool get _isGuest => _currentUser == null || _currentUser.isAnonymous;

  @override
  void initState() {
    super.initState();
    if (!_isGuest) {
      _loadUsers();
    }
  }

  List<Map<String, dynamic>> _allUsers = [];
  bool _loading = true;

  Future<void> _loadUsers() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('users').get();
      if (mounted) {
        setState(() {
          _allUsers = snap.docs
              .where((d) => d.id != _currentUser?.uid)
              .map((d) => {'id': d.id, ...d.data()})
              .toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _allUsers;
    return _allUsers.where((u) {
      final name = (u['name'] ?? '').toString().toLowerCase();
      final username = (u['username'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || username.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGuest) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.lock_outline, color: Color(0xFFD7A15D), size: 80),
                const SizedBox(height: 24),
                const Text('Inicia sesion para ver tus mensajes', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                const Text('Los mensajes son privados.', style: TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/login'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD7A15D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Iniciar sesion', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)))),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const MessagesHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase().trim()),
              decoration: InputDecoration(
                hintText: 'Buscar usuarios...', hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); }) : null,
                filled: true, fillColor: const Color(0xFF1B1B1B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D)))
                : _filtered.isEmpty
                    ? Center(child: Text(_searchQuery.isEmpty ? 'No hay usuarios' : 'No encontrado', style: const TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _filtered.length,
                        itemBuilder: (context, i) {
                          final u = _filtered[i];
                          return ListTile(
                            leading: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withValues(alpha: 0.2)), child: Center(child: Text((u['name'] ?? '?').toString()[0].toUpperCase(), style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 18)))),
                            title: Text(u['name'] ?? 'Usuario', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            subtitle: Text(u['username'] ?? '@usuario', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            trailing: const Icon(Icons.message_outlined, color: Color(0xFFD7A15D)),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(receiverId: u['id'] ?? '', receiverName: u['name'] ?? 'Usuario'))),
                          );
                        },
                      ),
          ),
        ]),
      ),
    );
  }
}
