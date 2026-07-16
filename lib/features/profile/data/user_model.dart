class UserModel {
  final String name;
  final String username;
  final String bio;
  final String avatarUrl;
  final int booksRead;
  final int followers;
  final int following;
  final int level;
  final double progress;
  final int booksToNextLevel;
  final int streakDays;
  final double avgRating;

  const UserModel({
    required this.name,
    required this.username,
    required this.bio,
    this.avatarUrl = '',
    this.booksRead = 0,
    this.followers = 0,
    this.following = 0,
    this.level = 1,
    this.progress = 0.0,
    this.booksToNextLevel = 0,
    this.streakDays = 0,
    this.avgRating = 0.0,
  });

  String get formattedFollowers {
    if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    }
    return followers.toString();
  }

  String get formattedProgress => '${(progress * 100).toInt()}%';
}
