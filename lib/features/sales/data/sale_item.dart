class SaleItem {
  final String id;
  final String title;
  final double price;
  final String imageAsset;
  final double distanceKm;
  final String sellerInitial;
  final String category;
  final bool isSaved;

  const SaleItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageAsset,
    this.distanceKm = 1.0,
    this.sellerInitial = 'U',
    this.category = 'Libros',
    this.isSaved = false,
  });

  String get formattedPrice => '${price.toStringAsFixed(0)} €';
  String get formattedDistance => '${distanceKm.toStringAsFixed(0)} km';
}
