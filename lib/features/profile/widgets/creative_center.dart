import 'package:flutter/material.dart';
import 'writing_card.dart';
import 'chess_card.dart';
import 'ai_writer_card.dart';
import 'challenges_card.dart';
import 'achievements_grid.dart';

class CreativeCenter extends StatelessWidget {
  const CreativeCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Centro Creativo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Aprende, escribe y desafía tu mente.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const WritingCard(),
          const SizedBox(height: 12),
          const ChessCard(),
          const SizedBox(height: 12),
          const AiWriterCard(),
          const SizedBox(height: 12),
          const ChallengesCard(),
          const SizedBox(height: 12),
          const AchievementsGrid(),
        ],
      ),
    );
  }
}
