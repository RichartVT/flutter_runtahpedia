import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../models/news.dart';
import '../news/news_detail_screen.dart';

class ActivityScreen extends StatelessWidget {
  static const route = '/activity';
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final saved = provider.savedNews;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved News')),
      body: saved.isEmpty
          ? const Center(
              child: Text(
                'No saved news yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: saved.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (_, i) {
                final it = saved[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(news: it),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(it.imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        it.category,
                        style: const TextStyle(color: Colors.grey),
                      ),
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
                          const CircleAvatar(
                            radius: 12,
                            child: Icon(Icons.bookmark),
                          ),
                          const SizedBox(width: 8),
                          Text(it.author),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.remove(it),
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
}

class _SavedNewsCard extends StatelessWidget {
  final News news;
  const _SavedNewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Imagen de la noticia
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.asset(
                news.imageUrl,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            // 📋 Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      news.author,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${news.date.day}/${news.date.month}/${news.date.year}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context.read<NewsProvider>().toggleSaved(news);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from saved news'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 100,
              color: Colors.grey.withOpacity(0.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'No saved news yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your saved articles will appear here.\nStart by bookmarking some news!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
