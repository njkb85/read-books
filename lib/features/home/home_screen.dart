import 'package:flutter/material.dart';
import 'data/post_data.dart';
import 'widgets/home_header.dart';
import 'widgets/category_chips.dart';
import 'widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(),
            const SizedBox(height: 4),
            const CategoryChips(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: samplePosts.length,
                itemBuilder: (context, index) => PostCard(post: samplePosts[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
