import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageBase64;
  bool _saving = false;
  bool _loaded = false;
  String? _currentPhotoBase64;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _usernameController.text = (data['username'] ?? 'usuario').replaceAll('@', '');
        _currentPhotoBase64 = data['photoBase64'];
      }
    } catch (_) {}
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: '), backgroundColor: Colors.red));
    }
  }

  Widget _buildPhoto() {
    if (_imageBytes != null) return Image.memory(_imageBytes!, fit: BoxFit.cover, width: 110, height: 110);
    if (_currentPhotoBase64 != null && _currentPhotoBase64!.isNotEmpty) return Image.memory(base64Decode(_currentPhotoBase64!), fit: BoxFit.cover, width: 110, height: 110);
    return const Icon(Icons.person, color: Color(0xFFD7A15D), size: 50);
  }

  Future<void> _save() async {
    if (_saving) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim().isEmpty ? 'Usuario READ' : _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'username': '@',
        if (_imageBase64 != null) 'photoBase64': _imageBase64,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado!'), backgroundColor: Color(0xFF4CAF50)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: '), backgroundColor: Colors.red));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(backgroundColor: Color(0xFF0F0F0F), body: Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D))));
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Editar Perfil', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)), actions: [TextButton(onPressed: _saving ? null : _save, child: Text(_saving ? '...' : 'Guardar', style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 16)))]),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        const SizedBox(height: 20),
        Center(child: GestureDetector(onTap: _pickImage, child: Stack(children: [
          Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD7A15D), width: 3), color: const Color(0xFF1A1A2E)), child: ClipOval(child: _buildPhoto())),
          Positioned(bottom: 0, right: 0, child: Container(width: 36, height: 36, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: const Icon(Icons.camera_alt, color: Colors.black, size: 18))),
        ]))),
        const SizedBox(height: 8),
        TextButton(onPressed: _pickImage, child: Text('Seleccionar foto', style: TextStyle(color: Colors.grey[500], fontSize: 13))),
        const SizedBox(height: 24),
        TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 16),
        TextField(controller: _usernameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Usuario', labelStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixText: '@', prefixStyle: const TextStyle(color: Color(0xFFD7A15D)))),
        const SizedBox(height: 16),
        TextField(controller: _bioController, maxLines: 4, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
      ])),
    );
  }
}
