import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/news.dart';
import '../../providers/news_provider.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  static const route = '/news';
  NewsScreen({super.key});

  // Lista de noticias
  final List<News> allNews = [
    News(
      id: 'n1',
      title: 'Sampah plastik: Reduce dan Reuse dahulu sebelum Recycle',
      category: 'Indonesia',
      author: 'Greenpeace',
      imageUrl: 'assets/images/news/news.jpg',

      content:
          'Plastic waste has become one of the world\'s largest environmental problems. '
          'This article discusses how reducing and reusing before recycling can minimize its impact on nature and marine life.',
      date: DateTime(2024, 7, 22),
    ),

    News(
      id: 'n2',
      title:
          'Why world leaders must step up to protect biodiversity at CBD COP15',
      category: 'International',
      author: 'Save RHYNO',
      imageUrl: 'assets/images/news/newsR.jpg',
      content:
          'At the CBD COP15, global leaders discussed policies to protect biodiversity and ecosystems. This article highlights key commitments and the urgent need for collective global action.',
      date: DateTime(2022, 10, 7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email ?? 'User';

    final provider = context.watch<NewsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, $name 👋')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: allNews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (_, i) {
          final it = allNews[i];
          final saved = provider.isSaved(it);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewsDetailScreen(news: it)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(it.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        onPressed: () async {
                          await context.read<NewsProvider>().toggleSaved(it);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.read<NewsProvider>().isSaved(it)
                                    ? 'Saved to favorites'
                                    : 'Removed from saved news',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: Icon(
                          provider.isSaved(it)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: provider.isSaved(it)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(it.category, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text(
                  it.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(radius: 12, child: Text('G')),
                    const SizedBox(width: 8),
                    Text(it.author),
                    const Spacer(),
                    Text(
                      '${it.date.day} ${_month(it.date.month)} ${it.date.year}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _month(int m) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];
}
