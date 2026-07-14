import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/home_header.dart';
import '../widgets/category_tabs.dart';
import '../widgets/section_header.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Book> books = const [
    Book(
      rank: 1,
      title: 'Harry Potter y la piedra filosofal',
      author: 'J. K. Rowling',
      rating: 4.9,
    ),
    Book(
      rank: 2,
      title: 'Comer para vivir',
      author: 'Michelle Ruiz',
      rating: 4.8,
    ),
    Book(
      rank: 3,
      title: 'Inteligencia Artificial',
      author: 'Andrew Ng',
      rating: 4.7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: 16),

              const CategoryTabs(),

              const SectionHeader(
                title: 'Los más leídos ahora',
              ),

              ...books.map(
                (book) => BookCard(
                  rank: book.rank,
                  title: book.title,
                  author: book.author,
                  rating: book.rating,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
    