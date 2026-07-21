import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserProfile(String name, String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String baseUsername = '@${name.toLowerCase().replaceAll(' ', '')}';
      String username = baseUsername;
      int counter = 1;
      while (true) {
        final existing = await _firestore.collection('users').where('username', isEqualTo: username).get();
        if (existing.docs.isEmpty) break;
        username = '$baseUsername$counter';
        counter++;
      }
      await _firestore.collection('users').doc(user.uid).set({
        'name': name, 'email': email, 'username': username,
        'bio': 'Lector de READ LIBROS', 'booksRead': 0, 'followers': 0, 'following': 0,
        'level': 1, 'streakDays': 0, 'avgRating': 0.0, 'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    User? user = _auth.currentUser;
    if (user != null) {
      if (data.containsKey('username')) {
        final existing = await _firestore.collection('users').where('username', isEqualTo: data['username']).get();
        if (existing.docs.isNotEmpty && existing.docs.first.id != user.uid) {
          throw Exception('El nombre de usuario ya está en uso');
        }
      }
      await _firestore.collection('users').doc(user.uid).update(data);
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final query = await _firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
    if (query.docs.isNotEmpty) {
      return {'id': query.docs.first.id, ...query.docs.first.data()};
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final snapshot = await _firestore.collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Stream<QuerySnapshot> getBooksForSale() => _firestore.collection('books').orderBy('createdAt', descending: true).snapshots();

  Future<void> sendMessage(String receiverId, String text) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String chatId = _getChatId(user.uid, receiverId);
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': user.uid, 'text': text, 'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String otherUserId) {
    User? user = _auth.currentUser;
    if (user != null) {
      String chatId = _getChatId(user.uid, otherUserId);
      return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('createdAt').snapshots();
    }
    return const Stream.empty();
  }

  String _getChatId(String uid1, String uid2) => uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
}
