import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Idioma', style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: LocaleProvider.languages.map((lang) {
          final locale = Locale(lang['code']);
          final isActive = context.watch<LocaleProvider>().locale == locale;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(14),
              border: isActive ? Border.all(color: const Color(0xFFD7A15D), width: 2) : null,
            ),
            child: ListTile(
              leading: Text(lang['flag'], style: const TextStyle(fontSize: 28)),
              title: Text(lang['name'], style: const TextStyle(color: Colors.white, fontSize: 16)),
              trailing: isActive ? const Icon(Icons.check_circle, color: Color(0xFFD7A15D), size: 24) : const Icon(Icons.circle_outlined, color: Colors.grey, size: 24),
              onTap: () {
                context.read<LocaleProvider>().setLocale(locale);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Idioma cambiado a ${lang['name']}'), backgroundColor: const Color(0xFF4CAF50)));
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
