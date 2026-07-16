import 'package:flutter/material.dart';

class ReelUserInfo extends StatelessWidget {
  final String username;
  final bool isVerified;
  final String description;
  final String question;
  final String musicInfo;

  const ReelUserInfo({
    super.key,
    required this.username,
    required this.isVerified,
    required this.description,
    required this.question,
    required this.musicInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Usuario
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC96A2B), Color(0xFFE0884A)],
                ),
              ),
              child: Center(
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Nombre
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            // Badge verificación
            if (isVerified) ...[
              const SizedBox(width: 4),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFC96A2B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 9,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Descripción
        Text(
          description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        // Pregunta
        Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Música
        Row(
          children: [
            const Icon(
              Icons.music_note,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                musicInfo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
