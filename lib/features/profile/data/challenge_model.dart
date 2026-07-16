class ChallengeModel {
  final String title;
  final double progress;

  const ChallengeModel({
    required this.title,
    required this.progress,
  });

  String get formattedProgress => '${(progress * 100).toInt()}%';
}
