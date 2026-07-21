class FreeBook {
  final String title;
  final String author;
  final String coverUrl;
  final String language;
  final String category;
  final String downloadUrl;
  final String description;

  const FreeBook({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.language,
    required this.category,
    required this.downloadUrl,
    required this.description,
  });
}

// Libros gratuitos reales de Project Gutenberg y Open Library
const List<FreeBook> freeBooks = [
  // Español
  FreeBook(title: 'Don Quijote de la Mancha', author: 'Miguel de Cervantes', coverUrl: 'https://www.gutenberg.org/cache/epub/2000/pg2000.cover.medium.jpg', language: 'ES', category: 'Clasico', downloadUrl: 'https://www.gutenberg.org/ebooks/2000', description: 'La obra mas importante de la literatura espanola.'),
  FreeBook(title: 'Platero y yo', author: 'Juan Ramon Jimenez', coverUrl: 'https://www.gutenberg.org/cache/epub/17405/pg17405.cover.medium.jpg', language: 'ES', category: 'Poesia', downloadUrl: 'https://www.gutenberg.org/ebooks/17405', description: 'Elegia andaluza del poeta Nobel.'),
  FreeBook(title: 'La Celestina', author: 'Fernando de Rojas', coverUrl: 'https://www.gutenberg.org/cache/epub/1619/pg1619.cover.medium.jpg', language: 'ES', category: 'Teatro', downloadUrl: 'https://www.gutenberg.org/ebooks/1619', description: 'Tragicomedia de Calisto y Melibea.'),
  FreeBook(title: 'Leyendas', author: 'Gustavo Adolfo Becquer', coverUrl: 'https://www.gutenberg.org/cache/epub/932/pg932.cover.medium.jpg', language: 'ES', category: 'Relatos', downloadUrl: 'https://www.gutenberg.org/ebooks/932', description: 'Las mejores leyendas del romanticismo espanol.'),
  
  // English
  FreeBook(title: 'Pride and Prejudice', author: 'Jane Austen', coverUrl: 'https://www.gutenberg.org/cache/epub/1342/pg1342.cover.medium.jpg', language: 'EN', category: 'Romance', downloadUrl: 'https://www.gutenberg.org/ebooks/1342', description: 'A classic tale of love and misunderstanding.'),
  FreeBook(title: 'Frankenstein', author: 'Mary Shelley', coverUrl: 'https://www.gutenberg.org/cache/epub/84/pg84.cover.medium.jpg', language: 'EN', category: 'Horror', downloadUrl: 'https://www.gutenberg.org/ebooks/84', description: 'The original science fiction horror story.'),
  FreeBook(title: 'Dracula', author: 'Bram Stoker', coverUrl: 'https://www.gutenberg.org/cache/epub/345/pg345.cover.medium.jpg', language: 'EN', category: 'Horror', downloadUrl: 'https://www.gutenberg.org/ebooks/345', description: 'The legendary vampire tale.'),
  FreeBook(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', coverUrl: 'https://www.gutenberg.org/cache/epub/64317/pg64317.cover.medium.jpg', language: 'EN', category: 'Ficcion', downloadUrl: 'https://www.gutenberg.org/ebooks/64317', description: 'The American classic of the Jazz Age.'),
  
  // Português
  FreeBook(title: 'Dom Casmurro', author: 'Machado de Assis', coverUrl: 'https://www.gutenberg.org/cache/epub/55752/pg55752.cover.medium.jpg', language: 'PT', category: 'Romance', downloadUrl: 'https://www.gutenberg.org/ebooks/55752', description: 'O classico brasileiro do seculo XIX.'),
  FreeBook(title: 'Os Lusíadas', author: 'Luis de Camoes', coverUrl: 'https://www.gutenberg.org/cache/epub/3333/pg3333.cover.medium.jpg', language: 'PT', category: 'Poesia', downloadUrl: 'https://www.gutenberg.org/ebooks/3333', description: 'A epopeia portuguesa.'),
  
  // Français
  FreeBook(title: 'Les Miserables', author: 'Victor Hugo', coverUrl: 'https://www.gutenberg.org/cache/epub/135/pg135.cover.medium.jpg', language: 'FR', category: 'Ficcion', downloadUrl: 'https://www.gutenberg.org/ebooks/135', description: 'Le chef-d\'œuvre de Victor Hugo.'),
  FreeBook(title: 'Le Comte de Monte-Cristo', author: 'Alexandre Dumas', coverUrl: 'https://www.gutenberg.org/cache/epub/1184/pg1184.cover.medium.jpg', language: 'FR', category: 'Aventura', downloadUrl: 'https://www.gutenberg.org/ebooks/1184', description: 'La vengeance du comte de Monte-Cristo.'),
];
