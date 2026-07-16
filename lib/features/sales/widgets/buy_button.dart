import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  final VoidCallback? onTap;

  const BuyButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFC78B3A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Comprar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
