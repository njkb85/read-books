import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class CreateSaleScreen extends StatefulWidget {
  const CreateSaleScreen({super.key});
  @override
  State<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _publish() async {
    if (_titleController.text.trim().isEmpty || _priceController.text.trim().isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? {};
      await FirebaseFirestore.instance.collection('sales').add({
        'title': _titleController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0,
        'description': _descController.text.trim(),
        'sellerId': user.uid,
        'sellerName': data['name'] ?? 'Usuario',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Venta publicada!'), backgroundColor: Color(0xFF4CAF50)));
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
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Publicar Venta', style: TextStyle(color: Colors.white)), leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)), actions: [TextButton(onPressed: _loading ? null : _publish, child: Text(_loading ? '...' : 'Publicar', style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold)))],),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        TextField(controller: _titleController, style: const TextStyle(color: Colors.white, fontSize: 16), decoration: InputDecoration(hintText: 'Titulo del producto', hintStyle: TextStyle(color: Colors.grey[600]), border: InputBorder.none)),
        const SizedBox(height: 12),
        TextField(controller: _priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 20, fontWeight: FontWeight.bold), decoration: InputDecoration(hintText: 'Precio en EUR', hintStyle: TextStyle(color: Colors.grey[600]), border: InputBorder.none, prefixText: 'EUR ', prefixStyle: const TextStyle(color: Color(0xFFD7A15D)))),
        const SizedBox(height: 12),
        TextField(controller: _descController, maxLines: 4, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Descripcion...', hintStyle: TextStyle(color: Colors.grey[600]), border: InputBorder.none)),
        const SizedBox(height: 20),
        if (_image != null) ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_image!, height: 200, width: double.infinity, fit: BoxFit.cover)),
        const SizedBox(height: 20),
        GestureDetector(onTap: _pickImage, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF1B1B1B), borderRadius: BorderRadius.circular(12)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate, color: Color(0xFF4CAF50)), SizedBox(width: 8), Text('Agregar foto', style: TextStyle(color: Colors.white))]))),
      ])),
    );
  }
}
