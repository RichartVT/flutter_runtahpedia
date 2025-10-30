import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._init();
  static Database? _database;

  ProductDatabase._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT,
        imageUrl TEXT,
        category TEXT,
        price REAL,
        unit TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertProduct(Product p) async {
    final db = await instance.database;
    return await db.insert('products', {
      'id': p.id,
      'name': p.name,
      'imageUrl': p.imageUrl,
      'category': p.category,
      'price': p.price,
      'unit': p.unit,
      'description': p.description,
    });
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((m) {
      return Product(
        id: m['id'] as String,
        name: m['name'] as String,
        imageUrl: m['imageUrl'] as String,
        category: m['category'] as String,
        price: m['price'] as double,
        unit: m['unit'] as String,
        description: m['description'] as String,
      );
    }).toList();
  }

  Future<int> deleteProduct(String id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('products');
  }
}
