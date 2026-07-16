class BookSaleModel {
  final String id;
  final String title;
  final String author;
  final double price;
  final double rating;
  final String coverImage;
  final String? badge;
  final bool isFavorite;

  const BookSaleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.coverImage,
    this.badge,
    this.isFavorite = false,
  });

  String get formattedPrice => '${price.toStringAsFixed(2).replaceAll('.', ',')} €';
}
