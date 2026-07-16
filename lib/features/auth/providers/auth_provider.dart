import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  Map<String, dynamic>? _userProfile;
  bool _loading = false;

  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      if (user != null) {
        _loadUserProfile();
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile() async {
    _userProfile = await _firestoreService.getUserProfile();
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmail(email, password);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> register(String name, String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      User? user = await _authService.registerWithEmail(email, password);
      if (user != null) {
        await _firestoreService.saveUserProfile(name, email);
        await _loadUserProfile();
      }
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _firestoreService.updateUserProfile(data);
    await _loadUserProfile();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _userProfile = null;
    notifyListeners();
  }
}
