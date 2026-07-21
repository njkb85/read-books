import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/read_logo.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/auth_text_field.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _loading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _loading = true; _error = null; });
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
        final user = userCredential.user;
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (!userDoc.exists) {
            String name = user.email!.split('@')[0];
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'name': name, 'email': user.email, 'username': '@$name', 'bio': 'Lector de READ', 'booksRead': 0, 'followers': 0, 'following': 0, 'level': 1, 'createdAt': FieldValue.serverTimestamp()});
          }
        }
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        setState(() => _error = e.code == 'user-not-found' ? 'Usuario no encontrado' : e.code == 'wrong-password' ? 'Contrasena incorrecta' : e.message);
      }
      setState(() => _loading = false);
    }
  }

  Future<void> _enterAsGuest() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.pushReplacementNamed(context, '/guest');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(key: _formKey, child: Column(children: [
            const SizedBox(height: 40),
            const ReadLogo(size: 100),
            const SizedBox(height: 20),
            Text(t.translate('app_name'), style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 6)),
            const SizedBox(height: 8),
            Text(t.translate('login'), style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 40),
            AuthTextField(hint: t.translate('email'), icon: Icons.email_outlined, controller: _emailController, validator: (v) => v!.isEmpty ? 'Ingresa tu email' : null),
            const SizedBox(height: 16),
            AuthTextField(hint: t.translate('password'), icon: Icons.lock_outlined, isPassword: true, controller: _passwordController, validator: (v) => v!.isEmpty ? 'Ingresa tu contrasena' : null),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())), child: Text(t.translate('forgot_password'), style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 13)))),
            if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))],
            const SizedBox(height: 24),
            GestureDetector(onTap: _loading ? null : _login, child: Container(width: double.infinity, height: 52, decoration: BoxDecoration(color: const Color(0xFFD7A15D), borderRadius: BorderRadius.circular(16)), child: Center(child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black)) : Text(t.translate('login'), style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${t.translate('no_account')} ', style: const TextStyle(color: Colors.grey)),
              GestureDetector(onTap: () => Navigator.pushNamed(context, '/register'), child: Text(t.translate('register'), style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 24),
            const Text('— o —', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            GestureDetector(onTap: _enterAsGuest, child: Container(width: double.infinity, height: 52, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(16)), child: Center(child: Text(t.translate('guest'), style: const TextStyle(color: Colors.grey, fontSize: 16))))),
          ])),
        ),
      ),
    );
  }
}
