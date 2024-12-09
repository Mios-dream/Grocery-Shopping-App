import 'package:sqlite3/sqlite3.dart';

class UserDB {
  UserDB._internal();

  factory UserDB() => _instance;

  static final UserDB _instance = UserDB._internal();

  static Database? _database;

  Database get database {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }

  Database _initDatabase() {
    const path = 'database/grocify.db';
    final db = sqlite3.open(path)..execute('''
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

  void insertData(
    String email,
    String userName,
    String passwordHash, {
    String? phoneNumber,
  }) {
    /**
     * 插入数据
     * @param userName 用户名
     * @param passwordHash 密码哈希值
     * @param phoneNumber 手机号
     */
    final dbHelper = UserDB();
    final db = dbHelper.database;
    phoneNumber ??= '';
    db.execute(
      '''
      INSERT INTO user (email, username, password_hash, phone_number) VALUES (?, ?, ?, ?)
      ''',
      [email, userName, passwordHash, phoneNumber],
    );
  }

  List<Map<String, dynamic>> queryData(String email, String passwordHash) {
    final dbHelper = UserDB();
    final db = dbHelper.database;
    final rows = db.select('''
      SELECT * FROM user
      WHERE email = ?
      AND password_hash = ?
    ''', [email, passwordHash],);
    return rows;
  }

  void updateUser(String email, String userName, String passwordHash,
      {String phoneNumber = '',}) async {
    final dbHelper = UserDB();
    dbHelper.database.execute('''
    UPDATE user SET email = ?, username = ?, password_hash = ?, phone_number = ?
    ''', [email, userName, passwordHash, phoneNumber],);
  }

  void deleteUser(int userID) async {
    final dbHelper = UserDB();
    dbHelper.database.execute('''
    DELETE FROM user WHERE id = ?
    ''', [userID],);
  }

  void closeDatabase() {
    final dbHelper = UserDB();
    dbHelper.database.dispose();
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
