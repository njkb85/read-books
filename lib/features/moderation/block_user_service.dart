import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlockUserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> blockUser(String userId) async {
    final me = _auth.currentUser!;
    await _db.collection('users').doc(me.uid).collection('blocked').doc(userId).set({'blockedAt': FieldValue.serverTimestamp()});
  }

  Future<void> unblockUser(String userId) async {
    final me = _auth.currentUser!;
    await _db.collection('users').doc(me.uid).collection('blocked').doc(userId).delete();
  }

  Future<bool> isBlocked(String userId) async {
    final me = _auth.currentUser!;
    final doc = await _db.collection('users').doc(me.uid).collection('blocked').doc(userId).get();
    return doc.exists;
  }

  Future<List<String>> getBlockedUsers() async {
    final me = _auth.currentUser!;
    final snap = await _db.collection('users').doc(me.uid).collection('blocked').get();
    return snap.docs.map((d) => d.id).toList();
  }
}
