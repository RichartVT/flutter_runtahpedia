import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/purchase.dart';

class PurchaseDatabase {
  static final PurchaseDatabase instance = PurchaseDatabase._init();
  static Database? _database;

  PurchaseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('runtahpedia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // increment if schema changes
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE purchases (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      total REAL NOT NULL,
      quantity INTEGER NOT NULL,
      items TEXT NOT NULL,
      pickupDate TEXT
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE purchases ADD COLUMN pickupDate TEXT');
    }
  }

  Future<void> insertPurchase(Purchase purchase) async {
    final db = await instance.database;
    await db.insert('purchases', purchase.toMap());
  }

  Future<List<Purchase>> getAllPurchases() async {
    final db = await instance.database;
    final result = await db.query('purchases', orderBy: 'date DESC');
    return result.map((json) => Purchase.fromMap(json)).toList();
  }

  Future<void> deletePurchase(int id) async {
    final db = await instance.database;
    await db.delete('purchases', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('purchases');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> resetDatabase() async {
    final db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS purchases');
    await _createDB(db, 2);
  }
}
