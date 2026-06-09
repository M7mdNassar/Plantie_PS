import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDBHelper {
  static final HistoryDBHelper _instance = HistoryDBHelper._internal();

  factory HistoryDBHelper() => _instance;
  static Database? _database;

  // History table columns
  final String tableName = 'history';
  final String columnDiseaseKey = 'diseaseKey';
  final String columnId = 'id';
  final String columnImagePath = 'imagePath';
  final String columnDate = 'date';

  // Upload queue table columns
  final String uploadQueueTableName = 'detection_upload_queue';
  final String uploadQueueColumnId = 'id';
  final String uploadQueueColumnImagePath = 'local_image_path';
  final String uploadQueueColumnPredictedClass = 'predicted_class';
  final String uploadQueueColumnConfidenceScore = 'confidence_score';
  final String uploadQueueColumnCorrectedLabel = 'user_corrected_label';
  final String uploadQueueColumnPlantType = 'plant_type';
  final String uploadQueueColumnDetectedAt = 'detected_at';
  final String uploadQueueColumnSupabaseUserId = 'supabase_user_id';
  final String uploadQueueColumnUploaded = 'uploaded';
  final String uploadQueueColumnUploadAttempts = 'upload_attempts';

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
      version: 3, // Incremented version for new table
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDiseaseKey TEXT,
            $columnImagePath TEXT,
            $columnDate TEXT
          )
        ''');

        // Create upload queue table
        await db.execute('''
          CREATE TABLE $uploadQueueTableName (
            $uploadQueueColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $uploadQueueColumnImagePath TEXT NOT NULL,
            $uploadQueueColumnPredictedClass TEXT NOT NULL,
            $uploadQueueColumnConfidenceScore REAL NOT NULL,
            $uploadQueueColumnCorrectedLabel TEXT,
            $uploadQueueColumnPlantType TEXT NOT NULL,
            $uploadQueueColumnDetectedAt TEXT NOT NULL,
            $uploadQueueColumnSupabaseUserId TEXT NOT NULL,
            $uploadQueueColumnUploaded INTEGER NOT NULL DEFAULT 0,
            $uploadQueueColumnUploadAttempts INTEGER NOT NULL DEFAULT 0
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
        if (oldVersion < 3) {
          // Create upload queue table if upgrading from version < 3
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $uploadQueueTableName (
              $uploadQueueColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $uploadQueueColumnImagePath TEXT NOT NULL,
              $uploadQueueColumnPredictedClass TEXT NOT NULL,
              $uploadQueueColumnConfidenceScore REAL NOT NULL,
              $uploadQueueColumnCorrectedLabel TEXT,
              $uploadQueueColumnPlantType TEXT NOT NULL,
              $uploadQueueColumnDetectedAt TEXT NOT NULL,
              $uploadQueueColumnSupabaseUserId TEXT NOT NULL,
              $uploadQueueColumnUploaded INTEGER NOT NULL DEFAULT 0,
              $uploadQueueColumnUploadAttempts INTEGER NOT NULL DEFAULT 0
            )
          ''');
        }
      },
    );
  }

  // ==================== HISTORY TABLE METHODS ====================

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

  // ==================== UPLOAD QUEUE TABLE METHODS ====================

  /// Insert a detection result into the upload queue
  Future<int> insertUploadQueueItem(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(uploadQueueTableName, row);
  }

  /// Get all pending upload queue items (not yet uploaded, attempts < 3)
  Future<List<Map<String, dynamic>>> getPendingUploadQueueItems() async {
    final db = await database;
    return await db.query(
      uploadQueueTableName,
      where:
          '$uploadQueueColumnUploaded = 0 AND $uploadQueueColumnUploadAttempts < 3',
      orderBy: '$uploadQueueColumnDetectedAt ASC',
    );
  }

  /// Update upload queue item after successful upload
  Future<int> markUploadQueueItemAsUploaded(int id) async {
    final db = await database;
    return await db.update(
      uploadQueueTableName,
      {uploadQueueColumnUploaded: 1},
      where: '$uploadQueueColumnId = ?',
      whereArgs: [id],
    );
  }

  /// Increment upload attempts for a queue item
  Future<int> incrementUploadAttempts(int id) async {
    final db = await database;
    final currentItem = await db.query(
      uploadQueueTableName,
      where: '$uploadQueueColumnId = ?',
      whereArgs: [id],
    );

    if (currentItem.isNotEmpty) {
      final currentAttempts =
          currentItem.first[uploadQueueColumnUploadAttempts] as int;
      return await db.update(
        uploadQueueTableName,
        {uploadQueueColumnUploadAttempts: currentAttempts + 1},
        where: '$uploadQueueColumnId = ?',
        whereArgs: [id],
      );
    }
    return 0;
  }

  /// Update user_corrected_label for a queue item
  Future<int> updateCorrectedLabel(int id, String correctedLabel) async {
    final db = await database;
    return await db.update(
      uploadQueueTableName,
      {uploadQueueColumnCorrectedLabel: correctedLabel},
      where: '$uploadQueueColumnId = ?',
      whereArgs: [id],
    );
  }

  /// Get all upload queue items for a user
  Future<List<Map<String, dynamic>>> getUserUploadQueueItems(
      String userId) async {
    final db = await database;
    return await db.query(
      uploadQueueTableName,
      where: '$uploadQueueColumnSupabaseUserId = ?',
      whereArgs: [userId],
      orderBy: '$uploadQueueColumnDetectedAt DESC',
    );
  }

  /// Update supabase_user_id for all items with old user ID (for guest to auth upgrade)
  Future<int> updateUserIdForQueueItems(
      String oldUserId, String newUserId) async {
    final db = await database;
    return await db.update(
      uploadQueueTableName,
      {uploadQueueColumnSupabaseUserId: newUserId},
      where: '$uploadQueueColumnSupabaseUserId = ?',
      whereArgs: [oldUserId],
    );
  }
}
