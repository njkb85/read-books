import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Inicio', index: 0),
          _buildNavItem(icon: Icons.video_library_outlined, activeIcon: Icons.video_library, label: 'Reels', index: 1),
          _buildNavItem(icon: Icons.store_outlined, activeIcon: Icons.store, label: 'Ventas', index: 2),
          _buildNavItem(icon: Icons.message_outlined, activeIcon: Icons.message, label: 'Mensajes', index: 3),
          _buildNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil', index: 4),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = widget.currentIndex == index;
    return GestureDetector(
      onTap: () => widget.onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.navActive : AppColors.navInactive,
              size: 24,
            ),
            const SizedBox(height: 2),
            if (isActive)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            if (!isActive)
              Text(
                label,
                style: TextStyle(
                  color: AppColors.navInactive,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
