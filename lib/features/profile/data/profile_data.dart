import 'user_model.dart';
import 'achievement_model.dart';
import 'challenge_model.dart';

const UserModel sampleUser = UserModel(
  name: 'Michael',
  username: '@tutunsahurr',
  bio: 'Lector, escritor y amante del conocimiento.',
  booksRead: 148,
  followers: 3200,
  following: 640,
  level: 18,
  progress: 0.78,
  booksToNextLevel: 3,
  streakDays: 27,
  avgRating: 4.9,
);

const List<AchievementModel> sampleAchievements = [
  AchievementModel(icon: '📚', title: 'Primer libro'),
  AchievementModel(icon: '♟️', title: 'Primer jaque\nmate'),
  AchievementModel(icon: '✍️', title: 'Primer\ncapítulo'),
  AchievementModel(icon: '🔥', title: '30 días\nleyendo'),
  AchievementModel(icon: '🧠', title: '100 horas\naprendiendo'),
  AchievementModel(icon: '⭐', title: '50\nreseñas'),
  AchievementModel(icon: '📖', title: '100 libros\nleídos'),
  AchievementModel(icon: '🏆', title: 'Reto\ncompletado'),
];

const List<ChallengeModel> sampleChallenges = [
  ChallengeModel(title: 'Leer 30 minutos', progress: 0.7),
  ChallengeModel(title: 'Terminar una novela', progress: 0.45),
  ChallengeModel(title: 'Escribir 500 palabras', progress: 0.6),
  ChallengeModel(title: 'Resolver un problema de ajedrez', progress: 1.0),
];

const List<String> libraryBooks = [
  'portada1', 'portada2', 'portada3', 'portada4',
  'portada5', 'portada6', 'portada7', 'portada8',
];
