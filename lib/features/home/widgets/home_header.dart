import 'package:flutter/material.dart';
import '../../../shared/widgets/read_logo.dart';
import '../../settings/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  const HomeHeader({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(onTap: onSearchTap, child: const Icon(Icons.search, color: Colors.white, size: 26)),
          const ReadLogo(size: 38),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }
}
