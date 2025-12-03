import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/news.dart';
import '../../providers/news_provider.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  static const route = '/news';
  NewsScreen({super.key});

  static const Color _primaryGreen = Color(0xFF48C178);
  static const Color _lightBackground = Color(0xFFF5F6FA);

  ImageProvider<Object> getNewsImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/images/news/newsR.jpg');
    } else if (path.startsWith('http')) {
      return NetworkImage(path);
    } else if (path.startsWith('/')) {
      return FileImage(File(path));
    } else {
      return AssetImage(path);
    }
  }

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
    // lo sigo obteniendo por si lo necesitas después,
    // pero ya no lo usamos para el título
    final provider = context.watch<NewsProvider>();

    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          'News',
          style: TextStyle(
            color: _primaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: allNews.length + 1, // 1 para el header "Trending"
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Text(
                'Trending',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            );
          }

          final it = allNews[index - 1];

          return _NewsCard(
            news: it,
            imageProvider: getNewsImage(it.imageUrl),
            isSaved: provider.isSaved(it),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewsDetailScreen(news: it)),
              );
            },
            onToggleSaved: () async {
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
            formattedDate:
                '${it.date.day} ${_month(it.date.month)} ${it.date.year}',
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

class _NewsCard extends StatelessWidget {
  final News news;
  final ImageProvider<Object> imageProvider;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;
  final String formattedDate;

  const _NewsCard({
    required this.news,
    required this.imageProvider,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSaved,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen grande
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  child: Image(
                    image: imageProvider,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.orange : Colors.black54,
                        size: 20,
                      ),
                      onPressed: onToggleSaved,
                    ),
                  ),
                ),
                // Tres puntos (solo decorativo)
                Positioned(
                  right: 60,
                  top: 18,
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            // Contenido textual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.category,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFFE6F4EA),
                        child: Text(
                          news.author.isNotEmpty
                              ? news.author[0].toUpperCase()
                              : 'G',
                          style: const TextStyle(
                            color: Color(0xFF48C178),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          news.author,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
