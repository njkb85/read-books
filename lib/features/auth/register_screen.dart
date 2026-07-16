import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final auth = context.read<AuthProvider>();
      String? error = await auth.register(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim());
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text('Crear Cuenta', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Únete a la comunidad de lectores', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 32),
                AuthTextField(hint: 'Nombre', icon: Icons.person_outline, controller: _nameController, validator: (v) => v!.isEmpty ? 'Ingresa tu nombre' : null),
                const SizedBox(height: 16),
                AuthTextField(hint: 'Email', icon: Icons.email_outlined, controller: _emailController, validator: (v) => v!.isEmpty ? 'Ingresa tu email' : null),
                const SizedBox(height: 16),
                AuthTextField(hint: 'Contraseña', icon: Icons.lock_outlined, isPassword: true, controller: _passwordController, validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null),
                if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))],
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: auth.loading ? null : _register,
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
                    child: Center(child: auth.loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black)) : const Text('Registrarse', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                  ),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('¿Ya tienes cuenta? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Inicia sesión', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold))),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
