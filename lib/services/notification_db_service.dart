import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotificationDBService {
  static final NotificationDBService _instance =
      NotificationDBService._internal();
  static Database? _database;

  factory NotificationDBService() => _instance;

  NotificationDBService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notifications.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertNotification(String title, String body) async {
    final db = await database;
    await db.insert(
      'notifications',
      {
        'title': title,
        'body': body,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query('notifications', orderBy: 'timestamp DESC');
  }
}
