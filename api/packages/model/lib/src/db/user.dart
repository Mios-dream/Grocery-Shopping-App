import 'package:sqlite3/sqlite3.dart';

class UserDB {
  static final UserDB _instance = UserDB._internal();
  factory UserDB() => _instance;

  static Database? _database;

  UserDB._internal();

  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  Database _initDatabase() {
    const path = './db/grocify.db';
    Database db = sqlite3.open(path);
    db.execute('''
    CREATE TABLE IF NOT EXISTS user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE NOT NULL,
      username TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      phone_number TEXT
    )
    ''');
    return db;
  }

  void insertData(String email, String userName, String passwordHash,
      {String? phoneNumber}) {
    final dbHelper = UserDB();
    final db = dbHelper.database;
    phoneNumber ??= '';
    db.execute('''
      INSERT INTO user (email, username, password_hash, phone_number) VALUES (?, ?, ?, ?)
      ''', [userName, email, passwordHash, phoneNumber]);
  }

  List<Map<String, dynamic>> queryData(String email, String passwordHash) {
    final dbHelper = UserDB();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM user
      WHERE email = ?
      AND password_hash = ?
    ''', [email, passwordHash]);
    return rows;
  }

  void updateUser(String email, String userName, String passwordHash,
      {String phoneNumber = ''}) async {
    final dbHelper = UserDB();
    final db = dbHelper.database;

    db.execute('''
    UPDATE user SET email = ?, username = ?, password_hash = ?, phone_number = ?
    ''', [email, userName, passwordHash, phoneNumber]);
  }

  void deleteUser(int userID) async {
    final dbHelper = UserDB();
    final db = dbHelper.database;
    db.execute('''
    DELETE FROM user WHERE id = ?
    ''', [userID]);
  }

  void closeDatabase() {
    final dbHelper = UserDB();
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
