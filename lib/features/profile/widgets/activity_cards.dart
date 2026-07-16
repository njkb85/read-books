import 'package:flutter/material.dart';
import '../data/user_model.dart';

class ActivityCards extends StatelessWidget {
  final UserModel user;

  const ActivityCards({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildActivityCard(
              icon: '📖',
              value: '${user.booksRead}',
              label: 'libros leídos',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildActivityCard(
              icon: '🔥',
              value: '${user.streakDays}',
              label: 'racha de días',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildActivityCard(
              icon: '⭐',
              value: '${user.avgRating}',
              label: 'valoración media',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
