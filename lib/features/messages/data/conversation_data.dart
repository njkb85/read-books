import 'conversation_model.dart';

const List<ConversationModel> sampleConversations = [
  ConversationModel(
    id: '1',
    name: 'Lucía Martínez',
    lastMessage: '¿Qué te pareció el final de "Mentira"? 😊',
    time: '10:32',
    unreadCount: 2,
    avatarColor: 0xFF7B61FF,
  ),
  ConversationModel(
    id: '2',
    name: 'María López',
    lastMessage: 'Te acabo de enviar el link del club de lectura.',
    time: 'Ayer',
    unreadCount: 1,
    avatarColor: 0xFFC96A2B,
  ),
  ConversationModel(
    id: '3',
    name: 'Carlos García',
    lastMessage: 'Perfecto, la reunión será el sábado a las 18:00.',
    time: 'Ayer',
    unreadCount: 0,
    avatarColor: 0xFF4CAF50,
  ),
  ConversationModel(
    id: '4',
    name: 'Ana Fernández',
    lastMessage: 'Muchas gracias por la recomendación.',
    time: 'Lun',
    unreadCount: 0,
    avatarColor: 0xFF2196F3,
  ),
  ConversationModel(
    id: '5',
    name: 'Club de Lectura',
    lastMessage: 'Pedro: ¿Qué libro tocaba este mes? 📖',
    time: 'Dom',
    unreadCount: 5,
    avatarColor: 0xFF9C27B0,
  ),
];
