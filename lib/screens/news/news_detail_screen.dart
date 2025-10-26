import 'package:flutter/material.dart';
import '../../models/news.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(news.imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(news.category, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            news.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 14, child: Text('G')),
              const SizedBox(width: 8),
              Text(
                news.author,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${news.date.day}/${news.date.month}/${news.date.year}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(news.content, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
