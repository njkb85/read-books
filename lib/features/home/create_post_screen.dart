import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:convert';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageBase64;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 800);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() { _imageBytes = bytes; _imageBase64 = base64Encode(bytes); });
    }
  }

  Future<void> _publish() async {
    if (_textController.text.trim().isEmpty && _imageBase64 == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _loading = true);
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userData = userDoc.data() ?? {};
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid, 'userName': userData['name'] ?? 'Usuario', 'userHandle': userData['username'] ?? '@usuario',
        'text': _textController.text.trim(), 'imageBase64': _imageBase64 ?? '',
        'likes': 0, 'comments': 0, 'reposts': 0, 'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicado!'), backgroundColor: Color(0xFF4CAF50))); Navigator.pop(context, true); }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: '), backgroundColor: Colors.red)); }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Crear Post', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)), actions: [TextButton(onPressed: _loading ? null : _publish, child: Text(_loading ? '...' : 'Publicar', style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 16)))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withAlpha(51)), child: const Center(child: Icon(Icons.person, color: Color(0xFFD7A15D)))), const SizedBox(width: 12), Expanded(child: TextField(controller: _textController, maxLines: 6, autofocus: true, style: const TextStyle(color: Colors.white, fontSize: 16), decoration: const InputDecoration(hintText: 'Que estas leyendo?', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none)))]),
        const SizedBox(height: 20),
        if (_imageBytes != null) ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.memory(_imageBytes!, height: 300, width: double.infinity, fit: BoxFit.cover)),
        const SizedBox(height: 20),
        Row(children: [GestureDetector(onTap: _pickImage, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1B1B1B), borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.image, color: Color(0xFF4CAF50), size: 22), SizedBox(width: 8), Text('Agregar foto', style: TextStyle(color: Colors.white))])))]),
      ])),
    );
  }
}
