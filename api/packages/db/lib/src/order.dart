import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

class OrderDatabase {
  factory OrderDatabase() => _instance;

  OrderDatabase._internal();
  static final OrderDatabase _instance = OrderDatabase._internal();

  static Database? _database;

  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  Database _initDatabase() {
    const path = 'database/grocify.db';
    final db = sqlite3.open(path)..execute('''
    CREATE TABLE IF NOT EXISTS orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id TEXT,
      order_id TEXT,
      amount REAL,
      is_paid BOOLEAN,
      items TEXT
    )
    ''');
    return db;
  }

  String createOrder(
      {required String userId, required double amount, required String items,}) {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    final orderId = const Uuid().v4();
    db.execute(
      '''
      INSERT INTO orders ( user_id, order_id, amount,is_paid, items) VALUES ( ?, ?, ?, ?, ?)
      ''',
      [userId, orderId, amount, items, true],
    );
    return orderId;
  }

  List<Map<String, dynamic>> queryDataByUserId({required String userId}) {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    final rows = db.select(
      '''
      SELECT * FROM orders
      WHERE user_id = ?
    ''',
      [userId],
    );
    return rows;
  }

  List<Map<String, dynamic>> queryDataByOrderId({required String orderId}) {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM orders
      WHERE order_id = ?
    ''', [orderId],);
    return rows;
  }

  bool checkPaymentSuccessful() {
    return true;
  }

  Future<void> deleteOrder({required String orderId, required String userId}) async {
    final dbHelper = OrderDatabase();
    dbHelper.database.execute(
      '''
    DELETE FROM order_id WHERE order_id = ? AND user_id = ?
    ''',
      [orderId, userId],
    );
  }

  void closeDatabase() {
    final dbHelper = OrderDatabase();
    dbHelper.database.dispose();
  }
}
