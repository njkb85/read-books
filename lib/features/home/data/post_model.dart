class PostModel {
  final String id;
  final String username;
  final String handle;
  final String userInitial;
  final String text;
  final String imageAsset;
  final int likes;
  final int comments;
  final int reposts;
  final String timeAgo;
  final bool isVerified;
  final bool isLiked;
  final bool isSaved;

  const PostModel({
    required this.id,
    required this.username,
    required this.handle,
    required this.userInitial,
    required this.text,
    required this.imageAsset,
    this.likes = 0,
    this.comments = 0,
    this.reposts = 0,
    this.timeAgo = '',
    this.isVerified = false,
    this.isLiked = false,
    this.isSaved = false,
  });

  String get formattedLikes => likes >= 1000 ? '${(likes / 1000).toStringAsFixed(1)}K' : likes.toString();
  String get formattedComments => comments >= 1000 ? '${(comments / 1000).toStringAsFixed(1)}K' : comments.toString();
  String get formattedReposts => reposts >= 1000 ? '${(reposts / 1000).toStringAsFixed(1)}K' : reposts.toString();
}
