import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'Usuario no encontrado';
      case 'wrong-password': return 'Contraseña incorrecta';
      case 'email-already-in-use': return 'El email ya está registrado';
      case 'weak-password': return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-email': return 'Email inválido';
      default: return 'Error: ${e.message}';
    }
  }
}
