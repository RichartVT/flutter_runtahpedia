import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../models/news.dart';
import 'news_form_screen.dart';
import '../news/news_detail_screen.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  static const route = '/activity'; // ✅ agregado

  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NewsProvider>().loadNews());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final newsList = provider.savedNews; // ✅ cambiado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear all news'),
                  content: const Text(
                    'This will delete all saved news. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (confirm == true) provider.clearAll();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: newsList.isEmpty
          ? const Center(child: Text('No news yet'))
          : ListView.builder(
              itemCount: newsList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, i) {
                final n = newsList[i];
                return Dismissible(
                  key: ValueKey(n.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => provider.deleteNews(n.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Image.asset(
                        n.imageUrl,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        n.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${n.category} • ${DateFormat('d MMM yyyy').format(n.date)}',
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailScreen(news: n),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
