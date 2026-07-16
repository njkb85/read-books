import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import '../../shared/widgets/read_logo.dart';
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthProvider>();
      String? error = await auth.login(_emailController.text.trim(), _passwordController.text.trim());
      if (error != null) {
        setState(() => _error = error);
      } else if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const ReadLogo(size: 100),
                const SizedBox(height: 20),
                const Text('READ', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 6)),
                const SizedBox(height: 8),
                const Text('Inicia sesion para continuar', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 40),
                AuthTextField(hint: 'Email', icon: Icons.email_outlined, controller: _emailController, validator: (v) => v!.isEmpty ? 'Ingresa tu email' : null),
                const SizedBox(height: 16),
                AuthTextField(hint: 'Contrasena', icon: Icons.lock_outlined, isPassword: true, controller: _passwordController, validator: (v) => v!.isEmpty ? 'Ingresa tu contrasena' : null),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: const Text('Olvidaste tu contrasena?', style: TextStyle(color: Color(0xFFD7A15D), fontSize: 13)),
                  ),
                ),
                if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))],
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: auth.loading ? null : _login,
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(color: const Color(0xFFD7A15D), borderRadius: BorderRadius.circular(16)),
                    child: Center(child: auth.loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black)) : const Text('Iniciar Sesion', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                  ),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('No tienes cuenta? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(onTap: () => Navigator.pushNamed(context, '/register'), child: const Text('Registrate', style: TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold))),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
