import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/auth_text_field.dart';
import '../../core/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _message;
  bool _sent = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _loading = true; _message = null; });
      try {
        await AuthService().resetPassword(_emailController.text.trim());
        setState(() {
          _sent = true;
          _message = 'Te hemos enviado un enlace para restablecer tu contrasena. Revisa tu email.';
        });
      } catch (e) {
        setState(() => _message = e.toString());
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock_outline, color: AppColors.accent, size: 64),
                const SizedBox(height: 24),
                const Text('Recuperar contrasena', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Ingresa tu email y te enviaremos un enlace para restablecer tu contrasena.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 32),
                AuthTextField(hint: 'Email', icon: Icons.email_outlined, controller: _emailController, validator: (v) => v!.isEmpty ? 'Ingresa tu email' : null),
                const SizedBox(height: 24),
                if (_message != null) ...[Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: _sent ? const Color(0xFF1B5E20).withValues(alpha: 0.3) : const Color(0xFFB71C1C).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
                  child: Text(_message!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                )],
                if (!_sent) GestureDetector(
                  onTap: _loading ? null : _resetPassword,
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
                    child: Center(child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black)) : const Text('Enviar enlace', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
