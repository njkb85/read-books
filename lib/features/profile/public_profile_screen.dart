import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class PublicProfileScreen extends StatefulWidget {
  final String username;
  const PublicProfileScreen({super.key, required this.username});
  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  bool _requestSent = false;
  bool _loading = false;

  Future<void> _sendFriendRequest(String targetUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesion para enviar solicitudes'), backgroundColor: Colors.orange));
      return;
    }
    setState(() => _loading = true);
    try {
      final existing = await FirebaseFirestore.instance.collection('friend_requests').where('from', isEqualTo: currentUser.uid).where('to', isEqualTo: targetUserId).where('status', isEqualTo: 'pending').get();
      if (existing.docs.isNotEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ya enviaste una solicitud'), backgroundColor: Colors.orange));
        setState(() { _loading = false; _requestSent = true; });
        return;
      }
      await FirebaseFirestore.instance.collection('friend_requests').add({'from': currentUser.uid, 'to': targetUserId, 'status': 'pending', 'createdAt': FieldValue.serverTimestamp()});
      await FirebaseFirestore.instance.collection('users').doc(targetUserId).update({'followers': FieldValue.increment(1)});
      setState(() => _requestSent = true);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solicitud enviada!'), backgroundColor: Color(0xFF4CAF50)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: '), backgroundColor: Colors.red));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: FirebaseFirestore.instance.collection('users').where('username', isEqualTo: widget.username).limit(1).get().then((snap) {
        if (snap.docs.isNotEmpty) return {'id': snap.docs.first.id, ...snap.docs.first.data()};
        return null;
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(backgroundColor: const Color(0xFF0F0F0F), appBar: AppBar(backgroundColor: Colors.transparent, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))), body: const Center(child: Text('Usuario no encontrado', style: TextStyle(color: Colors.grey, fontSize: 18))));
        }
        final user = snapshot.data!;
        final photoBase64 = user['photoBase64'] as String?;
        
        Widget avatarWidget;
        if (photoBase64 != null && photoBase64.isNotEmpty) {
          avatarWidget = Image.memory(base64Decode(photoBase64), fit: BoxFit.cover, width: 120, height: 120);
        } else {
          avatarWidget = Center(child: Text((user['name'] ?? '?').toString()[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)));
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0F0F0F),
          appBar: AppBar(backgroundColor: Colors.transparent, leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))),
          body: Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD7A15D), width: 3)), child: ClipOval(child: avatarWidget)),
            const SizedBox(height: 20),
            Text(user['name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user['username'] ?? '', style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 18)),
            const SizedBox(height: 8),
            Text(user['bio'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _stat('', 'Libros'), const SizedBox(width: 40),
              _stat('', 'Seguidores'), const SizedBox(width: 40),
              _stat('', 'Siguiendo'),
            ]),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: _loading || _requestSent ? null : () => _sendFriendRequest(user['id'] ?? ''), style: ElevatedButton.styleFrom(backgroundColor: _requestSent ? Colors.grey : const Color(0xFFD7A15D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(_loading ? 'Enviando...' : _requestSent ? 'Solicitud enviada' : 'Enviar solicitud', style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)))),
          ]))),
        );
      },
    );
  }

  Widget _stat(String value, String label) {
    return Column(children: [Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))]);
  }
}
