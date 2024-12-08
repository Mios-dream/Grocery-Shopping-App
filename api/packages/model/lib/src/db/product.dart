import 'package:sqlite3/sqlite3.dart';

class ProductDatabase {
  static final ProductDatabase _instance = ProductDatabase._internal();
  factory ProductDatabase() => _instance;

  static Database? _database;

  ProductDatabase._internal();

  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  Database _initDatabase() {
    const path = './db/grocify.db';
    Database db = sqlite3.open(path);
    db.execute('''
    CREATE TABLE IF NOT EXISTS product (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL,
      description TEXT UNIQUE NOT NULL,
      price REAL NOT NULL,
      discounted_price REAL,
      image_url TEXT,
      category_id TEXT,
      aisle_id TEXT,
      stock INTEGER,
      unit TEXT,
      reviews TEXT,
      is_popular BOOLEAN,
      is_trending BOOLEAN
    )
    ''');
    return db;
  }

  void insertData(
      {required String name,
      required String description,
      required double price,
      required double discountedPrice,
      required String imageUrl,
      required String categoryId,
      required String aisleId,
      required int stock,
      required String unit,
      required String reviews,
      required bool isPopular,
      required bool isTrending}) {
    final dbHelper = ProductDatabase();
    final db = dbHelper.database;
    db.execute('''
      INSERT INTO product ( name, description, price, discounted_price, image_url, category_id, aisle_id, stock, unit, reviews, is_popular, is_trending) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
      name,
      description,
      price,
      discountedPrice,
      imageUrl,
      categoryId,
      aisleId,
      stock,
      unit,
      reviews,
      isPopular,
      isTrending
    ]);
  }

  List<Map<String, dynamic>> queryData(String name) {
    final dbHelper = ProductDatabase();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM product
      WHERE name = ?
    ''', [name]);
    return rows;
  }

  void updateProduct(
      {required String name,
      required String description,
      required double price,
      required double discountedPrice,
      required String imageUrl,
      required String categoryId,
      required String aisleId,
      required int stock,
      required String unit,
      required String reviews,
      required bool isPopular,
      required bool isTrending}) async {
    final dbHelper = ProductDatabase();
    final db = dbHelper.database;
    db.execute('''
    UPDATE product SET name = ?, description = ?, price = ?, discounted_price = ?, image_url = ?, category_id = ?, aisle_id = ?, stock = ?, unit = ?, reviews = ?, is_popular = ?, is_trending = ?
    ''', [
      name,
      description,
      price,
      discountedPrice,
      imageUrl,
      categoryId,
      aisleId,
      stock,
      unit,
      reviews,
      isPopular,
      isTrending
    ]);
  }

  void updateProductFromJson(Map<String, dynamic> json) async {
    final dbHelper = ProductDatabase();
    final db = dbHelper.database;
    db.execute('''
    UPDATE product SET name = ?, description = ?, price = ?, discounted_price = ?, image_url = ?, category_id = ?, aisle_id = ?, stock = ?, unit = ?, reviews = ?, is_popular = ?, is_trending = ?
    ''', [
      json['name'],
      json['description'],
      json['price'],
      json['discounted_price'],
      json['image_url'],
      json['category_id'],
      json['aisle_id'],
      json['stock'],
      json['unit'],
      json['reviews'],
      json['is_popular'],
      json['is_trending']
    ]);
  }

  void deleteUser(int productId) async {
    final dbHelper = ProductDatabase();
    final db = dbHelper.database;
    db.execute('''
    DELETE FROM product WHERE id = ?
    ''', [productId]);
  }

  void closeDatabase() {
    final dbHelper = ProductDatabase();
    final db = dbHelper.database;
    db.dispose();
  }
}
