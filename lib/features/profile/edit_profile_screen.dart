import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _saving = false;
  bool _loaded = false;

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
      }
    } catch (_) {}
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _save() async {
    if (_saving) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim().isEmpty ? 'Usuario READ' : _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'username': '@${_usernameController.text.trim().replaceAll('@', '').replaceAll(' ', '')}',
        'email': user.email ?? '',
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado'), backgroundColor: Color(0xFF4CAF50), duration: Duration(seconds: 1)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(backgroundColor: Color(0xFF0F0F0F), body: Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D))));

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? '...' : 'Guardar', style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 20),
          Center(child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withOpacity(0.2)), child: const Center(child: Icon(Icons.person, color: Color(0xFFD7A15D), size: 50)))),
          const SizedBox(height: 32),
          TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 16),
          TextField(controller: _usernameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Usuario', labelStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixText: '@', prefixStyle: const TextStyle(color: Color(0xFFD7A15D)))),
          const SizedBox(height: 16),
          TextField(controller: _bioController, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        ]),
      ),
    );
  }
}
