import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/firestore_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  // Lista de emojis comunes
  final List<String> _emojis = ['😀', '😂', '❤️', '🔥', '📚', '👏', '😍', '🤔', '✨', '🎉', '💯', '🙌', '😎', '🥰', '📖', '✍️', '♟️', '🌟', '💪', '🎯'];
  bool _showEmoji = false;

  void _sendMessage({String? text}) {
    if (text != null && text.trim().isNotEmpty) {
      _firestore.sendMessage(widget.receiverId, text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Enviar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListTile(leading: const Icon(Icons.camera_alt, color: Color(0xFFD7A15D)), title: const Text('Camara', style: TextStyle(color: Colors.white)), onTap: () async { Navigator.pop(ctx); final pic = await _picker.pickImage(source: ImageSource.camera); if (pic != null) _sendMessage(text: '📷 Foto enviada'); }),
          ListTile(leading: const Icon(Icons.videocam, color: Color(0xFFD7A15D)), title: const Text('Video', style: TextStyle(color: Colors.white)), onTap: () async { Navigator.pop(ctx); final vid = await _picker.pickVideo(source: ImageSource.camera); if (vid != null) _sendMessage(text: '🎥 Video enviado'); }),
          ListTile(leading: const Icon(Icons.photo_library, color: Color(0xFFD7A15D)), title: const Text('Galeria', style: TextStyle(color: Colors.white)), onTap: () async { Navigator.pop(ctx); final pic = await _picker.pickImage(source: ImageSource.gallery); if (pic != null) _sendMessage(text: '🖼️ Imagen enviada'); }),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withValues(alpha: 0.2)), child: Center(child: Text(widget.receiverName[0].toUpperCase(), style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold, fontSize: 18)))),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.receiverName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), const Text('En linea', style: TextStyle(color: Colors.grey, fontSize: 12))]),
        ]),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.getMessages(widget.receiverId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D)));
              final messages = snapshot.data!.docs;
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index].data() as Map<String, dynamic>;
                  bool isMe = msg['senderId'] == currentUser.uid;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFFD7A15D) : const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20), bottomLeft: isMe ? const Radius.circular(20) : Radius.zero, bottomRight: isMe ? Radius.zero : const Radius.circular(20)),
                      ),
                      child: Text(msg['text'] ?? '', style: TextStyle(color: isMe ? Colors.black : Colors.white, fontSize: 15)),
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Barra de emojis
        if (_showEmoji)
          Container(
            height: 200,
            color: const Color(0xFF1A1A2E),
            child: GridView.count(
              crossAxisCount: 6,
              padding: const EdgeInsets.all(8),
              children: _emojis.map((emoji) => GestureDetector(
                onTap: () {
                  _sendMessage(text: emoji);
                  setState(() => _showEmoji = false);
                },
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
              )).toList(),
            ),
          ),
        // Input bar
        Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0xFF1A1A2E),
          child: Row(children: [
            GestureDetector(onTap: () => setState(() => _showEmoji = !_showEmoji), child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2A2A4E)), child: const Center(child: Text('😀', style: TextStyle(fontSize: 20))))),
            const SizedBox(width: 8),
            GestureDetector(onTap: _pickImage, child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2A2A4E)), child: const Icon(Icons.photo_camera, color: Color(0xFFD7A15D), size: 20))),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'Escribe un mensaje...', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2A2A4E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                onSubmitted: (v) => _sendMessage(text: v),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(text: _messageController.text),
              child: Container(width: 44, height: 44, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7A15D)), child: const Icon(Icons.send, color: Colors.black, size: 20)),
            ),
          ]),
        ),
      ]),
    );
  }
}
