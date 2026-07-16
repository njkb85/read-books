import 'package:flutter/material.dart';
import 'data/reel_data.dart';
import 'widgets/reel_top_bar.dart';
import 'widgets/reel_category_tabs.dart';
import 'widgets/reel_card.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Stack(
          children: [
            // Reels con scroll vertical
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: sampleReels.length,
              itemBuilder: (context, index) {
                return ReelCard(
                  reel: sampleReels[index],
                  isActive: true,
                );
              },
            ),

            // Barra superior
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ReelTopBar(),
            ),

            // Selector de categorías
            const Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: ReelCategoryTabs(),
            ),
          ],
        ),
      ),
    );
  }
}
