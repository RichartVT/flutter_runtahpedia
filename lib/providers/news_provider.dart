import 'package:flutter/foundation.dart';
import '../models/news.dart';

class NewsProvider with ChangeNotifier {
  final List<News> _savedNews = [];

  List<News> get savedNews => List.unmodifiable(_savedNews);

  bool isSaved(News news) {
    return _savedNews.any((n) => n.id == news.id);
  }

  void toggleSaved(News news) {
    final exists = isSaved(news);
    if (exists) {
      _savedNews.removeWhere((n) => n.id == news.id);
    } else {
      _savedNews.add(news);
    }
    notifyListeners();
  }

  void remove(News news) {
    _savedNews.removeWhere((n) => n.id == news.id);
    notifyListeners();
  }
}
