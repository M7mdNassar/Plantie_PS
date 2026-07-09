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

  // Offline actions table
  static const String offlineTableName = 'offline_actions';
  static const String offlineColumnId = 'id';
  static const String offlineColumnType = 'action_type';
  static const String offlineColumnData = 'data';
  static const String offlineColumnUserId = 'user_id';
  static const String offlineColumnStatus = 'status';
  static const String offlineColumnAttempts = 'attempts';
  static const String offlineColumnCreatedAt = 'created_at';

  // Cached posts table
  static const String cachedPostsTable = 'cached_posts';
  static const String cachedPostId = 'post_id';
  static const String cachedPostData = 'post_data';
  static const String cachedAt = 'cached_at';

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
      version: 4, // ✅ Updated to 4 to include offline_actions and cached_posts
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDiseaseKey TEXT,
            $columnImagePath TEXT,
            $columnDate TEXT
          )
        ''');

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

        await db.execute('''
          CREATE TABLE $offlineTableName (
            $offlineColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $offlineColumnType TEXT NOT NULL,
            $offlineColumnData TEXT NOT NULL,
            $offlineColumnUserId TEXT NOT NULL,
            $offlineColumnStatus TEXT NOT NULL DEFAULT 'pending',
            $offlineColumnAttempts INTEGER DEFAULT 0,
            $offlineColumnCreatedAt TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE $cachedPostsTable (
            $cachedPostId TEXT PRIMARY KEY,
            $cachedPostData TEXT NOT NULL,
            $cachedAt TEXT NOT NULL
          )
        ''');

        await db.execute('''
  CREATE TABLE IF NOT EXISTS chat_history (
    session_id TEXT PRIMARY KEY,
    messages TEXT NOT NULL,
    updated_at TEXT NOT NULL
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
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $offlineTableName (
              $offlineColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $offlineColumnType TEXT NOT NULL,
              $offlineColumnData TEXT NOT NULL,
              $offlineColumnUserId TEXT NOT NULL,
              $offlineColumnStatus TEXT NOT NULL DEFAULT 'pending',
              $offlineColumnAttempts INTEGER DEFAULT 0,
              $offlineColumnCreatedAt TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $cachedPostsTable (
              $cachedPostId TEXT PRIMARY KEY,
              $cachedPostData TEXT NOT NULL,
              $cachedAt TEXT NOT NULL
            )
          ''');
        }

  //       if (oldVersion < 5) {
  //         await db.execute('''
  //   CREATE TABLE IF NOT EXISTS chat_history (
  //     session_id TEXT PRIMARY KEY,
  //     messages TEXT NOT NULL,
  //     updated_at TEXT NOT NULL
  //   )
  // ''');
  //       }
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
  Future<int> insertUploadQueueItem(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(uploadQueueTableName, row);
  }

  Future<List<Map<String, dynamic>>> getPendingUploadQueueItems() async {
    final db = await database;
    return await db.query(
      uploadQueueTableName,
      where: '$uploadQueueColumnUploaded = 0 AND $uploadQueueColumnUploadAttempts < 3',
      orderBy: '$uploadQueueColumnDetectedAt ASC',
    );
  }

  Future<int> markUploadQueueItemAsUploaded(int id) async {
    final db = await database;
    return await db.update(
      uploadQueueTableName,
      {uploadQueueColumnUploaded: 1},
      where: '$uploadQueueColumnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> incrementUploadAttempts(int id) async {
    final db = await database;
    final currentItem = await db.query(
      uploadQueueTableName,
      where: '$uploadQueueColumnId = ?',
      whereArgs: [id],
    );
    if (currentItem.isNotEmpty) {
      final currentAttempts = currentItem.first[uploadQueueColumnUploadAttempts] as int;
      return await db.update(
        uploadQueueTableName,
        {uploadQueueColumnUploadAttempts: currentAttempts + 1},
        where: '$uploadQueueColumnId = ?',
        whereArgs: [id],
      );
    }
    return 0;
  }

  Future<int> updateCorrectedLabel(int id, String correctedLabel) async {
    final db = await database;
    return await db.update(
      uploadQueueTableName,
      {uploadQueueColumnCorrectedLabel: correctedLabel},
      where: '$uploadQueueColumnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getUserUploadQueueItems(String userId) async {
    final db = await database;
    return await db.query(
      uploadQueueTableName,
      where: '$uploadQueueColumnSupabaseUserId = ?',
      whereArgs: [userId],
      orderBy: '$uploadQueueColumnDetectedAt DESC',
    );
  }

  Future<int> updateUserIdForQueueItems(String oldUserId, String newUserId) async {
    final db = await database;
    return await db.update(
      uploadQueueTableName,
      {uploadQueueColumnSupabaseUserId: newUserId},
      where: '$uploadQueueColumnSupabaseUserId = ?',
      whereArgs: [oldUserId],
    );
  }

  // ==================== OFFLINE ACTIONS ====================
  Future<int> insertOfflineAction(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(offlineTableName, data);
  }

  Future<List<Map<String, dynamic>>> getPendingOfflineActions() async {
    final db = await database;
    return await db.query(
      offlineTableName,
      where: '$offlineColumnStatus = ? AND $offlineColumnAttempts < 3',
      whereArgs: ['pending'],
      orderBy: '$offlineColumnCreatedAt ASC',
    );
  }

  Future<void> updateOfflineActionStatus(int id, String status, {int? attempts}) async {
    final db = await database;
    final updates = <String, dynamic>{offlineColumnStatus: status};
    if (attempts != null) updates[offlineColumnAttempts] = attempts;
    await db.update(
      offlineTableName,
      updates,
      where: '$offlineColumnId = ?',
      whereArgs: [id],
    );
  }

  // ==================== CACHED POSTS ====================
  Future<void> insertCachedPost(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(cachedPostsTable, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCachedPosts() async {
    final db = await database;
    return await db.query(cachedPostsTable, orderBy: '$cachedAt DESC');
  }

  Future<void> clearCachedPosts() async {
    final db = await database;
    await db.delete(cachedPostsTable);
  }



  Future<int> getPendingUploadQueueItemsCount() async {
    final db = await database;
    final result = await db.query(
      uploadQueueTableName,
      where: '$uploadQueueColumnUploaded = 0 AND $uploadQueueColumnUploadAttempts < 3',
    );
    return result.length;
  }

  Future<int> getPendingOfflineActionsCount() async {
    final db = await database;
    final result = await db.query(
      offlineTableName,
      where: '$offlineColumnStatus = ? AND $offlineColumnAttempts < 3',
      whereArgs: ['pending'],
    );
    return result.length;
  }
}