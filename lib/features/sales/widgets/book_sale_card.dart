import 'package:flutter/material.dart';
import '../data/book_sale_model.dart';
import 'buy_button.dart';

class BookSaleCard extends StatefulWidget {
  final BookSaleModel book;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onBuyTap;

  const BookSaleCard({
    super.key,
    required this.book,
    this.onFavoriteTap,
    this.onMoreTap,
    this.onBuyTap,
  });

  @override
  State<BookSaleCard> createState() => _BookSaleCardState();
}

class _BookSaleCardState extends State<BookSaleCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.book.isFavorite;
  }

  String _formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portada del libro
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(widget.book.avatarColor ?? 0xFF2A2A4E),
                            Color(widget.book.avatarColor != null
                                ? (widget.book.avatarColor! & 0xFF000000) | 0x66000000
                                : 0xFF1A1A2E),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.book,
                          color: Colors.grey,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  // Badge
                  if (widget.book.badge != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: widget.book.badge == 'BESTSELLER'
                              ? const Color(0xFFC96A2B)
                              : const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.book.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Información del libro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.book.author,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          widget.book.formattedPrice,
                          style: const TextStyle(
                            color: Color(0xFFD7A15D),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.star,
                          color: Color(0xFFD7A15D),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatRating(widget.book.rating),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BuyButton(
                      onTap: widget.onBuyTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Botones derecha
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      widget.onFavoriteTap?.call();
                    },
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite
                          ? const Color(0xFFE53935)
                          : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: widget.onMoreTap,
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: Colors.grey[800],
            height: 1,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}

extension on BookSaleModel {
  int? get avatarColor {
    final colors = [
      0xFF2A2A4E, 0xFF4A2A2A, 0xFF2A4A2A,
      0xFF4A4A2A, 0xFF2A4A4A, 0xFF4A2A4A,
    ];
    final index = id.hashCode.abs() % colors.length;
    return colors[index];
  }
}
