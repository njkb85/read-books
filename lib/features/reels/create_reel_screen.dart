import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({super.key});
  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen> {
  final _quoteController = TextEditingController();
  final _authorController = TextEditingController();
  final _questionController = TextEditingController();
  File? _mediaFile;
  bool _isVideo = false;
  bool _loading = false;

  Future<void> _pickFromCamera() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Crear Reel', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Color(0xFFC96A2B), size: 28),
            title: const Text('Camara', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Tomar una foto', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () async {
              Navigator.pop(ctx);
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.camera);
              if (picked != null) setState(() { _mediaFile = File(picked.path); _isVideo = false; });
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam, color: Color(0xFFC96A2B), size: 28),
            title: const Text('Video', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Grabar un video', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () async {
              Navigator.pop(ctx);
              final picker = ImagePicker();
              final picked = await picker.pickVideo(source: ImageSource.camera);
              if (picked != null) setState(() { _mediaFile = File(picked.path); _isVideo = true; });
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Color(0xFFC96A2B), size: 28),
            title: const Text('Galeria', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Seleccionar foto o video', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () async {
              Navigator.pop(ctx);
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) setState(() { _mediaFile = File(picked.path); _isVideo = false; });
            },
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Future<void> _publish() async {
    if (_quoteController.text.trim().isEmpty && _mediaFile == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? {};
      
      await FirebaseFirestore.instance.collection('reels').add({
        'userId': user.uid,
        'userName': data['name'] ?? 'Usuario',
        'userHandle': data['username'] ?? '@usuario',
        'quote': _quoteController.text.trim(),
        'author': _authorController.text.trim().isEmpty ? 'Anonimo' : _authorController.text.trim(),
        'question': _questionController.text.trim(),
        'hasMedia': _mediaFile != null,
        'isVideo': _isVideo,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reel publicado!'), backgroundColor: Color(0xFF4CAF50)));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Crear Reel', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [TextButton(onPressed: _loading ? null : _publish, child: Text(_loading ? '...' : 'Publicar', style: const TextStyle(color: Color(0xFFC96A2B), fontWeight: FontWeight.bold)))],
      ),
      body: GestureDetector(
        onTap: _mediaFile == null ? _pickFromCamera : null,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF0D0D0D),
          child: _mediaFile != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    _isVideo
                        ? const Center(child: Icon(Icons.videocam, color: Colors.white54, size: 64))
                        : Image.file(_mediaFile!, fit: BoxFit.cover),
                    // Capa para la frase
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_quoteController.text.isNotEmpty)
                            Text(_quoteController.text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 8)])),
                          if (_authorController.text.isNotEmpty)
                            Text(_authorController.text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    // Botón cambiar
                    Positioned(
                      top: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: _pickFromCamera,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    // Input de frase
                    Positioned(
                      bottom: 40,
                      left: 20,
                      right: 20,
                      child: TextField(
                        controller: _quoteController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Escribe una frase...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black38,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: const Color(0xFFC96A2B).withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.add_a_photo, color: Color(0xFFC96A2B), size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Toca para crear un Reel', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Toma una foto, graba un video\no elige de tu galeria', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
        ),
      ),
    );
  }
}
