import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserProfile(String name, String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'username': '@${name.toLowerCase().replaceAll(' ', '')}',
        'bio': 'Lector de READ LIBROS',
        'booksRead': 0,
        'followers': 0,
        'following': 0,
        'level': 1,
        'streakDays': 0,
        'avgRating': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    User? user = _auth.currentUser;
    if (user != null) {
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

  Future<List<Map<String, dynamic>>> getUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }

  Future<void> addBookForSale({
    required String title,
    required String author,
    required double price,
    required String description,
  }) async {
    await _firestore.collection('books').add({
      'title': title,
      'author': author,
      'price': price,
      'description': description,
      'rating': 0.0,
      'reviews': 0,
      'sellerId': _auth.currentUser?.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getBooksForSale() {
    return _firestore.collection('books').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> sendMessage(String receiverId, String text) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String chatId = _getChatId(user.uid, receiverId);
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': user.uid,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
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

  String _getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }
}
