import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/news.dart';

class NewsDatabase {
  static final NewsDatabase instance = NewsDatabase._init();
  static Database? _database;

  NewsDatabase._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE news (
        id TEXT PRIMARY KEY,
        title TEXT,
        category TEXT,
        author TEXT,
        imageUrl TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertNews(News n) async {
    final db = await instance.database;
    return await db.insert('news', {
      'id': n.id,
      'title': n.title,
      'category': n.category,
      'author': n.author,
      'imageUrl': n.imageUrl,
      'content': n.content,
      'date': n.date.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<News>> getAllNews() async {
    final db = await instance.database;
    final result = await db.query('news', orderBy: 'date DESC');
    return result.map((m) {
      return News(
        id: m['id'] as String,
        title: m['title'] as String,
        category: m['category'] as String,
        author: m['author'] as String,
        imageUrl: m['imageUrl'] as String,
        content: m['content'] as String,
        date: DateTime.parse(m['date'] as String),
      );
    }).toList();
  }

  Future<int> deleteNews(String id) async {
    final db = await instance.database;
    return await db.delete('news', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('news');
  }
}
