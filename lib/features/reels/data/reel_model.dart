class ReelModel {
  final String id;
  final String username;
  final String userAvatar;
  final String quote;
  final String author;
  final String description;
  final String question;
  final String musicInfo;
  final String backgroundImage;
  final int likes;
  final int comments;
  final int shares;
  final bool isSaved;
  final bool isVerified;

  const ReelModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.quote,
    required this.author,
    required this.description,
    required this.question,
    required this.musicInfo,
    required this.backgroundImage,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isSaved = false,
    this.isVerified = false,
  });
}
