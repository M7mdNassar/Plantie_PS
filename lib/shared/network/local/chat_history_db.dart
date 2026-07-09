// import 'dart:convert';
// import 'package:sqflite/sqflite.dart';
// import '../../../models/chat_message.dart';
// import 'history_db.dart';
//
// class ChatHistoryDB {
//   static const String _table = 'chat_history';
//
//   Future<Database> _getDb() async {
//     return HistoryDBHelper().database;
//   }
//
//   Future<void> saveConversation(String sessionId, List<ChatMessage> messages) async {
//     final db = await _getDb();
//     final json = jsonEncode(messages.map((m) => m.toJson()).toList());
//     await db.insert(
//       _table,
//       {
//         'session_id': sessionId,
//         'messages': json,
//         'updated_at': DateTime.now().toIso8601String(),
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<List<ChatMessage>?> getConversation(String sessionId) async {
//     final db = await _getDb();
//     final result = await db.query(
//       _table,
//       where: 'session_id = ?',
//       whereArgs: [sessionId],
//     );
//     if (result.isEmpty) return null;
//     final json = result.first['messages'] as String;
//     final list = jsonDecode(json) as List;
//     return list.map((e) => ChatMessage.fromJson(e)).toList();
//   }
//
//   Future<void> deleteConversation(String sessionId) async {
//     final db = await _getDb();
//     await db.delete(_table, where: 'session_id = ?', whereArgs: [sessionId]);
//   }
//
//   Future<void> createTable(Database db) async {
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $_table (
//         session_id TEXT PRIMARY KEY,
//         messages TEXT NOT NULL,
//         updated_at TEXT NOT NULL
//       )
//     ''');
//   }
// }