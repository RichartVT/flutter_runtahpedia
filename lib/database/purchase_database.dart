import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/purchase.dart';

class PurchaseDatabase {
  static final PurchaseDatabase instance = PurchaseDatabase._init();
  static Database? _database;

  PurchaseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('purchases.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        total REAL,
        quantity INTEGER,
        items TEXT
      )
    ''');
  }

  Future<int> insertPurchase(Purchase purchase) async {
    final db = await instance.database;
    return await db.insert('purchases', purchase.toMap());
  }

  Future<List<Purchase>> getAllPurchases() async {
    final db = await instance.database;
    final result = await db.query('purchases', orderBy: 'id DESC');
    return result.map((e) => Purchase.fromMap(e)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
