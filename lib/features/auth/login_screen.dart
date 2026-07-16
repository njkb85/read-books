import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'providers/auth_provider.dart';
import '../../shared/widgets/read_logo.dart';
import '../../core/constants/app_assets.dart';
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
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = userCredential.user;
        
        // FORZAR creación de perfil si no existe
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (!userDoc.exists) {
            // Crear perfil automáticamente
            String name = user.email!.split('@')[0];
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'name': name,
              'email': user.email,
              'username': '@$name',
              'bio': 'Lector de READ',
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
        
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        setState(() => _error = e.code == 'user-not-found' ? 'Usuario no encontrado' : e.code == 'wrong-password' ? 'Contrasena incorrecta' : e.message);
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 40),
              const ReadLogo(size: 100),
              const SizedBox(height: 20),
              const Text('READ', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 6)),
              const SizedBox(height: 8),
              const Text('Inicia sesion para continuar', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 40),
              AuthTextField(hint: 'Email', icon: Icons.email_outlined, controller: _emailController, validator: (v) => v!.isEmpty ? 'Ingresa tu email' : null),
              const SizedBox(height: 16),
              AuthTextField(hint: 'Contrasena', icon: Icons.lock_outlined, isPassword: true, controller: _passwordController, validator: (v) => v!.isEmpty ? 'Ingresa tu contrasena' : null),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())), child: const Text('Olvidaste tu contrasena?', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 13)))),
              if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))],
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _loading ? null : _login,
                child: Container(width: double.infinity, height: 52, decoration: BoxDecoration(color: const Color(0xFFD7A15D), borderRadius: BorderRadius.circular(16)), child: Center(child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black)) : const Text('Iniciar Sesion', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)))),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('No tienes cuenta? ', style: TextStyle(color: Colors.grey)), GestureDetector(onTap: () => Navigator.pushNamed(context, '/register'), child: const Text('Registrate', style: TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold)))]),
            ]),
          ),
        ),
      ),
    );
  }
}
