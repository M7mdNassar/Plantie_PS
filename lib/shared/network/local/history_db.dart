import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDBHelper {
  static final HistoryDBHelper _instance = HistoryDBHelper._internal();

  factory HistoryDBHelper() => _instance;
  static Database? _database;

  final String tableName = 'history';
  final String columnDiseaseKey = 'diseaseKey';
  final String columnId = 'id';
  final String columnImagePath = 'imagePath';
  final String columnDate = 'date';

  HistoryDBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'history.db');
    return await openDatabase(
      path,
      version: 2, // Increment version
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDiseaseKey TEXT,
            $columnImagePath TEXT,
            $columnDate TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE $tableName 
            RENAME COLUMN title TO $columnDiseaseKey
          ''');
          await db.execute('''
            ALTER TABLE $tableName 
            DROP COLUMN treatment
          ''');
        }
      },
    );
  }

  Future<int> insertHistory(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query(
      tableName,
      orderBy: '$columnId DESC',
      columns: [columnId, columnDiseaseKey, columnImagePath, columnDate],
    );
  }
}
