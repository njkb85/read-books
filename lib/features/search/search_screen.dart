import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../messages/chat_screen.dart';
import '../profile/public_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  String _q = '';
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;

  void _search(String q) {
    _q = q.toLowerCase().trim();
    if (_q.isEmpty) { setState(() { _results = []; _loading = false; }); return; }
    setState(() => _loading = true);
    
    print('Buscando: $_q');
    
    FirebaseFirestore.instance.collection('users').get().then((snap) {
      print('Documentos en users: ${snap.docs.length}');
      for (var d in snap.docs) {
        print('  ${d.id}: ${d.data()}');
      }
      
      final list = snap.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).where((u) {
        final n = (u['name'] ?? '').toString().toLowerCase();
        final un = (u['username'] ?? '').toString().toLowerCase();
        final match = n.contains(_q) || un.contains(_q);
        print('  Checking $n / $un: match=$match');
        return match;
      }).toList();
      
      print('Resultados: ${list.length}');
      if (mounted) setState(() { _results = list; _loading = false; });
    }).catchError((e) {
      print('ERROR: $e');
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.transparent, title: TextField(controller: _ctrl, autofocus: true, style: const TextStyle(color: Colors.white), onChanged: _search, decoration: const InputDecoration(hintText: 'Buscar usuarios...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none)), leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
      body: _q.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search, color: Colors.grey, size: 64), SizedBox(height: 16), Text('Busca por nombre o @usuario', style: TextStyle(color: Colors.grey))]))
          : _loading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D)))
              : _results.isEmpty
                  ? Center(child: Text('No encontrado: $_q', style: const TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, i) {
                        final u = _results[i];
                        return ListTile(
                          leading: Container(width: 48, height: 48, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFFD7A15D), Color(0xFFC96A2B)])), child: Center(child: Text((u['name'] ?? '?').toString()[0].toUpperCase(), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)))),
                          title: Text(u['name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(u['username'] ?? '', style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 13)),
                          trailing: IconButton(icon: const Icon(Icons.message_outlined, color: Color(0xFFD7A15D)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(receiverId: u['id'] ?? '', receiverName: u['name'] ?? '')))),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(username: u['username'] ?? ''))),
                        );
                      },
                    ),
    );
  }
}
