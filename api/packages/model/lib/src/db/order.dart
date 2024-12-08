import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

class OrderDatabase {
  static final OrderDatabase _instance = OrderDatabase._internal();
  factory OrderDatabase() => _instance;

  static Database? _database;

  OrderDatabase._internal();

  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  Database _initDatabase() {
    const path = './database/app_database.db';
    Database db = sqlite3.open(path);
    db.execute('''
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
      {required String userId, required double amount, required String items}) {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    String orderId = const Uuid().v4();
    db.execute('''
      INSERT INTO orders ( user_id, order_id, amount,is_paid, items) VALUES ( ?, ?, ?, ?, ?)
      ''', [userId, orderId, amount, items, true]);
    return orderId;
  }

  List<Map<String, dynamic>> queryDataByUserId({required String userId}) {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM orders
      WHERE user_id = ?
    ''', [userId]);
    return rows;
  }

  List<Map<String, dynamic>> queryDataByOrderId({required String orderId}) {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM orders
      WHERE order_id = ?
    ''', [orderId]);
    return rows;
  }

  bool checkPaymentSuccessful() {
    return true;
  }

  void deleteOrder({required String orderId, required String userId}) async {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    db.execute('''
    DELETE FROM order_id WHERE order_id = ? AND user_id = ?
    ''', [orderId, userId]);
  }

  void closeDatabase() {
    final dbHelper = OrderDatabase();
    final db = dbHelper.database;
    db.dispose();
  }
}
