import 'package:flutter/foundation.dart';
import '../database/news_database.dart';
import '../models/news.dart';

class NewsProvider extends ChangeNotifier {
  final List<News> _savedNews = [];

  List<News> get savedNews => List.unmodifiable(_savedNews);

  /// Cargar las noticias desde SQLite
  Future<void> loadNews() async {
    final all = await NewsDatabase.instance.getAllNews();
    debugPrint('🗂 Loaded ${all.length} news from DB');

    _savedNews
      ..clear()
      ..addAll(all);
    notifyListeners();
  }

  /// Verificar si una noticia está guardada
  bool isSaved(News news) {
    return _savedNews.contains(news);
  }

  /// Agregar noticia manualmente (usado en Activity)
  Future<void> addNews(News news) async {
    await NewsDatabase.instance.insertNews(news);
    _savedNews.add(news);
    debugPrint('✅ Added news: ${news.title}');
    notifyListeners();
  }

  /// Eliminar noticia por ID
  Future<void> deleteNews(String id) async {
    await NewsDatabase.instance.deleteNews(id);
    _savedNews.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  /// Alternar entre guardar / eliminar
  Future<void> toggleSaved(News news) async {
    if (isSaved(news)) {
      await deleteNews(news.id);
    } else {
      await addNews(news);
    }
  }

  /// Borrar todas las noticias
  Future<void> clearAll() async {
    await NewsDatabase.instance.clearAll();
    _savedNews.clear();
    notifyListeners();
  }
}
