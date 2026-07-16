import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/sales_header.dart';
import 'widgets/distance_chips.dart';
import 'widgets/sale_card.dart';
import 'create_sale_screen.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(children: [
          const SalesHeader(),
          const SizedBox(height: 8),
          // Botón publicar venta
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateSaleScreen())),
            child: Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFD7A15D), borderRadius: BorderRadius.circular(16)), child: const Center(child: Text('+ Publicar venta', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)))),
          ),
          const SizedBox(height: 8),
          const DistanceChips(),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('sales').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFD7A15D)));
                final sales = snapshot.data!.docs;
                if (sales.isEmpty) return const Center(child: Text('No hay ventas. Publica la primera!', style: TextStyle(color: Colors.grey)));
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: sales.length,
                  itemBuilder: (context, i) {
                    final s = sales[i].data() as Map<String, dynamic>;
                    return SaleCard(
                      item: SaleItemReal(id: sales[i].id, title: s['title'] ?? '', price: (s['price'] ?? 0).toDouble(), sellerInitial: (s['sellerName'] ?? 'U').toString()[0].toUpperCase(), distanceKm: 1),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class SaleItemReal {
  final String id, title, sellerInitial;
  final double price, distanceKm;
  final bool isSaved;
  const SaleItemReal({required this.id, required this.title, required this.price, this.sellerInitial = 'U', this.distanceKm = 1, this.isSaved = false});
  String get formattedPrice => '${price.toStringAsFixed(0)} EUR';
  String get formattedDistance => '${distanceKm.toStringAsFixed(0)} km';
}
