import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'user_model.dart';
import 'package:sqlite_inspector/sqlite_inspector.dart';
import '../models/review.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

 Future<Database> _initDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'app.db');
  return await openDatabase(
    path,
    version: 5,  // увеличили версию
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 5) {           //увеличиваем версию
    await db.execute('''
      CREATE TABLE IF NOT EXISTS routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        price TEXT,
        duration TEXT,
        audience TEXT,
        imageUrl TEXT,
        isPopular INTEGER DEFAULT 0,
        seats INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS route_points (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        routeId INTEGER NOT NULL,
        name TEXT NOT NULL,
        orderIndex INTEGER DEFAULT 0,
        FOREIGN KEY (routeId) REFERENCES routes (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
  CREATE TABLE museum_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    address TEXT,
    contacts TEXT,
    working_hours TEXT,
    imageUrl TEXT
  )
''');
    await db.execute('''
  CREATE TABLE visitor_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    working_hours TEXT,
    contact_phone TEXT,
    email TEXT,
    rules TEXT,
    how_to_get TEXT
  )
''');
    await db.execute('''
  CREATE TABLE reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    route_id INTEGER NOT NULL,
    rating INTEGER,
    comment TEXT,
    quick_options TEXT,
    created_at TEXT,
    admin_reply TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (route_id) REFERENCES routes (id) ON DELETE CASCADE
  )
''');
  }
}

  Future<void> _onCreate(Database db, int version) async {
    // Таблица пользователей
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    // Можно сразу добавить тестового пользователя (опционально)
    // await db.insert('users', {'name': 'Тест', 'email': 'test@test.ru', 'password': '123'});
    
    await db.execute('''
  CREATE TABLE routes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    price TEXT,
    duration TEXT,
    audience TEXT,
    imageUrl TEXT,
    isPopular INTEGER DEFAULT 0,
    seats INTEGER DEFAULT 0
  )
''');

await db.execute('''
  CREATE TABLE route_points (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    routeId INTEGER NOT NULL,
    name TEXT NOT NULL,
    orderIndex INTEGER DEFAULT 0,
    FOREIGN KEY (routeId) REFERENCES routes (id) ON DELETE CASCADE
  )
''');
  await db.execute('''
  CREATE TABLE museum_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    address TEXT,
    contacts TEXT,
    working_hours TEXT,
    imageUrl TEXT
  )
''');
    await db.execute('''
  CREATE TABLE visitor_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    working_hours TEXT,
    contact_phone TEXT,
    email TEXT,
    rules TEXT,
    how_to_get TEXT
  )
''');
    await db.execute('''
  CREATE TABLE reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    route_id INTEGER NOT NULL,
    rating INTEGER,
    comment TEXT,
    quick_options TEXT,
    created_at TEXT,
    admin_reply TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (route_id) REFERENCES routes (id) ON DELETE CASCADE
  )
''');
  }

  // ---------- CRUD для пользователей ----------
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }
    static Future<void> startSqlInspector() async {
    await SqliteInspector.start();
    print('🔍 SQLite Inspector is running!');
  }

  // ---- Маршруты ----
Future<int> insertRoute(Map<String, dynamic> route) async {
  final db = await database;
  return await db.insert('routes', route);
}

Future<int> updateRoute(int id, Map<String, dynamic> route) async {
  final db = await database;
  return await db.update('routes', route, where: 'id = ?', whereArgs: [id]);
}

Future<int> deleteRoute(int id) async {
  final db = await database;
  // точки удалятся автоматически благодаря ON DELETE CASCADE
  return await db.delete('routes', where: 'id = ?', whereArgs: [id]);
}

Future<List<Map<String, dynamic>>> getAllRoutes() async {
  final db = await database;
  return await db.query('routes', orderBy: 'id DESC');
}

Future<Map<String, dynamic>?> getRouteById(int id) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'routes',
    where: 'id = ?',
    whereArgs: [id],
  );
  if (maps.isNotEmpty) return maps.first;
  return null;
}

// ---- Точки маршрута ----
Future<int> insertRoutePoint(Map<String, dynamic> point) async {
  final db = await database;
  return await db.insert('route_points', point);
}

Future<int> updateRoutePoint(int id, Map<String, dynamic> point) async {
  final db = await database;
  return await db.update('route_points', point, where: 'id = ?', whereArgs: [id]);
}

Future<int> deleteRoutePoint(int id) async {
  final db = await database;
  return await db.delete('route_points', where: 'id = ?', whereArgs: [id]);
}

Future<List<Map<String, dynamic>>> getRoutePoints(int routeId) async {
  final db = await database;
  return await db.query(
    'route_points',
    where: 'routeId = ?',
    whereArgs: [routeId],
    orderBy: 'orderIndex',
  );
}

// Удалить все точки маршрута (при перезаписи)
Future<int> deleteRoutePointsByRouteId(int routeId) async {
  final db = await database;
  return await db.delete('route_points', where: 'routeId = ?', whereArgs: [routeId]);
}

// ---- Музейная информация ----
Future<void> insertMuseumInfo(Map<String, dynamic> info) async {
  final db = await database;
  await db.insert('museum_info', info);
}

Future<void> updateMuseumInfo(Map<String, dynamic> info) async {
  final db = await database;
  await db.update('museum_info', info, where: 'id = ?', whereArgs: [info['id']]);
}

Future<Map<String, dynamic>?> getMuseumInfo() async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query('museum_info');
  if (result.isNotEmpty) return result.first;
  return null;
}
// ---- Информация для посетителей ----
Future<void> insertVisitorInfo(Map<String, dynamic> info) async {
  final db = await database;
  await db.insert('visitor_info', info);
}

Future<void> updateVisitorInfo(Map<String, dynamic> info) async {
  final db = await database;
  await db.update('visitor_info', info, where: 'id = ?', whereArgs: [info['id']]);
}

Future<Map<String, dynamic>?> getVisitorInfo() async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query('visitor_info');
  if (result.isNotEmpty) return result.first;
  return null;
}

// ---- Отзывы ----
Future<int> insertReview(Review review) async {
  final db = await database;
  return await db.insert('reviews', review.toMap());
}

Future<List<Review>> getAllReviews() async {
  final db = await database;
  final maps = await db.query('reviews', orderBy: 'created_at DESC');
  return maps.map((map) => Review.fromMap(map)).toList();
}

Future<void> updateReviewAdminReply(int reviewId, String reply) async {
  final db = await database;
  await db.update('reviews', {'admin_reply': reply}, where: 'id = ?', whereArgs: [reviewId]);
}
}