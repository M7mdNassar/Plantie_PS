import 'dart:convert';
import '../../../models/chat_message.dart';
import 'history_db.dart';

class ChatHistoryDB {
  final HistoryDBHelper _helper = HistoryDBHelper();

  Future<void> saveConversation(String conversationId, List<ChatMessage> messages) async {
    final json = jsonEncode(messages.map((m) => m.toJson()).toList());
    await _helper.saveChatConversation(
      conversationId,
      json,
      DateTime.now().toIso8601String(),
    );
  }

  Future<List<ChatMessage>?> getConversation(String conversationId) async {
    final data = await _helper.getChatConversation(conversationId);
    if (data == null) return null;
    final json = data['messages'] as String;
    final list = jsonDecode(json) as List;
    return list.map((e) => ChatMessage.fromJson(e)).toList();
  }

  Future<void> deleteConversation(String conversationId) async {
    await _helper.deleteChatConversation(conversationId);
  }
}