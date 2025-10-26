import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/purchase.dart';

class PurchaseDatabase {
  static final PurchaseDatabase instance = PurchaseDatabase._init();
  static Database? _database;

  PurchaseDatabase._init();

  Future<Database> get database async {
    // Reabrir si está nulo o cerrado
    if (_database != null) {
      try {
        // sqflite expone isOpen
        if (_database!.isOpen) return _database!;
      } catch (_) {
        /* por si versiones antiguas */
      }
    }
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

  // Borra una compra por id
  Future<int> deletePurchase(int id) async {
    final db = await database;
    return db.delete('purchases', where: 'id = ?', whereArgs: [id]);
  }

  // Borra todas las compras (limpiar historial)
  Future<void> clearAll() async {
    final db = await database; // asegura abierta
    await db.delete('purchases');
  }

  // Opcional: reset total
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'purchases.db');
    await close();
    await deleteDatabase(path);
    _database = null; // fuerza reapertura
    await database; // recrea con _createDB
  }

  // Evita llamar close() salvo que salgas de la app
  Future close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
    _database = null;
  }
}
