import 'package:sqlite3/sqlite3.dart';

class UsersDatabase {
  static final UsersDatabase _instance = UsersDatabase._internal();
  factory UsersDatabase() => _instance;

  static Database? _database;

  UsersDatabase._internal();

  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  Database _initDatabase() {
    const path = './database/app_database.db';
    Database db = sqlite3.open(path);
    db.execute('''
    CREATE TABLE IF NOT EXISTS user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      phone_number TEXT
    )
    ''');
    return db;
  }

  void insertData(String userName, String email, String passwordHash,
      {String? phoneNumber}) {
    final dbHelper = UsersDatabase();
    final db = dbHelper.database;
    phoneNumber ??= '';
    db.execute('''
      INSERT INTO user (username, email, password_hash, phone_number) VALUES (?, ?, ?, ?)
      ''', [userName, email, passwordHash, phoneNumber]);
  }

  List<Map<String, dynamic>> queryData(String email,String passwordHash) {
    final dbHelper = UsersDatabase();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM user
      WHERE email = ?
      AND password_hash = ?
    ''',[email,passwordHash]);
    return rows;
  }

  void updateUser(String userName, String email, String passwordHash,
      {String phoneNumber = ''}) async {
    final dbHelper = UsersDatabase();
    final db = dbHelper.database;

    db.execute('''
    UPDATE user SET username = ?, email = ?, password_hash = ?, phone_number = ?
    ''', [userName, email, passwordHash, phoneNumber]);
  }

  void deleteUser(int userId) async {
    final dbHelper = UsersDatabase();
    final db = dbHelper.database;
    db.execute('''
    DELETE FROM user WHERE id = ?
    ''', [userId]);
  }

  void closeDatabase() {
    final dbHelper = UsersDatabase();
    final db = dbHelper.database;
    db.dispose();
  }
}

// void main() {
//   // 获取数据库实例
//   final dbHelper = DatabaseHelper();
//   dbHelper.insertData('John Doe', 'johndoe@example.com', 'password123',phoneNumber: '123456789');
//   print(dbHelper.queryData('johndoe@example.com'));
//   dbHelper.updateUser('John Doe', 'johndoe@example.com', 'new_password',phoneNumber: '21');
//   print(dbHelper.queryData("johndoe@example.com"));
//   List<Map<String, dynamic>> rows = dbHelper.queryData("johndoe@example.com");
//   dbHelper.deleteUser(rows[0]['id']);
//   print(dbHelper.queryData("johndoe@example.com"));
//
// }
