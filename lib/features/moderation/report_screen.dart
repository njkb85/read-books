import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportScreen extends StatefulWidget {
  final String contentId;
  final String contentType;
  const ReportScreen({super.key, required this.contentId, required this.contentType});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _reasonController = TextEditingController();
  String _selectedReason = 'Spam';

  final _reasons = ['Spam', 'Contenido ofensivo', 'Acoso', 'Informacion falsa', 'Violencia', 'Otro'];

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('reports').add({
      'reporterId': user.uid,
      'contentId': widget.contentId,
      'contentType': widget.contentType,
      'reason': _selectedReason,
      'details': _reasonController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reporte enviado'), backgroundColor: Color(0xFF4CAF50)));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Reportar', style: TextStyle(color: Colors.white))),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Motivo', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: _reasons.map((r) => GestureDetector(
          onTap: () => setState(() => _selectedReason = r),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: _selectedReason == r ? const Color(0xFFD7A15D) : const Color(0xFF1B1B1B), borderRadius: BorderRadius.circular(20)), child: Text(r, style: TextStyle(color: _selectedReason == r ? Colors.black : Colors.white)))),
        ).toList()),
        const SizedBox(height: 24),
        TextField(controller: _reasonController, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Detalles adicionales...', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF1B1B1B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: _submit, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)), child: const Text('Enviar reporte', style: TextStyle(color: Colors.white, fontSize: 16)))),
      ])),
    );
  }
}
