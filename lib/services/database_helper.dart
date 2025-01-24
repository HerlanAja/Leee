import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tile/models/berita.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'berita.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE berita(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT,
            image TEXT,
            favorit INTEGER,
            deskripsi TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertBerita(Berita berita) async {
    final db = await database;
    await db.insert(
      'berita',
      berita.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Berita>> getBerita() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('berita');
    return List.generate(maps.length, (i) {
      return Berita.fromMap(maps[i]);
    });
  }

  Future<void> updateBerita(Berita berita) async {
    final db = await database;
    await db.update(
      'berita',
      berita.toMap(),
      where: 'id = ?',
      whereArgs: [berita.id],
    );
  }

  Future<void> deleteBerita(int id) async {
    final db = await database;
    await db.delete(
      'berita',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
