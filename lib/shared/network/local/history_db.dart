import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDBHelper {
  static final HistoryDBHelper _instance = HistoryDBHelper._internal();
  factory HistoryDBHelper() => _instance;
  static Database? _database;

  final String tableName = 'history';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnTreatment = 'treatment';
  final String columnImagePath = 'imagePath';
  final String columnDate = 'date';

  HistoryDBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'plantie_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT,
            $columnTreatment TEXT,
            $columnImagePath TEXT,
            $columnDate TEXT
          )
        ''');
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
      columns: [columnId, columnTitle, columnTreatment, columnImagePath, columnDate],
    );
  }
}
