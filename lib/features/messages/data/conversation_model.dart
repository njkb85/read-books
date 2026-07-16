class ConversationModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final int avatarColor;

  const ConversationModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarColor = 0xFF444444,
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
