import 'package:flutter/material.dart';
import 'data/sale_data.dart';
import 'widgets/sales_header.dart';
import 'widgets/sales_search_bar.dart';
import 'widgets/sales_category_tabs.dart';
import 'widgets/distance_chips.dart';
import 'widgets/sale_card.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            const SalesHeader(),
            const SizedBox(height: 8),
            const SalesSearchBar(),
            const SizedBox(height: 16),
            const SalesCategoryTabs(),
            const SizedBox(height: 12),
            const DistanceChips(),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: sampleItems.length,
                itemBuilder: (context, index) {
                  return SaleCard(item: sampleItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
