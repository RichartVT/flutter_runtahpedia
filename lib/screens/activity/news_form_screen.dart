import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/news_provider.dart';
import '../../models/news.dart';

class NewsFormScreen extends StatefulWidget {
  const NewsFormScreen({super.key});

  @override
  State<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String category = '';
  String author = '';
  String content = '';
  String imageUrl = 'assets/images/news/newsR.webp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publish News')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (v) => title = v ?? '',
                validator: (v) => v!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (v) => category = v ?? '',
                validator: (v) => v!.isEmpty ? 'Enter category' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                onSaved: (v) => author = v ?? '',
                validator: (v) => v!.isEmpty ? 'Enter author' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 4,
                onSaved: (v) => content = v ?? '',
                validator: (v) => v!.isEmpty ? 'Enter content' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.publish),
                label: const Text('Publish'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  final id = 'N-${Random().nextInt(999999)}';
                  final now = DateTime.now();

                  final news = News(
                    id: id,
                    title: title,
                    category: category,
                    author: author,
                    imageUrl: imageUrl,
                    content: content,
                    date: now,
                  );

                  await context.read<NewsProvider>().addNews(news);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
