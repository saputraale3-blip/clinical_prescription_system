import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('drug_database.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {

    await db.execute('''
      CREATE TABLE drugs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dose TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.insert('drugs', {
      'name': 'Paracetamol',
      'dose': '500 mg',
      'category': 'Analgesic',
    });

    await db.insert('drugs', {
      'name': 'Amoxicillin',
      'dose': '500 mg',
      'category': 'Antibiotic',
    });

    await db.insert('drugs', {
      'name': 'Ibuprofen',
      'dose': '400 mg',
      'category': 'NSAID',
    });
  }

  Future<List<Map<String, dynamic>>> getDrugs() async {

    final db = await instance.database;

    return await db.query('drugs');
  }
}