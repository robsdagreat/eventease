import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'event_ease.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Events table
    await db.execute('''
      CREATE TABLE events(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        event_type TEXT NOT NULL,
        venue_id TEXT NOT NULL,
        venue_name TEXT NOT NULL,
        user_id TEXT NOT NULL,
        organizer_name TEXT NOT NULL,
        is_public INTEGER NOT NULL,
        expected_attendees INTEGER NOT NULL,
        image_url TEXT,
        status TEXT NOT NULL,
        ticket_price REAL,
        tags TEXT,
        contact_email TEXT,
        contact_phone TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Venues table
    await db.execute('''
      CREATE TABLE venues(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        location TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        country TEXT NOT NULL,
        postal_code TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        venue_type TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        rating REAL NOT NULL,
        amenities TEXT NOT NULL,
        images TEXT NOT NULL,
        contact_email TEXT,
        contact_phone TEXT,
        website TEXT,
        pricing TEXT,
        special_offers TEXT,
        is_available INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Specials table
    await db.execute('''
      CREATE TABLE specials(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        venue_id TEXT NOT NULL,
        venue_name TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        type TEXT NOT NULL,
        discount_percentage REAL NOT NULL,
        image_url TEXT,
        is_active INTEGER NOT NULL,
        terms TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  // Event CRUD operations
  Future<void> insertEvent(Event event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  Future<Event?> getEvent(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Event.fromJson(maps.first);
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  // Venue CRUD operations
  Future<void> insertVenue(Venue venue) async {
    final db = await database;
    await db.insert(
      'venues',
      venue.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Venue>> getVenues() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('venues');
    return List.generate(maps.length, (i) => Venue.fromJson(maps[i]));
  }

  Future<Venue?> getVenue(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'venues',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Venue.fromJson(maps.first);
  }

  Future<void> updateVenue(Venue venue) async {
    final db = await database;
    await db.update(
      'venues',
      venue.toJson(),
      where: 'id = ?',
      whereArgs: [venue.id],
    );
  }

  Future<void> deleteVenue(String id) async {
    final db = await database;
    await db.delete('venues', where: 'id = ?', whereArgs: [id]);
  }

  // Special CRUD operations
  Future<void> insertSpecial(Special special) async {
    final db = await database;
    await db.insert(
      'specials',
      special.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Special>> getSpecials() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('specials');
    return List.generate(maps.length, (i) => Special.fromJson(maps[i]));
  }

  Future<Special?> getSpecial(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'specials',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Special.fromJson(maps.first);
  }

  Future<void> updateSpecial(Special special) async {
    final db = await database;
    await db.update(
      'specials',
      special.toJson(),
      where: 'id = ?',
      whereArgs: [special.id],
    );
  }

  Future<void> deleteSpecial(String id) async {
    final db = await database;
    await db.delete('specials', where: 'id = ?', whereArgs: [id]);
  }
}
